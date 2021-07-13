# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v0.3.0"></a>
## [v0.3.0] - 2021-07-13

- eventbridge: add submodule ([#6](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/6))
- cloudwatch_logs_subscription: allow overriding role ([#7](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/7))
- cloudwatch_metrics: move to native terraform definition ([#5](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/5))
- cloudwatch_logs_subscription: rename variable
- Lower buffering defaults ([#4](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/4))
- Bump aws version requirement ([#3](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/3))
- cloudwatch_logs_subscription: add submodule for cw logs


<a name="v0.2.0"></a>
## [v0.2.0] - 2021-05-13

- Bump CHANGELOG
- Bump pre-commit ([#1](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/1))
- Add cloudwatch_metrics submodule ([#2](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/2))
- README fixes


<a name="v0.1.0"></a>
## v0.1.0 - 2020-12-03

- Add LICENSE
- Add configurable prefix for IAM role and policies
- Create backup S3 bucket if not provided
- Conditionally export firehose policy
- First commit


[Unreleased]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.3.0...HEAD
[v0.3.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.1.0...v0.2.0
