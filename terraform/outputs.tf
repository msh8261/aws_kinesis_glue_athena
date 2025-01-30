output "kinesis_stream_name" {
  description = "The unique Kinesis stream name"
  value       = aws_kinesis_stream.kinesis_stream.name
}

output "kinesis_stream_arn" {
  description = "The Amazon Resource Name (ARN) specifying the Stream"
  value       = aws_kinesis_stream.kinesis_stream.arn
}

