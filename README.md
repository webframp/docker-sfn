# SFN docker 

A simple `sfn` container that can run the
[sparkleformation](http://sparkleformation.io/) command line tool.

This configuration includes currently available [sparkle packs
](http://www.sparkleformation.io/docs/sparkle_formation/sparkle-packs.html) and
[callbacks](http://www.sparkleformation.io/docs/sfn/callbacks.html).

### SparklePacks

A few sparklepacks are included to get you started.

* [AWS Availability Zones](https://github.com/reverseskate/sparkle-pack-aws-availability-zones)
* [AWS VPC](https://github.com/reverseskate/sparkle-pack-aws-vpc)
* [AWS AMIs](https://github.com/reverseskate/sparkle-pack-aws-amis)

### Callbacks

The following callbacks are included.

* [SFN Parameters](https://rubygems.org/gems/sfn-parameters)
* [SFN Lambda](https://github.com/sparkleformation/sfn-lambda)

## Usage

You should have a basic `.sfn` config such as:
```rb
Configuration.new do
  apply_nesting 'deep'
  nesting_bucket 'SparkleStacks'
  processing true
  sparkle_pack %w[sparkle-pack-aws-availability-zones
                  sparkle-pack-aws-vpc
                  sparkle-pack-aws-amis]
  options do
    on_failure 'nothing'
    notification_topics []
    capabilities %w[CAPABILITY_IAM
                    CAPABILITY_NAMED_IAM]
  end
  credentials do
    provider :aws
    aws_region ENV.fetch('AWS_REGION', 'us-east-1')
    aws_bucket_region ENV.fetch('AWS_REGION', 'us-east-1')
    if ENV['AWS_ACCESS_KEY_ID']
      aws_access_key_id ENV.fetch('AWS_ACCESS_KEY_ID', '')
      aws_secret_access_key ENV.fetch('AWS_SECRET_ACCESS_KEY', '')
    else
      aws_profile_name ENV['AWS_PROFILE'] || 'default'
    end
  end
  callbacks do
    require ['sfn-parameters', 'sfn-lambda']
    default %w[parameters_stacks lambda]
  end
  lambda do
    directory './lambda'
  end
end
```

Then create a shell alias like this

```sh
sfn(){
    docker run --rm -it \
           -e AWS_PROFILE \
           -v "${PWD}:/repo" \
           -v "${HOME}/.aws:/root/.aws" \
           -w "/repo" \
           --name sfn \
           webframp/sfn "$@"
}
```
Note: This assumes you are using a profile stored in `~/.aws/credentials`, adjust as needed.

Finally run: `sfn list`
