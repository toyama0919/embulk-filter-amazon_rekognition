# Amazon Rekognition filter plugin for Embulk

* [Amazon Rekognition \| AWS](https://aws.amazon.com/jp/rekognition/)
* [Amazon Rekognition – Image Detection and Recognition Powered by Deep Learning \| AWS Blog](https://aws.amazon.com/jp/blogs/aws/amazon-rekognition-image-detection-and-recognition-powered-by-deep-learning/)
* [Class: Aws::Rekognition::Client — AWS SDK for Ruby V2](https://docs.aws.amazon.com/sdkforruby/api/Aws/Rekognition/Client.html)

## Overview

* **Plugin type**: filter

## Configuration

- **api_type**: api_type. detect_faces or detect_labels.(string)
- **out_key_name**: out_key_name(string)
- **image_path_key_name**: image_path_key_name(string)
- **delay**: delay(integer, default: 0)
- **aws_access_key_id**: aws_access_key_id(string, default: nil)
- **aws_region**: aws_region(string, default: 'us-east-1')

## Example

```yaml
filters:
  - type: amazon_rekognition
    api_type: detect_labels
    out_key_name: amazon_rekognition_info
    image_path_key_name: image_path
```


## Build

```
$ rake
```
