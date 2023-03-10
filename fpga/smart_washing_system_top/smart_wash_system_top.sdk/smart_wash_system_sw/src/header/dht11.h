
#ifndef _DHT11_H
#define _DHT11_H

#include <stdint.h>
#include "xil_io.h"
#include "xparameters.h"
/************************ REG ADDRESS ************************/
#define REG_CTRL        (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x00)
#define REG_DEBUG       (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x04)
#define REG_TEMPERATURE (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x08)
#define REG_HUMIDITY    (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x0C)
#define REG_CRC         (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x10)
#define REG_ACK         (XPAR_DHT11_CONTROLLER_V1_0_BASEADDR + 0x14)

/************************ FUNCTION ************************/
void dht11_enable();
void dht11_disable();
u32 temperature_get();
u32 humidity_get();

#endif
