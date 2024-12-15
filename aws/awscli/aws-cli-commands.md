---
title: aws-cli-commands
categories:
  - aws
  - software
  - notes
  - guides
author: monocodes
url: https://github.com/monocodes/snippets.git
---

- [awscli moving templates](#awscli-moving-templates)

## awscli moving templates

You cannot copy the launch template to another region, however, you can use aws cli to get launch template data and then create a template in the target region with the launch template details

Get: <https://docs.aws.amazon.com/cli/latest/reference/ec2/get-launch-template-data.html>

Create: <https://docs.aws.amazon.com/cli/latest/reference/ec2/create-launch-template.html>

- awscli example

  ```sh
  aws ec2 create-launch-template \
      --launch-template-name TemplateForWebServer \
      --version-description WebVersion1 \
      --launch-template-data '{"NetworkInterfaces":[{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Ipv6AddressCount":1,"SubnetId":"subnet-7b16de0c"}],"ImageId":"ami-8c1be5f6","InstanceType":"t2.small","TagSpecifications":[{"ResourceType":"instance","Tags":[{"Key":"purpose","Value":"webserver"}]}]}'
  ```

- awscli template copy without `UserData`

  ```sh
  aws ec2 create-launch-template \
      --launch-template-name tpl-ts-exit-node-aws-eu-de \
      --version-description v1 \
      --launch-template-data '{"NetworkInterfaces":[{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-08f1ee3b714683fa7"],"Ipv6AddressCount":1,"SubnetId":"subnet-09efe403ef284cdb6","PrimaryIpv6":true}],"ImageId":"ami-02d9d83052ced9fdd","InstanceType":"t4g.small","KeyName":"skuznetsov","UserData":"","TagSpecifications":[{"ResourceType":"instance","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]},{"ResourceType":"volume","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]},{"ResourceType":"network-interface","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]}],"MetadataOptions":{"HttpTokens":"required","HttpPutResponseHopLimit":2,"HttpEndpoint":"enabled"}}'
  ```

- template json without `UserData` one-line

  ```sh
  {"NetworkInterfaces":[{"AssociatePublicIpAddress":true,"DeviceIndex":0,"Groups":["sg-08f1ee3b714683fa7"],"Ipv6AddressCount":1,"SubnetId":"subnet-09efe403ef284cdb6","PrimaryIpv6":true}],"ImageId":"ami-02d9d83052ced9fdd","InstanceType":"t4g.small","KeyName":"skuznetsov","UserData":"","TagSpecifications":[{"ResourceType":"instance","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]},{"ResourceType":"volume","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]},{"ResourceType":"network-interface","Tags":[{"Key":"Project","Value":"ts-exit-nodes"}]}],"MetadataOptions":{"HttpTokens":"required","HttpPutResponseHopLimit":2,"HttpEndpoint":"enabled"}}
  ```

- template json without `UserData`

  ```json
  {
                  "NetworkInterfaces": [
                      {
                          "AssociatePublicIpAddress": true,
                          "DeviceIndex": 0,
                          "Groups": [
                              "sg-08f1ee3b714683fa7"
                          ],
                          "Ipv6AddressCount": 1,
                          "SubnetId": "subnet-09efe403ef284cdb6",
                          "PrimaryIpv6": true
                      }
                  ],
                  "ImageId": "ami-02d9d83052ced9fdd",
                  "InstanceType": "t4g.small",
                  "KeyName": "skuznetsov",
                  "UserData": "",
                  "TagSpecifications": [
                      {
                          "ResourceType": "instance",
                          "Tags": [
                              {
                                  "Key": "Project",
                                  "Value": "ts-exit-nodes"
                              }
                          ]
                      },
                      {
                          "ResourceType": "volume",
                          "Tags": [
                              {
                                  "Key": "Project",
                                  "Value": "ts-exit-nodes"
                              }
                          ]
                      },
                      {
                          "ResourceType": "network-interface",
                          "Tags": [
                              {
                                  "Key": "Project",
                                  "Value": "ts-exit-nodes"
                              }
                          ]
                      }
                  ],
                  "MetadataOptions": {
                      "HttpTokens": "required",
                      "HttpPutResponseHopLimit": 2,
                      "HttpEndpoint": "enabled"
                  }
              }
          }
  ```
