#include "Arduino.h"
#include "LoRa_E220.h"
#include <HardwareSerial.h>


HardwareSerial MySerial(2); // define a Serial for UART2
const int MySerialTX = 16;
const int MySerialRX = 17;

#define M0 21
#define M1 22
#define AUX 32


LoRa_E220 Lora(&MySerial); //  (RX-TX)esp32 hardware pins,  AUX, M0, M1   DEFAULT:  LoRa_E32 Lora(&MySerial, AUX, M0, M1);

void printParameters(struct Configuration configuration);
void printModuleInformation(struct ModuleInformation moduleInformation);

void setup() {

	Serial.begin(9600);
	while(!Serial){};
	delay(500);

	Serial.println();


	// Startup all pins and UART
  MySerial.begin(9600, SERIAL_8N1, MySerialRX, MySerialTX);

	Lora.begin();

  pinMode(M0, OUTPUT);
  pinMode(M1, OUTPUT);
  pinMode(AUX, OUTPUT);

  digitalWrite(M0, HIGH); // SET M0 HIGH 
  digitalWrite(M1, HIGH); // SET M1 HIGH 
  digitalWrite(AUX, HIGH); // SET AUX HIGH 

  
	ResponseStructContainer c;
	c = Lora.getConfiguration();
	// It's important get configuration pointer before all other operation
	Configuration configuration = *(Configuration*) c.data;
	Serial.println(c.status.getResponseDescription());
	Serial.println(c.status.code);

	printParameters(configuration);

//	----------------------- DEFAULT TRANSPARENT -----------------------
	
	configuration.ADDH = 0; // First part of address
  configuration.ADDL = 1;  // Second part of address
	configuration.CHAN = 18; // Communication channel

	configuration.SPED.uartBaudRate = UART_BPS_9600; // Serial baud rate
	configuration.SPED.airDataRate = AIR_DATA_RATE_010_24; // Air baud rate
	configuration.SPED.uartParity = MODE_00_8N1; // Parity bit
  
  configuration.OPTION.transmissionPower = POWER_22; // Device power
	configuration.TRANSMISSION_MODE.fixedTransmission = FT_FIXED_TRANSMISSION; // Enable repeater mode
  
  configuration.OPTION.subPacketSetting = SPS_200_00; // Packet size
	configuration.OPTION.RSSIAmbientNoise = RSSI_AMBIENT_NOISE_DISABLED; // Need to send special command
	configuration.TRANSMISSION_MODE.enableRSSI = RSSI_DISABLED; // Enable RSSI info
	configuration.TRANSMISSION_MODE.enableLBT = LBT_DISABLED; // Check interference
	configuration.TRANSMISSION_MODE.WORPeriod = WOR_2000_011; // WOR timing


	// Set configuration changed and set to not hold the configuration
	ResponseStatus rs = Lora.setConfiguration(configuration, WRITE_CFG_PWR_DWN_SAVE);
	Serial.println(rs.getResponseDescription());
	Serial.println(rs.code);

	c = Lora.getConfiguration();
	// It's important get configuration pointer before all other operation
	configuration = *(Configuration*) c.data;
	Serial.println(c.status.getResponseDescription());
	Serial.println(c.status.code);

	printParameters(configuration);
	c.close();
}

void loop() {

}
void printParameters(struct Configuration configuration) {
	Serial.println("----------------------------------------");

	Serial.print(F("HEAD : "));  Serial.print(configuration.COMMAND, BIN);Serial.print(" ");Serial.print(configuration.STARTING_ADDRESS, DEC);Serial.print(" ");Serial.println(configuration.LENGHT, HEX);
	
  Serial.println(F(" "));
	
  Serial.print(F("AddH : "));  Serial.println(configuration.ADDH, DEC);
	Serial.print(F("AddL : "));  Serial.println(configuration.ADDL, DEC);
  Serial.print(F("Chan : "));  Serial.print(configuration.CHAN, DEC); Serial.print(" -> "); Serial.println(configuration.getChannelDescription());
	
  Serial.println(F(" "));
	
  Serial.print(F("SpeedParityBit     : "));  Serial.print(configuration.SPED.uartParity, BIN);Serial.print(" -> "); Serial.println(configuration.SPED.getUARTParityDescription());
	Serial.print(F("SpeedUARTDatte     : "));  Serial.print(configuration.SPED.uartBaudRate, BIN);Serial.print(" -> "); Serial.println(configuration.SPED.getUARTBaudRateDescription());
	Serial.print(F("SpeedAirDataRate   : "));  Serial.print(configuration.SPED.airDataRate, BIN);Serial.print(" -> "); Serial.println(configuration.SPED.getAirDataRateDescription());
	
  Serial.println(F(" "));
	
	Serial.print(F("OptionPower        : "));  Serial.print(configuration.OPTION.transmissionPower, BIN);Serial.print(" -> "); Serial.println(configuration.OPTION.getTransmissionPowerDescription());
  Serial.print(F("TransModeFixedTrans: "));  Serial.print(configuration.TRANSMISSION_MODE.fixedTransmission, BIN);Serial.print(" -> "); Serial.println(configuration.TRANSMISSION_MODE.getFixedTransmissionDescription());
  
  Serial.println(F(" "));
  
  Serial.print(F("OptionSubPacketSett: "));  Serial.print(configuration.OPTION.subPacketSetting, BIN);Serial.print(" -> "); Serial.println(configuration.OPTION.getSubPacketSetting());
	Serial.print(F("OptionRSSIAmbientNo: "));  Serial.print(configuration.OPTION.RSSIAmbientNoise, BIN);Serial.print(" -> "); Serial.println(configuration.OPTION.getRSSIAmbientNoiseEnable());
	Serial.print(F("TransModeWORPeriod : "));  Serial.print(configuration.TRANSMISSION_MODE.WORPeriod, BIN);Serial.print(" -> "); Serial.println(configuration.TRANSMISSION_MODE.getWORPeriodByParamsDescription());
	Serial.print(F("TransModeEnableLBT : "));  Serial.print(configuration.TRANSMISSION_MODE.enableLBT, BIN);Serial.print(" -> "); Serial.println(configuration.TRANSMISSION_MODE.getLBTEnableByteDescription());
	Serial.print(F("TransModeEnableRSSI: "));  Serial.print(configuration.TRANSMISSION_MODE.enableRSSI, BIN);Serial.print(" -> "); Serial.println(configuration.TRANSMISSION_MODE.getRSSIEnableByteDescription());
	
	Serial.println("----------------------------------------");
}
void printModuleInformation(struct ModuleInformation moduleInformation) {
	Serial.println("----------------------------------------");
	
  Serial.print(F("HEAD: "));  Serial.print(moduleInformation.COMMAND, BIN);Serial.print(" ");Serial.print(moduleInformation.STARTING_ADDRESS, DEC);Serial.print(" ");Serial.println(moduleInformation.LENGHT, HEX);

  Serial.println(F(" "));

	Serial.print(F("Version  : "));  Serial.println(moduleInformation.version, DEC);
	Serial.print(F("Features : "));  Serial.println(moduleInformation.features, DEC);
  Serial.print(F("Model no.: "));  Serial.println(moduleInformation.model, DEC);

  Serial.println("----------------------------------------");
}

