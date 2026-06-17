

#ifndef _LORARX_H

#include "POSITION.h"
#include <SoftwareSerial.h>
#include "LoRa_E220.h"

#define _LORARX_H

#define AUX 4
#define M0 5
#define M1 6
#define TX 7
#define RX 8


LoRa_E220 Lora(RX, TX);

void TransmissionRx()
{

  pinMode(13, OUTPUT);
  pinMode(M0, OUTPUT);
  pinMode(M1, OUTPUT);
  pinMode(AUX, OUTPUT);

  digitalWrite(M0, LOW); // SET M0 LOW
  digitalWrite(M1, LOW); // SET M1 LOW
  digitalWrite(AUX, HIGH); // SET AUX HIGH

  Lora.begin();

  //DETECTION
  if (Lora.available() > 1) {
  ResponseContainer rs = Lora.receiveMessage();
  if (rs.data == "POSITION")
  Position();
  delay(500);

  
  //TRANSMISSION
  digitalWrite(13, HIGH);
  ResponseStatus ms = Lora.sendFixedMessage(0, 1, 18, TxMsg);
  digitalWrite(13, LOW);
  }
}

#endif