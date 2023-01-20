
#include "../header/dht11.h"

void dht11_enable(){
	Xil_Out32(REG_CTRL, 0x1);
}
void dht11_disable(){
	Xil_Out32(REG_CTRL, 0x0);
}
u32 temperature_get(){
	dht11_enable();
	u32 temp = Xil_In32(REG_TEMPERATURE);
	dht11_disable();
	return temp;
}
u32 humidity_get(){
	dht11_enable();
	u32 humi = Xil_In32(REG_HUMIDITY);
	dht11_disable();
	return humi;
}
