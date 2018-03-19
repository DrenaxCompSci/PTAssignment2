import mqtt.*;

MQTTClient client;
String topic = "testTopic";

void setup() {
  client = new MQTTClient(this);
  client.connect("192.168.10.124", "1883"); //Connect to broker
  client.connect("mqtt://192.168.10.124:1883", "Processing"); //Connect to broker
  client.subscribe(topic); //Subscribe to test topic
}

void draw() {
}

/*
void keyPressed() {
  client.publish("/hello", "world");
}*/

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload)); //Print message received from broker that is published on topic
}