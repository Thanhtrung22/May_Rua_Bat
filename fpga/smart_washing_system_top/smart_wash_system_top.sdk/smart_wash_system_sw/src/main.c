

/* FreeRTOS includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
/* Xilinx includes. */
#include "xil_printf.h"
#include "xparameters.h"
#include <stdio.h>

#include "header/oled.h"
#include "header/smart_wash_system_regs.h"
#include "header/dht11.h"
/*-----------------------------------------------------------*/
/* The Tx and Rx tasks as described at the top of this file. */
static void ReadTask( void *pvParameters );
static void WriteTask( void *pvParameters );
/*-----------------------------------------------------------*/
char *myString;
char *line0 = "STATUS: WARM UP";
char *line1 = "TEMP: 1  oC";
char *line2 = "           ";
char *line3 = "EMBEDDED SYSTEM";
u32 temp;

static TaskHandle_t xReadTask  ;
static TaskHandle_t xWriteTask;
oledControl myOled;

int main( void )
{
	initOled(&myOled,XPAR_OLED_CONTROLLER_0_BASEADDR);
	xTaskCreate(ReadTask				, 	/* The function that implements the task. */
			    ( const char * ) "read"	,	/* Text name for the task, provided to assist debugging only. */
				configMINIMAL_STACK_SIZE, 	/* The stack allocated to the task. */
				NULL					, 	/* The task parameter is not used, so set to NULL. */
				tskIDLE_PRIORITY		,	/* The task runs at the idle priority. */
				&xReadTask 				);

	xTaskCreate(WriteTask,
				( const char * ) "write",
				configMINIMAL_STACK_SIZE,
				NULL					,
				tskIDLE_PRIORITY + 1	,
				&xWriteTask 			);

	vTaskStartScheduler();
}

/*-----------------------------------------------------------*/
static void ReadTask( void *pvParameters )
{
	const TickType_t delay = pdMS_TO_TICKS( 200UL );
	while(1){
		vTaskDelay(delay);

		temp = temperature_get();

		line1[6] = temp / 10 + '0';
		line1[7] = temp % 10 + '0';

		read_reg_stt();
		if(stt_ready_get()) {
			strcpy(line0,"READY");
		} else if (stt_using_get()) {
			strcpy(line0,"USING");
		} else if(stt_spraying_get()){
			strcpy(line0,"SPRAYING");
		} else if (stt_drying_get()){
			strcpy(line0,"DRYING");
		} else if (stt_discharge_get()){
			strcpy(line0,"DISCHARGING");
		} else {
			strcpy(line0,"WAIT DISCHARGE");
		}

		sprintf(myString, "%-16s%-16s%-16s%-16s", line0,line1,line2,line3);
		clearOled(&myOled);
		printOled(&myOled,myString);
	}
}

/*-----------------------------------------------------------*/
static void WriteTask( void *pvParameters )
{
	const TickType_t delay = pdMS_TO_TICKS( 100UL );
	while(1){
		vTaskDelay(delay);
		if(temp < 32){
			ctrl_warm_en_set(1);
			strcpy(line2,"    WARM UP");
		} else {
			ctrl_warm_en_set(0);
			strcpy(line2,"");
		}
		write_reg_ctrl();
	}
}
