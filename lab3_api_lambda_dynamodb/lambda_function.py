import json
import boto3
import time

# Create a DynamoDB service resource
# This is done outside the handler so the connection can be reused across Lambda invocations
dynamodb = boto3.resource("dynamodb")

# Reference an existing DynamoDB table by name
table = dynamodb.Table("Lab3Items")


def lambda_handler(event, context):
    """
    Lambda function entry point.

    This function creates an item containing a unique ID and a message,
    then stores it in a DynamoDB table.
    """

    # Create the item to store in DynamoDB
    item = {
        # Generate a unique ID using the current Unix timestamp
        "id": str(int(time.time())),

        # Retrieve 'Message' from the event payload,
        # or use a default value if it is not provided
        "message": event.get("Message", "HELLO FROM LAB 3")
    }

    # Write the item to the DynamoDB table
    table.put_item(Item=item)

    # Return an HTTP-style response indicating success
    return {
        "statusCode": 200,
        # Convert the response body to JSON so it can be returned by Lambda
        "body": json.dumps(
            {
                "message": "ITEM WRITTEN TO DYNAMODB",
                "item": item
            }
        )
    }
