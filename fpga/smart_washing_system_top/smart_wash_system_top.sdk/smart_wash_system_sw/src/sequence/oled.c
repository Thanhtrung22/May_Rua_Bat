
#include "../header/oled.h"
#include "xil_io.h"

int initOled(oledControl *myOled,u32 baseAddress){
	myOled->baseAddress = baseAddress;
	return 0;
}


void writeCharOled(oledControl *myOled,char myChar){
	u32 status=0;
	Xil_Out32(myOled->baseAddress+8,myChar);
	Xil_Out32(myOled->baseAddress,0x1);
	while(!status){
		status = Xil_In32(myOled->baseAddress+4); //polling mode
	}
	Xil_Out32(myOled->baseAddress+4,0x0);
}


void printOled(oledControl *myOled,char *myString){
	for(int i=0;i < 64; i++){
		if(*myString != 0){
			writeCharOled(myOled,*myString);
			myString++;
		} else {
			writeCharOled(myOled,' ');
		}

	}
}

void clearOled(oledControl *myOled){
	u32 i;
	for(i=0;i<64;i++)
		writeCharOled(myOled,' ');
}
