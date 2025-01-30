data "aws_caller_identity" "current" {}

resource "aws_iam_role" "firehose_role" {
  name = "${var.app_name}-firehose-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "read_policy" {
  name = "${var.app_name}-policy"

  //description = "Policy to allow reading from the ${var.stream_name} stream"
  role = "${aws_iam_role.firehose_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kinesis:*"
            ],
            "Resource": [
                "arn:aws:kinesis:${var.region}:${data.aws_caller_identity.current.account_id}:stream/${aws_kinesis_stream.kinesis_stream.name}"
            ]
        },
        {
          "Effect": "Allow",
          "Action": [
              "s3:*"
          ],
          "Resource": [
              "${aws_s3_bucket.bucket.arn}/*"
          ]
      },
      {
          "Effect": "Allow",
          "Action": [
              "glue:*"
          ],
          "Resource": [
              "*"
          ]
      }
]
}
EOF
}

