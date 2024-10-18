import boto3 # type: ignore

ec2 = boto3.client('ec2')

def lambda_handler(event, context):
    # Describe instances with the tag 'scheduler' set to 'true'
    response = ec2.describe_instances(
        Filters=[{'Name': 'tag:scheduler', 'Values': ['true']}]
    )
    
    # Get instance IDs that are not in 'terminated' or 'stopped' state
    instances = [instance['InstanceId'] for reservation in response['Reservations']
                 for instance in reservation['Instances']
                 if instance['State']['Name'] not in ['terminated', 'stopped']]

    if event['action'] == 'stop':
        # Stop only instances that are running
        running_instances = [instance['InstanceId'] for reservation in response['Reservations']
                             for instance in reservation['Instances']
                             if instance['State']['Name'] == 'running']
        if running_instances:
            ec2.stop_instances(InstanceIds=running_instances)
        else:
            print("No running instances to stop.")
            
    elif event['action'] == 'start':
        # Start only instances that are stopped
        stopped_instances = [instance['InstanceId'] for reservation in response['Reservations']
                             for instance in reservation['Instances']
                             if instance['State']['Name'] == 'stopped']
        if stopped_instances:
            ec2.start_instances(InstanceIds=stopped_instances)
        else:
            print("No stopped instances to start.")
