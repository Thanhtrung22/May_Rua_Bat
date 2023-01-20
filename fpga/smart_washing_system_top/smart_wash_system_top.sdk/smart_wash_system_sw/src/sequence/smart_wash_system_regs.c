
 */

#include "../header/smart_wash_system_regs.h"

regs_ptr smart_wash_system_regs;

u32 read_reg(u32 addr) {
	return Xil_In32(addr);
}
void write_reg(u32 addr, u32 data) {
	Xil_Out32(addr, data);
}
void read_reg_data(){
	smart_wash_system_regs->reg_data = read_reg(ADDR_REG_DATA);
}
void write_reg_ctrl(){
	write_reg(ADDR_REG_CTRL, smart_wash_system_regs->reg_ctrl);
}
void read_reg_stt(){
	smart_wash_system_regs->reg_stt = read_reg(ADDR_REG_STT);
}

u32 data_temp_get(){
	return DATA__TEM__GET(smart_wash_system_regs->reg_data);
}

void ctrl_warm_en_set(u32 data){
	smart_wash_system_regs->reg_ctrl = CTRL__WARM_EN__SET(smart_wash_system_regs->reg_ctrl, data);
}

u32 stt_ready_get(){
	return STT__READY__GET(smart_wash_system_regs->reg_stt);
}
u32 stt_spraying_get(){
	return STT__SPRAYING__GET(smart_wash_system_regs->reg_stt);
}
u32 stt_using_get(){
	return STT__USING__GET(smart_wash_system_regs->reg_stt);
}
u32 stt_drying_get(){
	return STT__DRYING__GET(smart_wash_system_regs->reg_stt);
}
u32 stt_discharge_get(){
	return STT__DISCHARGE__GET(smart_wash_system_regs->reg_stt);
}
