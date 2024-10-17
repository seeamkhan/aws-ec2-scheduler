import boto3 # type: ignore

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    response = ec2.describe_instances(
        Filters=[{'Name': 'tag:scheduler', 'Values': ['true']}]
    )
    instances = [instance['InstanceId'] for reservation in response['Reservations'] for instance in reservation['Instances']]
    
    if event['action'] == 'stop':
        ec2.stop_instances(InstanceIds=instances)
    elif event['action'] == 'start':
        ec2.start_instances(InstanceIds=instances)
