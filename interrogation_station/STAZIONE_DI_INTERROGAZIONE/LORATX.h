

#ifndef _LORATX_H

#include <HardwareSerial.h>
#include "LoRa_E220.h"

#define _LORATX_H

#define LORATX 16
#define LORARX 17
#define M0 21
#define M1 22
#define AUX 32 


String rxmsg = "POSITIONRX......";

HardwareSerial LoraSerial(2);
LoRa_E220 Lora(&LoraSerial); 

void TransmissionTx()
{

  pinMode(13, OUTPUT);
  pinMode(M0, OUTPUT);
  pinMode(M1, OUTPUT);
  pinMode(AUX, OUTPUT);

  digitalWrite(M0, LOW); // SET M0 LOW
  digitalWrite(M1, LOW); // SET M1 LOW
  digitalWrite(AUX, HIGH); // SET AUX HIGH

  LoraSerial.begin(9600, SERIAL_8N1, LORARX, LORATX);
  Lora.begin();

 //BROADCAST TRASMISSION

  ResponseStatus ms = Lora.sendBroadcastFixedMessage(18, "POSITION");
  delay(500);


//DETECTION
  if (Lora.available()  > 1){
  ResponseContainer rs = Lora.receiveMessage();
  rxmsg = rs.data;
  Serial.println(rxmsg);
  
  }  

}

#endif