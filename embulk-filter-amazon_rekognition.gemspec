
Gem::Specification.new do |spec|
  spec.name          = "embulk-filter-amazon_rekognition"
  spec.version       = "0.1.1"
  spec.authors       = ["toyama0919"]
  spec.summary       = "Amazon Rekognition filter plugin for Embulk"
  spec.description   = "Amazon Rekognition"
  spec.email         = ["toyama0919@gmail.com"]
  spec.licenses      = ["MIT"]
  spec.homepage      = "https://github.com/toyama0919/embulk-filter-amazon_rekognition"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'aws-sdk'
  spec.add_dependency 'addressable'
  spec.add_development_dependency 'embulk', ['>= 0.8.16']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
