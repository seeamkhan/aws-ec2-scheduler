# CloudWatch Event Rule for stopping EC2 instances
resource "aws_cloudwatch_event_rule" "stop_ec2_rule" {
  name                = "stop-ec2-instances"
  description         = "Triggers Lambda to stop EC2 instances at 6:00 PM UTC"
  schedule_expression = "cron(0 18 * * ? *)" # 6:00 PM UTC
}

# Lambda target for stop event
resource "aws_cloudwatch_event_target" "stop_ec2_target" {
  rule      = aws_cloudwatch_event_rule.stop_ec2_rule.name
  target_id = "stop_ec2_lambda"
  arn       = aws_lambda_function.start_stop_ec2.arn

  input = jsonencode({
    action = "stop"
  })
}

# Permission for CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "allow_stop_cloudwatch" {
  statement_id  = "AllowCloudWatchInvokeLambdaStop"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.stop_ec2_rule.arn
}

# CloudWatch Event Rule for starting EC2 instances
resource "aws_cloudwatch_event_rule" "start_ec2_rule" {
  name                = "start-ec2-instances"
  description         = "Triggers Lambda to start EC2 instances at 8:00 AM UTC"
  schedule_expression = "cron(0 8 * * ? *)" # 8:00 AM UTC
}

# Lambda target for start event
resource "aws_cloudwatch_event_target" "start_ec2_target" {
  rule      = aws_cloudwatch_event_rule.start_ec2_rule.name
  target_id = "start_ec2_lambda"
  arn       = aws_lambda_function.start_stop_ec2.arn
  input = jsonencode({
    action = "start"
  })
}
# Permission for CloudWatch to invoke the Lambda function
resource "aws_lambda_permission" "allow_start_cloudwatch" {
  statement_id  = "AllowCloudWatchInvokeLambdaStart"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.start_stop_ec2.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.start_ec2_rule.arn
}
