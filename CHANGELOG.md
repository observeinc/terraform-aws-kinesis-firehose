# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v1.0.0"></a>
## [v1.0.0] - 2022-08-16

- chore: bump CHANGELOG
- fix!: remove cloudwatch_logs_subscription submodue ([#21](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/21))
- feat!: migrate to per-customer collector endpoint ([#22](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/22))
- fix!: move submodules to modules/ ([#15](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/15))
- chore: update pre-commit hooks
- Correction of EKS readme to supply EKS ARN instead of EKS name


<a name="v0.5.0"></a>
## [v0.5.0] - 2022-03-15

- chore: update CHANGELOG
- chore: remove copy-pasta'd workflow
- chore: update pre-commit hooks ([#18](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/18))
- chore: add pre-commit autoupdate workflow ([#16](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/16))
- feat: introduce observe_domain var ([#14](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/14))
- feat: add cross-account usage example ([#13](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/13))


<a name="v0.4.0"></a>
## [v0.4.0] - 2022-02-15

- chore: update CHANGELOG
- fix: pin upperbound AWS version ([#12](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/12))
- fix: adjust EKS variables, remove provider ([#11](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/11))
- feat: add EKS module ([#10](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/10))
- chore: update pre-commit, add github actions ([#9](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/9))
- feat: allow common attributes ([#8](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/8))

### 

module with others. Providers are global, so it causes very odd interactions.

Users must configure the kubernetes provider for their EKS cluster themselves :(
- avoid using data sources, you can get stuck during destroy due if users did

not explicitly depend on the right resources.

This commit also adds a examples/eks module with a full set up for an EKS
cluster with Fargate logging towards Observe.


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


[Unreleased]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v1.0.0...HEAD
[v1.0.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.5.0...v1.0.0
[v0.5.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v0.1.0...v0.2.0
