import json


def lambda_handler(event, context):
    # Get the s3 name and object key from an event
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        file = record["s3"]["object"]["key"]

        print(f"New file uploaded!")
        print(f"Bucket:{bucket}")
        print(f"File: {file}")

    return {
        "statusCode ": 200,
        "body ": "Processed s3 event"
    }
