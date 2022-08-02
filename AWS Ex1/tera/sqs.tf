resource "aws_sqs_queue" "terraform_queue" {
  name                      = "EX1_polybot-sqs-queue"
  delay_seconds             = 90
  max_message_size          = 262144
  message_retention_seconds = 345600
  receive_wait_time_seconds = 10
  visibility_timeout_seconds = 30
  

  tags = {
    Environment = "production"
  }
}

resource "aws_sqs_queue_policy" "sqs_queue_policy" {
  queue_url = aws_sqs_queue.terraform_queue.id
  policy    = <<POLICY
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "352708296901"
      },
      "Action": [
        "SQS:*"
      ],
      "Resource": "arn:aws:sqs:eu-central-1:352708296901:"
    }
  ]
}
POLICY
}