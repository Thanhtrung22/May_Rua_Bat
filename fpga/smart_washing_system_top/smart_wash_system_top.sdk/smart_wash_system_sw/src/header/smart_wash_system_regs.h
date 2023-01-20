

#ifndef _SMART_WASH_SYSTEM_H
#define _SMART_WASH_SYSTEM_H

#include <stdint.h>
#include "xil_io.h"
#include "xparameters.h"

/************************ REG ADDRESS ************************/
#define ADDR_REG_DATA  (XPAR_SYSTEM_CONTROLLER_0_BASEADDR + 0x0  )
#define ADDR_REG_CTRL  (XPAR_SYSTEM_CONTROLLER_0_BASEADDR + 0x4  )
#define ADDR_REG_STT   (XPAR_SYSTEM_CONTROLLER_0_BASEADDR + 0x8  )

/************************ DEFINE ACCESS RIGHTS ************************/
#define __RW volatile       /* read/write permissions */

/********************** DEFINE READ/WRITE MACROS **********************/
#define DTI_REG_BLK_READ32(reg, mask, offset)\
     (((reg) & (mask)) >> (offset))
#define DTI_REG_BLK_WRITE32(reg, mask, offset, data)\
     (((reg) & ~(mask)) | (((uint32_t)data << (offset))))

/********************** DEFINE HIERARCHY LEVELS ***********************/
typedef struct regs_s
{
   /* Data Register */
   __RW uint32_t   reg_data;    /* 0x3:0x0 */
   /* Control Register */
   __RW uint32_t   reg_ctrl;    /* 0x7:0x4 */
   /* Status Register */
   __RW uint32_t   reg_stt;     /* 0xB:0x8 */
} __RW regs_s, *regs_ptr;

/************************** DEFINE TOP BLOCK **************************/
//#define SMART_WASH_SYSTEM__BASE 0x0
extern regs_ptr smart_WASH_system_regs;

/**************************** DEFINE FIELDS ***************************/

/*--------------------------------------------------------------------
 *  Register: data
 *    Data Register
 *    SW Access     : read-write
 *    HW Access     : read-write
 * 
 *  Fields:
 *       1:0  tem (SW:read-only,  HW:write-only)
 *       31:2 rfu (SW:read-write, HW:read-write) (RESERVED)
 */
/*--------------------------------------------------------------------
 *    Field: tem
 *    Width: 2,             Offset: 0
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Temperature Data
 */
#define DATA__TEM__MASK 0x00000003
#define DATA__TEM__OFFSET 0
#define DATA__TEM__GET(reg)\
         DTI_REG_BLK_READ32(reg, DATA__TEM__MASK, DATA__TEM__OFFSET)

/*--------------------------------------------------------------------
 *    Field: rfu (RESERVED)
 *    Width: 30,             Offset: 2
 *    SW Access: read-write, HW Access: read-write
 *--------------------------------------------------------------------
 *  Reserved for Future Use
 */
#define DATA__RFU__MASK 0xFFFFFFFC
#define DATA__RFU__OFFSET 2

/*--------------------------------------------------------------------
 *  Register: ctrl
 *    Control Register
 *    SW Access     : read-write
 *    HW Access     : read-write
 * 
 *  Fields:
 *       0    warm_en (SW:read-write, HW:read-only)
 *       31:1 rfu     (SW:read-write, HW:read-write) (RESERVED)
 */
/*--------------------------------------------------------------------
 *    Field: warm_en
 *    Width: 1,              Offset: 0
 *    SW Access: read-write, HW Access: read-only
 *--------------------------------------------------------------------
 *  Warm up enable
 *  0: Disable
 *  1: Enable
 */
#define CTRL__WARM_EN__MASK 0x00000001
#define CTRL__WARM_EN__OFFSET 0
#define CTRL__WARM_EN__GET(reg)\
         DTI_REG_BLK_READ32(reg, CTRL__WARM_EN__MASK, CTRL__WARM_EN__OFFSET)
