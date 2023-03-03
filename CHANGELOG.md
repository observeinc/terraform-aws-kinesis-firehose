# [2.0.0](https://github.com/observeinc/terraform-aws-kinesis-firehose/compare/v1.0.3...v2.0.0) (2023-03-03)


* feat(eventbridge)!: switch `rules` variable to type `map` (#32) ([3049485](https://github.com/observeinc/terraform-aws-kinesis-firehose/commit/3049485565f0225cbe3d805d3a68175a2e63bfe5)), closes [#32](https://github.com/observeinc/terraform-aws-kinesis-firehose/issues/32)


### BREAKING CHANGES

* `rules` must be converted from a list to a map. Keys in this map are
only used for addressing purposes within terraform.



