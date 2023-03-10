//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: clock_generator.v
//    Author: Nguyen Thanh Trung
//    Date: 11:20:49 12/28/22
//-----------------------------------------------------------------------------------------------------------
// Block Settings:
//    rtl.ALT_RESET_ACTIVE_LEVEL      : LOW
//    rtl.ALT_RESET_BLOCK_LABEL_PREFIX: ret_
//    rtl.ALT_RESET_NAME              : alt_reset
//    rtl.ALT_RESET_STYLE             : ASYNC
//    rtl.ARRAY_QUALIFIER             : 
//    rtl.BLOCK_LABEL_CASE            : UPPER
//    rtl.BUS_TYPE                    : NONE
//    rtl.CLOCK                       : clk
//    rtl.CLOCK_EDGE                  : POSITIVE
//    rtl.CONSTANT_CASE               : UPPER
//    rtl.DECLARE_INFERRED_SIGNALS    : TRUE
//    rtl.DEFAULT_FIELD               : def_fld
//    rtl.DEFAULT_RDATA_NAME          : def_rdata_val
//    rtl.DEFAULT_RDATA_VALUE         : 0
//    rtl.DEFAULT_SCALAR_INPUT_TYPE   : wire
//    rtl.DEFAULT_SCALAR_OUTPUT_TYPE  : reg
//    rtl.DEFAULT_VECTOR_INPUT_TYPE   : wire
//    rtl.DEFAULT_VECTOR_OUTPUT_TYPE  : reg
//    rtl.FIELD_INPUT_RW0C_SUFFIX     : _clr_n
//    rtl.FIELD_INPUT_RW0S_SUFFIX     : _set_n
//    rtl.FIELD_INPUT_RW1C_SUFFIX     : _clr
//    rtl.FIELD_INPUT_RW1S_SUFFIX     : _set
//    rtl.FIELD_INPUT_SUFFIX          : _ip
//    rtl.FIELD_NAMING                : %(FIELD_NAME)_%(REGISTER_INSTANCE_NAME)
//    rtl.FILE_NAME                   : %(BLOCK_NAME).%(LANG_FILE_EXTENSION)
//    rtl.IDENTIFIER_CASE             : AS_IS
//    rtl.INCLUDE_FILES               : 
//    rtl.LANGUAGE                    : VLOG_2005
//    rtl.LOCALPARAM_CASE             : UPPER
//    rtl.PARAMETER_CASE              : UPPER
//    rtl.PIPELINE_READ_MUX_SIZES     : 4 4
//    rtl.PIPELINE_READ_STAGES        : 0
//    rtl.PIPELINE_WRITE_MUX_SIZES    : 4 4
//    rtl.PIPELINE_WRITE_STAGES       : 0
//    rtl.QUEUED_FIELD_SUFFIX         : _queued
//    rtl.RADDR                       : raddr
//    rtl.RADDRERR                    : raddrerr
//    rtl.RDATA                       : rdata
//    rtl.READ_ACKNOWLEDGE            : rack
//    rtl.READ_ENABLE_PREFIX          : ren_
//    rtl.READ_MUX_INPUT_BUS_PREFIX   : mux_
//    rtl.RESET                       : reset_n
//    rtl.RESET_LEVEL                 : LOW
//    rtl.RESET_STYLE                 : ASYNC
//    rtl.RSTROBE                     : rstrobe
//    rtl.VHDL_IEEE_REFERENCE_CASE    : LOWER
//    rtl.VHDL_INTERNAL_SUFFIX        : _buf
//    rtl.VHDL_KEYWORD_CASE           : UPPER
//    rtl.WADDR                       : waddr
//    rtl.WADDRERR                    : waddrerr
//    rtl.WDATA                       : wdata
//    rtl.WRITE_ACKNOWLEDGE           : wack
//    rtl.WRITE_ENABLE_PREFIX         : wen_
//    rtl.WSTROBE                     : wstrobe
//----------------------------------------------------------------------

