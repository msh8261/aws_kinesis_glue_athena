import os
import json
import boto3
import asyncio
import requests
import time
import uuid 
import logging
import argparse

# Define log format
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%Y-%d-%mT%H:%M:%S')


class KinesisStream():
    def __init__(self, region_name='eu-central-1'):
        self.kinesis_client = boto3.client('kinesis', region_name=region_name)
        
    def send_stream(self, stream_name, data, partition_key=None):
        if partition_key == None:
            partition_key = str(uuid.uuid4())            
        try:
            response = self.kinesis_client.put_record(StreamName=stream_name, Data=data, 
                                                        PartitionKey=partition_key)
        except self.kinesis_client.exceptions.ResourceNotFoundException:
            print(f"Kinesis stream '{stream_name}' not found")


def extract_subset(actual_json_dictionary, selected_columns):
    extract_json_dict = []
    extracted_json = {}
    for entry in actual_json_dictionary: 
        for column in selected_columns:
            extracted_json[column] = entry[column]
        extract_json_dict.append(extracted_json)
    return extract_json_dict

# Function to produce data
def data_dict(row, columns, i):
    record_data = [{
                        f'{columns[0]}': row[0],
                        f'{columns[1]}': row[1],
                        f'{columns[2]}': row[2],
                        f'{columns[3]}': row[3],
                        f'{columns[4]}': row[4],
                        f'{columns[5]}': row[5],
                        f'{columns[6]}': row[6],
                        f'{columns[7]}': row[7],
                        f'{columns[8]}': row[8],
                        f'{columns[9]}': row[9],
                        f'{columns[10]}': row[10]
                    } ]                   

    return record_data

async def fetch_data(queue, sourceData, amount):
    with open(sourceData, 'r') as file:
        try: # added this to cancel the task b runnin the task.cancel        
            for i, line in enumerate(file):
                if i > amount:
                    break
                row = line.rstrip().split(',')
                if i==0:
                    columns =  row
                    continue             
                # put data in queue
                print("Adding item to the queue...")
                data = data_dict(row, columns, i)
                await queue.put(data)
                print("Item added to the queue.")                     
                # 70 Seconds between calls of the API this is the time for Cache/Update Frequency for public API
                #await asyncio.sleep(5) 
        except asyncio.CancelledError:
            print("Task canceled. Exiting fetch_data.")

             

async def send_batch_to_kinesis(stream_name, queue, kinesis_streams):
    while True:
        try:
            batch_data = await asyncio.wait_for(queue.get(), timeout=5)             
        except asyncio.TimeoutError:
            if queue.empty():
                print("queue is empty, stopping task.")
                break
        else:
            try:
                for idx, data in enumerate(batch_data):
                    encoded_data = json.dumps(data).encode('utf-8')
                    print(encoded_data)
                    kinesis_streams.send_stream(stream_name, encoded_data, None)
            except Exception as e:
                print(f"Erro while sending to kinesis : {e}")
            



async def main():
    app_parser = argparse.ArgumentParser(allow_abbrev=False)
    app_parser.add_argument('--amount',
                            action='store',
                            type=int,
                            required=True,
                            dest='amount_opt',
                            help='Set the amount of message records to be generated.')
    args = app_parser.parse_args()

    sourceData = './data/vgsales.csv'  
    queue = asyncio.Queue()
    stream_name = "kinesis-vgsales-stream"
    kinesis_streams = KinesisStream('eu-central-1')    
    producer_task = asyncio.create_task(fetch_data(queue, sourceData, args.amount_opt))     
    await asyncio.wait_for(producer_task, timeout=6) 
    logging.info(f"Started data generation.")   
    sending_task = asyncio.create_task(send_batch_to_kinesis(stream_name, queue, kinesis_streams))   
    logging.info(f"{args.amount_opt} messages delivered to Kinesis.")   
    await sending_task
    


if __name__ == "__main__": 
    asyncio.run(main())