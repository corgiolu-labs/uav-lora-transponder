
#ifndef _SMARTDELAY_H
#include <SoftwareSerial.h>
#define _SMARTDELAY_H

#define RXPin 10
#define TXPin 9

TinyGPSPlus gps;

SoftwareSerial ss(RXPin, TXPin);


static void smartDelay(unsigned long ms)
{

  ss.begin(9600);

  unsigned long start = millis();
  do 
  {
    while (ss.available())
      gps.encode(ss.read());
  } while (millis() - start < ms);
}


#endif