module regs
#(
  parameter ADDR_WIDTH=4,
  parameter DATA_WIDTH=32
)
(

  // FIELD OUTPUT PORTS
  output reg  warm_en_reg_ctrl,

  // FIELD INPUT PORTS
  input wire   [1:0] tem_reg_data_ip     ,
  input wire         discharge_reg_stt_ip,
  input wire         drying_reg_stt_ip   ,
  input wire         spraying_reg_stt_ip ,
  input wire         using_reg_stt_ip    ,
  input wire         ready_reg_stt_ip    ,

  // GENERIC BUS PORTS
  input  wire                  clk     , // Register Bus Clock
  input  wire                  reset_n , // Register Bus Reset
  input  wire [ADDR_WIDTH-1:0] waddr   , // Write Address-Bus
  input  wire [ADDR_WIDTH-1:0] raddr   , // Read Address-Bus
  input  wire [DATA_WIDTH-1:0] wdata   , // Write Data-Bus
  output reg  [DATA_WIDTH-1:0] rdata   , // Read Data-Bus
  input  wire                  rstrobe , // Read-Strobe
  input  wire                  wstrobe , // Write-Strobe
  output reg                   raddrerr, // Read-Address-Error
  output reg                   waddrerr, // Write-Address-Error
  output reg                   wack    , // Write Acknowledge
  output reg                   rack      // Read Acknowledge
);

  // READ/WRITE ENABLE SIGNALS
  reg  wen_reg_ctrl;

  // MUX INPUTS FOR EACH INSTANCE WITH READ ACCESS
  wire [DATA_WIDTH-1:0] mux_reg_data;
  wire [DATA_WIDTH-1:0] mux_reg_ctrl;
  wire [DATA_WIDTH-1:0] mux_reg_stt ;

  // FLIP-FLOP SIGNALS
  reg  [1:0] tem_reg_data_local     ;
  reg        discharge_reg_stt_local;
  reg        drying_reg_stt_local   ;
  reg        spraying_reg_stt_local ;
  reg        using_reg_stt_local    ;
  reg        ready_reg_stt_local    ;

  // DEFAULT VALUE FOR READ DATA BUS
  localparam DEF_RDATA_VAL = 32'h00000000;

  // ADDRESS PARAMETERS
  localparam REG_DATA_ADDR = 4'h0;
  localparam REG_CTRL_ADDR = 4'h4;
  localparam REG_STT_ADDR = 4'h8;

  //----------------------------------------------------------------------
  //                    WRITE ADDRESS DECODE
  //----------------------------------------------------------------------
  always @ ( * )
  begin : WRITE_ENABLE
    wen_reg_ctrl = 1'b0;
    waddrerr = 1'b0;
    wack = 1'b0;

    if (wstrobe)
    begin
      case (waddr)
        REG_CTRL_ADDR:
        begin
          wen_reg_ctrl = 1'b1;
        end
        default:
        begin
          waddrerr = 1'b1;
        end
      endcase
      wack = 1'b1;
    end
  end


  //------------------------------------------------------------
  // Register: data
  //   Data Register
  //   SW Access     : read-write
  //   Address Offset: 0x0
  //   HW Access     : read-write
  // 
  // Instance: reg_data
  //   Data Register
  //   Address Offset: 0x0
  //   Reset Value   : 
  // 
  // Fields:
  //   31:2  rfu (SW:read-write, HW:read-write) (RESERVED) 
  //   1:0  tem (SW:read-only, HW:write-only)

  //------------------------------------------------------------
  //   Field: rfu (reserved)                          
  //   Width: 30             , Offset: 2              
  //   SW Access: read-write , HW Access: read-write  
  //------------------------------------------------------------
  //   Reserved for Future Use
  //

  //------------------------------------------------------------
  //   Field: tem                                    
  //   Width: 2             , Offset: 0              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Temperature Data
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_DATA_TEM_REG_DATA_LOCAL
    // Reset
    if ( !reset_n )
      tem_reg_data_local <= 2'b00;
    // HW:write-only
    else
      tem_reg_data_local <= tem_reg_data_ip;
  end


  //------------------------------------------------------------
  // Register: ctrl
  //   Control Register
  //   SW Access     : read-write
  //   Address Offset: 0x4
  //   HW Access     : read-write
  // 
  // Instance: reg_ctrl
  //   Control Register
  //   Address Offset: 0x4
  //   Reset Value   : 
  // 
  // Fields:
  //   31:1  rfu (SW:read-write, HW:read-write) (RESERVED) 
  //     0  warm_en (SW:read-write, HW:read-only)

  //------------------------------------------------------------
  //   Field: rfu (reserved)                          
  //   Width: 31             , Offset: 1              
  //   SW Access: read-write , HW Access: read-write  
  //------------------------------------------------------------
  //   Reserved for Future Use
  //

  //------------------------------------------------------------
  //   Field: warm_en                                
  //   Width: 1              , Offset: 0             
  //   SW Access: read-write , HW Access: read-only  
  //------------------------------------------------------------
  //   Warm up enable
  //   0: Disable
  //   1: Enable
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_CTRL_WARM_EN_REG_CTRL
    // Reset
    if ( !reset_n )
      warm_en_reg_ctrl <= 1'b0;
    // SW:read-write
    else if (wen_reg_ctrl)
      warm_en_reg_ctrl <= wdata[0];
  end


  //------------------------------------------------------------
  // Register: stt
  //   Status Register
  //   SW Access     : read-write
  //   Address Offset: 0x8
  //   HW Access     : read-write
  // 
  // Instance: reg_stt
  //   Status Register
  //   Address Offset: 0x8
  //   Reset Value   : 
  // 
  // Fields:
  //   31:5  rfu (SW:read-write, HW:read-write) (RESERVED) 
  //     4  discharge (SW:read-only, HW:write-only)
  //     3  drying (SW:read-only, HW:write-only)
  //     2  spraying (SW:read-only, HW:write-only)
  //     1  using (SW:read-only, HW:write-only)
  //     0  ready (SW:read-only, HW:write-only)

  //------------------------------------------------------------
  //   Field: rfu (reserved)                          
  //   Width: 27             , Offset: 5              
  //   SW Access: read-write , HW Access: read-write  
  //------------------------------------------------------------
  //   Reserved for Future Use
  //

  //------------------------------------------------------------
  //   Field: discharge                              
  //   Width: 1             , Offset: 4              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Status Discharge
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_STT_DISCHARGE_REG_STT_LOCAL
    // Reset
    if ( !reset_n )
      discharge_reg_stt_local <= 1'b0;
    // HW:write-only
    else
      discharge_reg_stt_local <= discharge_reg_stt_ip;
  end

  //------------------------------------------------------------
  //   Field: drying                                 
  //   Width: 1             , Offset: 3              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Status Drying
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_STT_DRYING_REG_STT_LOCAL
    // Reset
    if ( !reset_n )
      drying_reg_stt_local <= 1'b0;
    // HW:write-only
    else
      drying_reg_stt_local <= drying_reg_stt_ip;
  end

  //------------------------------------------------------------
  //   Field: spraying                               
  //   Width: 1             , Offset: 2              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Status Spraying
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_STT_SPRAYING_REG_STT_LOCAL
    // Reset
    if ( !reset_n )
      spraying_reg_stt_local <= 1'b0;
    // HW:write-only
    else
      spraying_reg_stt_local <= spraying_reg_stt_ip;
  end

  //------------------------------------------------------------
  //   Field: using                                  
  //   Width: 1             , Offset: 1              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Status Using
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_STT_USING_REG_STT_LOCAL
    // Reset
    if ( !reset_n )
      using_reg_stt_local <= 1'b0;
    // HW:write-only
    else
      using_reg_stt_local <= using_reg_stt_ip;
  end

  //------------------------------------------------------------
  //   Field: ready                                  
  //   Width: 1             , Offset: 0              
  //   SW Access: read-only , HW Access: write-only  
  //------------------------------------------------------------
  //   Ready for using
  //
  always @ (posedge clk or negedge reset_n)
  begin : REG_STT_READY_REG_STT_LOCAL
    // Reset
    if ( !reset_n )
      ready_reg_stt_local <= 1'b0;
    // HW:write-only
    else
      ready_reg_stt_local <= ready_reg_stt_ip;
  end


  //----------------------------------------------------------------------
  //                    READ BUS MULTIPLEXER
  //----------------------------------------------------------------------
  assign mux_reg_data[31:2] = DEF_RDATA_VAL[31:2]; // Default read value for RESERVED field - rfu
  assign mux_reg_data[1:0] = tem_reg_data_local;

  assign mux_reg_ctrl[31:1] = DEF_RDATA_VAL[31:1]; // Default read value for RESERVED field - rfu
  assign mux_reg_ctrl[0] = warm_en_reg_ctrl;

  assign mux_reg_stt[31:5] = DEF_RDATA_VAL[31:5]; // Default read value for RESERVED field - rfu
  assign mux_reg_stt[4] = discharge_reg_stt_local;
  assign mux_reg_stt[3] = drying_reg_stt_local;
  assign mux_reg_stt[2] = spraying_reg_stt_local;
  assign mux_reg_stt[1] = using_reg_stt_local;
  assign mux_reg_stt[0] = ready_reg_stt_local;

  // PUT REGISTER VALUE ON READ DATA BUS
  always @ ( * )
  begin : READ_BUS_MUX
    raddrerr = 1'b0;
    rdata = DEF_RDATA_VAL;
    if (rstrobe )
    begin
      case (raddr)
        REG_DATA_ADDR:
        begin
          rdata = mux_reg_data;
        end
        REG_CTRL_ADDR:
        begin
          rdata = mux_reg_ctrl;
        end
        REG_STT_ADDR:
        begin
          rdata = mux_reg_stt;
        end
        default:
        begin
          raddrerr = 1'b1;
        end
      endcase
    end
    rack = rstrobe;
  end
endmodule

