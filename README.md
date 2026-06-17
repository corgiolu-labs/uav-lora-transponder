# UAV LoRa safety transponder

> 868 MHz LoRa transponder system for the monitoring and safety of civil drones — BSc thesis project (Computer Engineering, 2024).

A lightweight, *secondary-radar*-style identification and position-reporting link for civil UAVs. A ground **interrogation station** broadcasts a position request over long-range 868 MHz LoRa; a drone-mounted **transponder** receives it, acquires its GNSS position and replies. A companion **Processing visualizer** plots the reported position on a radar-style display.

The project addresses the communication and robustness challenges of drones operating in real environments, with field testing of range and reliability of the 868 MHz link.

## How it works

```
   Ground interrogation station                 UAV transponder
   (ESP32 + EByte E220, 868 MHz)                 (Arduino Nano + E220 + NEO-6 GPS)
            |                                              |
            |------- broadcast "POSITION" (LoRa) --------->|
            |                                              |  acquire GPS fix
            |<-------- reply: GPS position (LoRa) ---------|
            |
            v
   serial --> Processing visualizer  -->  radar-style position display
```

- The **interrogation station** (ESP32 + EByte E220) periodically broadcasts a fixed `POSITION` interrogation frame over LoRa using fixed addressing on channel 18.
- The **transponder** (Arduino Nano + EByte E220 + u-blox NEO-6 GPS) listens; on receiving the interrogation it reads a GPS fix and transmits its position back to the station.
- The station prints the received position over the serial port, where the **Processing** sketch renders it on a vector, radar-style map.

## Hardware

| Node | MCU | Radio | Other |
|------|-----|-------|-------|
| Interrogation station | ESP32 dev board | EByte E220-900T22D (868 MHz LoRa) | — |
| UAV transponder | Arduino Nano | EByte E220-900T22D (868 MHz LoRa) | u-blox NEO-6 GPS |

Earlier prototypes in the thesis also used EByte E32 modules.

## Repository layout

```
transponder/                  drone-side firmware (Arduino Nano)
  TRANSPONDER/                 main sketch + LoRa / GPS / position helpers
  GET_CONFIG_TRANSPONDER/      read EByte E220 configuration
  SET_CONFIG_TRANSPONDER/      write EByte E220 configuration
interrogation_station/        ground-side firmware (ESP32)
  STAZIONE_DI_INTERROGAZIONE/  main sketch + LoRa helper
  GET_CONFIG_STAZIONE.../      read EByte E220 configuration
  SET_CONFIG_STAZIONE.../      write EByte E220 configuration
ground_visualizer/            Processing sketch — vector radar-style display
```

## Build & flash

1. **Arduino IDE** with the [`LoRa_E220` library by Renzo Mischianti (xreef)](https://github.com/xreef/LoRa_E220_Series_Library) for the EByte E220 modules. The transponder uses `SoftwareSerial` (Nano); the station uses the ESP32 `HardwareSerial`. The transponder also needs a GPS-parsing library for the NEO-6 (e.g. TinyGPS).
2. **Configure the radios first:** flash the `SET_CONFIG_*` sketch on each node to program address/channel into the E220, and verify with `GET_CONFIG_*`. The link uses fixed addressing on channel 18.
3. Flash `transponder/TRANSPONDER` to the Arduino Nano and `interrogation_station/STAZIONE_DI_INTERROGAZIONE` to the ESP32.
4. (Optional) Open the `ground_visualizer` sketch in Processing and point it at the station's serial port.

## Context

BSc thesis in **Computer Engineering (L-8), Universitas Mercatorum, 2024 — 90/110.**
Title: *long-range 868 MHz LoRa transponder for the monitoring and safety of civil drones.*

## Author

**Alessandro Corgiolu** — System / Embedded Integration & Validation Engineer
GitHub [@corgiolu-labs](https://github.com/corgiolu-labs) · part of a hardware portfolio that includes [JONNY5](https://github.com/corgiolu-labs/jonny5) (VR-teleoperated 6-DoF arm), [ESP32 radar](https://github.com/corgiolu-labs/esp32-radar-tracking) and [RASPYNVERTER](https://github.com/corgiolu-labs/raspinverter).

## License

MIT — see [LICENSE](LICENSE).
