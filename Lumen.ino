#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <EEPROM.h>
#include <ArduinoJson.h>
#include <DNSServer.h>
#include <Arduino.h>




//Desired Credentials for the ESP when broadcasting
const char* ssid = "ESP-01";
//Password unused
const char* password = "RainDropTop";
DNSServer dnsServer;

String st;
String content;


String Argument_Name;
String Clients_Response;
String Clients_pResponse;

ESP8266WebServer server(80);

void setup() {

  //try to lengthen reset time
  //ESP.wdtEnable(150000);

  Serial.begin(115200);
  EEPROM.begin(512);
  Serial.setDebugOutput(true);
  while (!Serial) {
    //We wait for the serail port to actually connect.
  }
  delay(1000);

  //Always checks EEPROM before start up

  //EepromCheck();

  //On first start up we enter station mode, and make a disconnect
  //Just in Case
  WiFi.mode(WIFI_AP);
  WiFi.disconnect();
  delay(100);
  Serial.println("Initial Setup Complete");

  //Set ESP as AP so Iphone can connect
  Serial.println("Configuring Access Point");

  //password param not necessary
  //WiFi.softAP(ssid, password);
  WiFi.softAP(ssid, password);
  IPAddress myIP = WiFi.softAPIP();
  //delay(500);

  Serial.print("AP IP: ");
  Serial.println(myIP);
  Serial.print("Broadcasting as : ");
  Serial.println(ssid);


  dnsServer.setErrorReplyCode(DNSReplyCode::NoError);
  dnsServer.start(53, "*", myIP);
  //delay(500);

  Serial.println("DNS Server Running");


  server.begin();

  server.on("/", FindNetworks);
  // delay(500);
  //  server.on("/lumen", HandleInput);
  // delay(500);
  //  server.on("/more", ShowClientResponse);
  // delay(1500);

  //removed server.begin();

  String state = server.arg("state");
  if (state == "on") {
    Serial.println("server Strted");
    Serial.println("WebPages Served");
  }

  /* String state=server.arg("state");
    if(state == "on"){
    FindNetworks();
    //Function for taking in read Iphone data &
    //Saving it to EEProm connecting
    }*/
  yield();
}

void loop() {
  //Serial.println(server.arg("state"));
  server.handleClient();
  dnsServer.processNextRequest();
  //delay(5000);
  yield();
}

void HandleInput() {
  String webpage;
  webpage =  "<html>";
  webpage += "<head><title>ESP8266 Input Example</title>";
  webpage += "<style>";
  webpage += "body { background-color: #E6E6FA; font-family: Arial, Helvetica, Sans-Serif; Color: blue;}";
  webpage += "</style>";
  webpage += "</head>";
  webpage += "<body>";
  String IPaddress = WiFi.localIP().toString();
  webpage += "<form action='http://" + IPaddress + "' method='POST'>";
  webpage += "Please enter your Network details:<input type='text' name='network'>&nbsp;<input type='submit' value='Enter'>";
  webpage += "</form>";
  webpage += "<form action='Password' method='POST'>";
  webpage += "Please enter your Password details:<input type='text' name='password'>&nbsp;<input type='submit' value='Enter'>";
  webpage += "</form>";
  webpage += "</body>";
  webpage += "</html>";
  server.send(200, "text/html", webpage); // Send a response to the client asking for input

  if (server.args() > 0 ) { // Arguments were received
    for ( uint8_t i = 0; i < server.args(); i++ ) {
      Serial.print(server.argName(i)); // Display the argument

      Argument_Name = server.argName(i);
      if (server.argName(i) == "network") {
        Serial.print(" Input received was: ");
        Serial.println(server.arg(i));
        Clients_Response = server.arg(i);
        // e.g. range_maximum = server.arg(i).toInt();   // use string.toInt()   if you wanted to convert the input to an integer number
        // e.g. range_maximum = server.arg(i).toFloat(); // use string.toFloat() if you wanted to convert the input to a floating point number
      }
      if (server.argName(i) == "password") {
        Serial.print(" Input received was: ");
        Serial.println(server.arg(i));
        Clients_pResponse = server.arg(i);
      }
      if (Clients_Response.length() > 2 ) {
        if (Clients_pResponse.length() > 2) {
          WiFi.begin(Clients_Response.c_str(), Clients_pResponse.c_str());
          if (prevWifiCheck()) {
            //Do Some Other webpage generation
          } else {
            //Go back into AP mode
          }
        }
      }
    }
  }
}

void ShowClientResponse() {
  String webpage;
  webpage =  "<html>";
  webpage += "<head><title>ESP8266 Input Example</title>";
  webpage += "<style>";
  webpage += "body { background-color: #E6E6FA; font-family: Arial, Helvetica, Sans-Serif; Color: blue;}";
  webpage += "</style>";
  webpage += "</head>";
  webpage += "<body>";
  webpage += "<h1><br>ESP8266 Server - Password that the client sent</h1>";
  webpage += "<p>Network response received was: " + Clients_Response + "</p>";
  webpage += "<p>Password response received was: " + Clients_pResponse + "</p>";
  webpage += "</body>";
  webpage += "</html>";
  server.send(200, "text/html", webpage); // Send a response to the client asking for input

  WiFi.begin(Clients_Response.c_str(), Clients_pResponse.c_str());
  if (prevWifiCheck()) {
    Serial.println("");
    Serial.println("Connected to Previous WiFi");
    Serial.print("Local IP: ");
    Serial.println(WiFi.localIP());
    Serial.print("SoftAP IP: ");
    Serial.println(WiFi.softAPIP());
  } else {
    Serial.println("Could not connect with Given Credentials");
    return;
  }
}