#define CTRL__WARM_EN__SET(reg, data)\
         DTI_REG_BLK_WRITE32(reg, CTRL__WARM_EN__MASK, CTRL__WARM_EN__OFFSET, data)

/*--------------------------------------------------------------------
 *    Field: rfu (RESERVED)
 *    Width: 31,             Offset: 1
 *    SW Access: read-write, HW Access: read-write
 *--------------------------------------------------------------------
 *  Reserved for Future Use
 */
#define CTRL__RFU__MASK 0xFFFFFFFE
#define CTRL__RFU__OFFSET 1

/*--------------------------------------------------------------------
 *  Register: stt
 *    Status Register
 *    SW Access     : read-write
 *    HW Access     : read-write
 * 
 *  Fields:
 *       0    ready     (SW:read-only,  HW:write-only)
 *       1    using     (SW:read-only,  HW:write-only)
 *       2    spraying  (SW:read-only,  HW:write-only)
 *       3    drying    (SW:read-only,  HW:write-only)
 *       4    discharge (SW:read-only,  HW:write-only)
 *       31:5 rfu       (SW:read-write, HW:read-write) (RESERVED)
 */
/*--------------------------------------------------------------------
 *    Field: ready
 *    Width: 1,             Offset: 0
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Ready for using
 */
#define STT__READY__MASK 0x00000001
#define STT__READY__OFFSET 0
#define STT__READY__GET(reg)\
         DTI_REG_BLK_READ32(reg, STT__READY__MASK, STT__READY__OFFSET)

/*--------------------------------------------------------------------
 *    Field: using
 *    Width: 1,             Offset: 1
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Status Using
 */
#define STT__USING__MASK 0x00000002
#define STT__USING__OFFSET 1
#define STT__USING__GET(reg)\
         DTI_REG_BLK_READ32(reg, STT__USING__MASK, STT__USING__OFFSET)

/*--------------------------------------------------------------------
 *    Field: spraying
 *    Width: 1,             Offset: 2
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Status Spraying
 */
#define STT__SPRAYING__MASK 0x00000004
#define STT__SPRAYING__OFFSET 2
#define STT__SPRAYING__GET(reg)\
         DTI_REG_BLK_READ32(reg, STT__SPRAYING__MASK, STT__SPRAYING__OFFSET)

/*--------------------------------------------------------------------
 *    Field: drying
 *    Width: 1,             Offset: 3
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Status Drying
 */
#define STT__DRYING__MASK 0x00000008
#define STT__DRYING__OFFSET 3
#define STT__DRYING__GET(reg)\
         DTI_REG_BLK_READ32(reg, STT__DRYING__MASK, STT__DRYING__OFFSET)

/*--------------------------------------------------------------------
 *    Field: discharge
 *    Width: 1,             Offset: 4
 *    SW Access: read-only, HW Access: write-only
 *--------------------------------------------------------------------
 *  Status Discharge
 */
#define STT__DISCHARGE__MASK 0x00000010
#define STT__DISCHARGE__OFFSET 4
#define STT__DISCHARGE__GET(reg)\
         DTI_REG_BLK_READ32(reg, STT__DISCHARGE__MASK, STT__DISCHARGE__OFFSET)

/*--------------------------------------------------------------------
 *    Field: rfu (RESERVED)
 *    Width: 27,             Offset: 5
 *    SW Access: read-write, HW Access: read-write
 *--------------------------------------------------------------------
 *  Reserved for Future Use
 */
#define STT__RFU__MASK 0xFFFFFFE0
#define STT__RFU__OFFSET 5

/*************************** Function Definitions *****************************/

u32 read_reg(u32 addr);
void write_reg(u32 addr, u32 data);

void read_reg_data();
void write_reg_ctrl();
void read_reg_stt();

u32 data_temp_get();

void ctrl_warm_en_set(u32 data);

u32 stt_ready_get();
u32 stt_spraying_get();
u32 stt_using_get();
u32 stt_drying_get();
u32 stt_discharge_get();

#endif
