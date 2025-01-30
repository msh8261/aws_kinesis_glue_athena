// kinesis_stream variables

variable "region" {
  description = "The AWS region we want this bucket to live in."
  default     = "eu-central-1"
}

variable "app_name" {
  description = "The common name for your deployment."
  default     = "kinesis-vgsales"
}

variable "env_type" {
  description = "The environment that our resources will be deployed."
  default     = "dev"
}

variable "project_name" {
  description = "The project name that every resource is related to."
  default     = "Data Research"
}

variable "client_name" {
  description = "The team name that is responsible for this deployment."
  default     = "WP"
}

variable "shard_count" {
  description = "The number of shards that the stream will use."
  default     = "1"
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream."
  default     = "24"
}

variable "shard_level_metrics" {
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream."
  default     = ["IncomingBytes", "OutgoingBytes", "Latency", "IncomingRecords", "OutgoingRecords", "WriteProvisionedThroughputExceeded",]
  type        = list(string)
}

variable "s3_bucket_name" {
  description = "s3 bucket name where kinesis firehose put data."
  default     = "video-game-glue-etl-v2"
}

variable "storage_input_format" {
  description = "Storage input format class for aws glue for parcing data."
  default     = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetInputFormat"
}

variable "storage_output_format" {
  description = "Storage output format class for aws glue for parcing data."
  default     = "org.apache.hadoop.hive.ql.io.parquet.MapredParquetOutputFormat"
}

variable "serde_name" {
  description = "The serialization library name."
  default     = "JsonSerDe"
}
variable "serde_library" {
  description = "The serialization library class."
  default     = "org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe"
}

variable "cloudwatch_logging_enabled" {
  type        = bool
  description = "Enables or disables the logging to Cloudwatch Logs."
  default     = true
}

variable "cloudwatch_log_group_name" {
  type        = string
  description = "The CloudWatch Logs group name for logging.  Defaults to \"/aws/kinesisfirehose/[NAME]\""
  default     = "kinesis-vgsales"
}

variable "cloudwatch_log_stream_name" {
  type        = string
  description = "The CloudWatch Logs stream name for logging."
  default     = "kinesis_delivery_stream"
}

variable "s3_prefix" {
  type        = string
  description = "An extra S3 Key prefix prepended before the time format prefix of records delivered to the AWS S3 Bucket."
  default     = "raw_data/"
}

variable "s3_error_output_prefix" {
  type        = string
  description = "Prefix added to failed records before writing them to S3. This prefix appears immediately following the bucket name."
  default     = "error/"
}

variable "s3_backup_mode" {
  type        = string
  description = "The backup mode to save original records."
  default     = "Enabled"
}