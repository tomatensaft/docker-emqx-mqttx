import logging
import time
import datetime
import paho.mqtt.client as mqtt
import random
import json
import sys

#enable logging
logging.basicConfig()
log = logging.getLogger(__name__)
log.setLevel(logging.INFO)

#connect to broker
def on_connect(client, _userdata, _flags, rc):
    log.info("Connected with result code " + str(rc))

def json_data(debugLevel):

    #timestamp
    actualDate = datetime.datetime.now()
    unix_timestamp = datetime.datetime.timestamp(actualDate)*1000

    #jsonValue
    jsonValue = f"""{{"Timestamp":{unix_timestamp},"Value01":{random.uniform(-10,10)},"Value02":{random.uniform(-100,100)}}}"""
    jsonMessage = json.dumps(jsonValue)

    #debug message
    if debugLevel == 1:
        print(jsonValue)

    #return json message
    return jsonValue

#mqtt client
client = mqtt.Client()
client.on_connect = on_connect
client.connect("localhost", 1883, 60)
client.loop_start()

#loop for publish data
while True:

    client.publish("/mqtt", json_data(0))
    time.sleep(1) #1s

client.loop_stop()
