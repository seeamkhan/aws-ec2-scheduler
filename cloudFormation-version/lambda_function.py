import boto3 # type: ignore
import os

# Initialize the EC2 client for the specified region
ec2_client = boto3.client('ec2', region_name=os.environ['AWS_REGION'])

def lambda_handler(event, context):
    """
    Lambda function to start or stop EC2 instances based on the 'action' parameter
    passed from the CloudWatch Event Rule.
    """
    # Retrieve the action (start/stop) from the event input
    action = event.get('action', '').lower()
    
    if action not in ['start', 'stop']:
        return {
            'statusCode': 400,
            'body': 'Invalid action. Must be "start" or "stop".'
        }
    
    # Describe instances with the tag 'scheduler' set to 'true'
    response = ec2_client.describe_instances(
        Filters=[
            {
                'Name': 'tag:scheduler',
                'Values': ['true']
            },
            {
                'Name': 'instance-state-name',
                'Values': ['running' if action == 'stop' else 'stopped']
            }
        ]
    )
    
    instances = [
        instance['InstanceId']
        for reservation in response['Reservations']
        for instance in reservation['Instances']
    ]
    
    if not instances:
        return {
            'statusCode': 200,
            'body': f'No instances to {action}.'
        }

    # Perform the start or stop action
    if action == 'start':
        ec2_client.start_instances(InstanceIds=instances)
        print(f'Starting instances: {instances}')
    elif action == 'stop':
        ec2_client.stop_instances(InstanceIds=instances)
        print(f'Stopping instances: {instances}')
    
    return {
        'statusCode': 200,
        'body': f'Successfully initiated {action} for instances: {instances}'
    }
