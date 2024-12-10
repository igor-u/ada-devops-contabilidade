import json
import csv
import os
import boto3
import mysql.connector

s3client = boto3.client('s3')
snsclient = boto3.client('sns')
db_endpoint = os.environ.get('DB_ENDPOINT')
sns_topic_arn = os.environ.get('SNS_TOPIC_ARN')

def lambda_handler(event, context):
    bucket = event['Records'][0]['s3']['bucket']['name']
    csv_file = event['Records'][0]['s3']['object']['key']
    response = s3client.get_object(Bucket=bucket, Key=csv_file)
    lines = response['Body'].read().decode('utf-8').split()
    results = []
    message_results = []
    for row in csv.DictReader(lines):
        results.append(row.values())
        message_results.append(row)
    print(results)
    
    connection = mysql.connector.connect(host=db_endpoint,
                                         database='tekuchidb',
                                         port='3306',
                                         user='admin',
                                         passwd='tekuchi123')
    
    mysql_create_table ="create table if not exists auditoria_fiscal(conta varchar(80), saldo double)"
    mysql_insert = "insert into auditoria_fiscal(conta,saldo) values(%s,%s)"
    
    cursor = connection.cursor()
    cursor.execute(mysql_create_table)
    cursor.executemany(mysql_insert, results)
    connection.commit()

    connection.close()

    response =  snsclient.publish(
        TopicArn = sns_topic_arn,
        Message = json.dumps({
            "results": message_results
        }))
    

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Tekuchi Lambda!')
    }
