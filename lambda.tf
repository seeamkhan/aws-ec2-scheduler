# Lambda Function Python Code Zip
resource "null_resource" "lambda_zip" {
  provisioner "local-exec" {
    command = "zip lambda_function_payload.zip lambda_function.py"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Lambda function resource
resource "aws_lambda_function" "start_stop_ec2" {
  filename         = "lambda_function_payload.zip" # zip of your python script
  function_name    = "start-stop-ec2-tagged"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  
  # Set the dependency here
  depends_on       = [null_resource.lambda_zip]

  # Don't calculate hash until zip file is present
  lifecycle {
    ignore_changes = [source_code_hash]
  }
}
