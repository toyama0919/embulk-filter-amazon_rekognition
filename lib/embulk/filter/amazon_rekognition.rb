require 'aws-sdk'
require 'addressable/uri'

module Embulk
  module Filter
    class AmazonRekognition < FilterPlugin
      Plugin.register_filter("amazon_rekognition", self)
      ENABLE_API = ['detect_faces', 'detect_labels']

      def self.transaction(config, in_schema, &control)
        task = {
          "api_type" => config.param("api_type", :string),
          "out_key_name" => config.param("out_key_name", :string),
          "image_path_key_name" => config.param("image_path_key_name", :string),
          "delay" => config.param("delay", :integer, default: 0),
          "aws_access_key_id" => config.param("aws_access_key_id", :string, default: nil),
          "aws_secret_access_key" => config.param("aws_secret_access_key", :string, default: nil),
          "aws_region" => config.param("aws_region", :string, default: 'us-east-1'),
        }

        unless ENABLE_API.include?(task['api_type'])
          raise ConfigError.new "Not support api => [#{task['api_type']}]"
        end

        Embulk.logger.info "api => [#{task['api_type']}]"

        add_columns = [
          Column.new(nil, task["out_key_name"], :json)
        ]

        out_columns = in_schema + add_columns

        yield(task, out_columns)
      end

      def init
        @image_path_key_name = task['image_path_key_name']
        @delay = task['delay']
        @api_type = task['api_type'].to_sym
        @client = Aws::Rekognition::Client.new(
          access_key_id: task['aws_access_key_id'],
          secret_access_key: task['aws_secret_access_key'],
          region: task['aws_region']
        )
      end

      def close
      end

      def add(page)
        page.each do |record|
          hash = Hash[in_schema.names.zip(record)]
          image_path = hash[@image_path_key_name]
          Embulk.logger.info "Amazon Rekognition #{@api_type} processing.. #{image_path}"
          page_builder.add(hash.values + [get_response(image_path)])
          sleep @delay
        end
      end

      def finish
        page_builder.finish
      end

      def get_response(image_path)
        image_params = get_image_params(image_path)
        resp = @client.send(
                 @api_type,
                 { image: image_params }
               )
        resp.to_h
      rescue => e
        Embulk.logger.warn "#{image_path}\n#{e.message}\n#{e.backtrace.join("\n")}"
        return { error_message: e.message }
      end

      def get_image_params(image_path)
        if image_path =~ /s3\:\/\//
          s3_uri = URI.parse(image_path)
          return {
              s3_object: {
                bucket: s3_uri.host, 
                name: s3_uri.path, 
              }
            }
        elsif image_path =~ /https?\:\/\//
          response = Net::HTTP.get_response(Addressable::URI.parse(image_path))
          return { bytes: response.body }
        else
          return { bytes: File.read(image_path) }
        end
      end
    end
  end
end