void HandleJsonInterface() {
  server.send(200, "text/html", "<h1>Connected, Printing nearby Newtworks</h1>");

  StaticJsonBuffer<200> jsonBuffer;
  JsonObject& root = jsonBuffer.createObject();
}

void FindNetworks() {


  StaticJsonBuffer<200> jsonBuffer;

  //Create Json obj to pass to website
  JsonObject& NetworkList = jsonBuffer.createObject();
  //Array within the JsonObject
  JsonArray& data = NetworkList.createNestedArray("Networks");

  //Create array, then create object inside array
  //Just One array, Each Object contains "name" : ___, "rssi" : ___,
  JsonArray& array = jsonBuffer.createArray(); //one array


  Serial.println("Starting Network Scan");
  //Returns number oof networks found
  int n = WiFi.scanNetworks();
  Serial.println("scan complete");
  if (n == 0) {
    Serial.println("Could not find Networks");
  } else {
    Serial.print(n);
    Serial.println(" Network(s) found");

    st = "<ol>";
    String json = "["; //esentially create array
    for (int i = 0; i < n; ++i) {
      delay(500);
      st += "<li>";
      st += WiFi.SSID(i);
      st += " (";
      st += WiFi.RSSI(i);
      st += ")";
      st += "</li>";
      data.add(WiFi.SSID(i));
      JsonObject& nested = array.createNestedObject();
      nested.set("name", WiFi.SSID(i));
      nested.set("rssi", WiFi.RSSI(i));
      array.add(nested);
      json += "{\"name\":";
      json += "\"" ;
      json += WiFi.SSID(i);
      json += "\"";
      json += ",";
      json += " \"rssi\": ";
      json += WiFi.RSSI(i);
      json += "}";
      if (!(i == n - 1)) {
        json += ",";
      } else {
        break;
      }
    }
    st += "</ol>";
    json += "]";

    content = "<!DOCTYPE HTML>\r\n<html>Hello from ESP8266 at ";
    content += "<p>";
    content += st;
    content += "</p>";
    content += "</html>";


    //array.prettyPrintTo(Serial);
    //create buffer and all thatt to send

    // Serial.print("Networks from the array: ");
    // data.prettyPrintTo(Serial);
    delay(500);
    Serial.print("JSON STRING: ");
    Serial.println(json);
    //JSON is just text, throw JSON like text on website, wrapped in [], seperated by ,'s

    char buffer[5000];
    array.printTo(buffer, sizeof(buffer));
    //JSON
    server.send(200, "application/json", json);
    //server.send(200, "application/json", data);
    //server.begin();

    if (server.args() > 0 ) { // Arguments were received
      Serial.println("Arguements Recieved");
      Serial.println(server.args()); //So we know how many were iteraing thru
      String message;

      for ( int i = 0; i < server.args(); i++ ) {
        Serial.print(server.argName(i)); // Display the argument
        message += " " + server.arg ( i ) + "\n";
        Serial.println("Network(s) were recieved");
        Serial.println(server.argName(i));
        delay(500);
        Serial.println(message);
        //Create string to hold response OBject

        StaticJsonBuffer<200> jsonBuffer;
        JsonObject& root = jsonBuffer.parseObject(message);

        const char* Network_Name = root["Nname"];
        const char* Network_Pword = root["Npwd"];

        Serial.println("Parsed JSON");
        Serial.println(Network_Name);
        Serial.println(Network_Pword);
        //PrevWifiCheck() -- Load TO EEPROM

        /*WiFi.begin(Network_Name, Network_Pword);
           if (prevWifiCheck()){
          Serial.println("");
          Serial.println("Connected to Home WiFi Successfully");
          Serial.println("Saving To EEPROM");
          Serial.print("Local IP: ");
          Serial.println(WiFi.localIP());
          Serial.print("SoftAP IP: ");
          Serial.println(WiFi.softAPIP());
            }else{
              Serial.println("Could not connect with Given Credentials");
              return;
            }
        */
      }
    }

  }
}
void EepromCheck() {
  String esid;
  String epass = "";
  for (int i = 0; i < 32; ++i) {
    esid += char(EEPROM.read(i));
  }
  for (int i = 32; i < 96; ++i) {
    epass += char(EEPROM.read(i));
  }
  if (esid.length() > 1) {
    WiFi.begin(esid.c_str(), epass.c_str());
    if (prevWifiCheck()) {
      Serial.println("");
      Serial.println("Connected to Previous WiFi");
      Serial.print("Local IP: ");
      Serial.println(WiFi.localIP());
      Serial.print("SoftAP IP: ");
      Serial.println(WiFi.softAPIP());
    } else {
      return;
    }
  }
}

bool prevWifiCheck() {
  int c = 0;
  Serial.println("Attempting connection to previous Network");
  while ( c < 10 ) {
    ESP.wdtFeed();
    if (WiFi.status() == WL_CONNECTED) {
      return true;
    }
    delay(500);
    Serial.print(WiFi.status());
    c++;
  }
  Serial.println("");
  Serial.println("Connect timed out, opening AP");
  return false;
}


