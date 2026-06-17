

#ifndef _POSITION_H

#include <TinyGPSPlus.h>
#include "SMARTDELAY.h"
#include "FLOAT_TO_STRING.h"

#define _POSITION_H

float Lat = 0.00;
float Lon = 0.00;
float Alt = 0.00;

String ID   =  "418"; // mettere il codice identificativo del drone
String SLat =  "0.00";
String SLon =  "0.00";
String SAlt =  "0.00";
String TxMsg = "0.00";

String Position()
{
 
  smartDelay(500);
 
  Lat=gps.location.lat();
  Lon=gps.location.lng();
  Alt=gps.altitude.meters();


  SLat  = ftoa( Lat, 6, 9);
  SLon  = ftoa( Lon, 6, 8);
  SAlt  = ftoa( Alt, 2, 6);

  TxMsg = ID + "," + SLat + "," + SLon + "," + SAlt;

  return TxMsg;

}



#endif















