module register_block ( 
  input        [1:0]     data_tem,
  output wire            ctrl_warm_en,
  input                  stt_ready,
  input                  stt_using,
  input                  stt_spraying,
  input                  stt_drying,
  input                  stt_discharge,
// APB Bridge
  input                 presetn,
  input                 pclk,
  input     [7:0]       paddr,
  input                 psel,
  input                 penable,
  input                 pwrite,
  input     [31:0]      pwdata,
  output                pready,
  output    [31:0]      prdata,
  output                pslverr,
// FIFO signals
  output    [7:0]       waddr,
  output    [7:0]       raddr,
  output    [31:0]      wdata,
  output                rstrobe,
  output                wstrobe
);

//-------------------------------------------------------------------------
// Internal Signals
//-------------------------------------------------------------------------
  wire                  clk;
  wire                  reset_n;
  wire         [31:0]   rdata;
  wire                  waddrerr;
  wire                  raddrerr;
  wire                  wack;
  wire                  rack;

//-------------------------------------------------------------------------
// Module Instances
//-------------------------------------------------------------------------
//-------------------------------------------------------------------------
// Module regs Instance
//-------------------------------------------------------------------------
  regs regs (
    .warm_en_reg_ctrl    (ctrl_warm_en    ),
    .tem_reg_data_ip     (data_tem        ),
    .discharge_reg_stt_ip(stt_discharge   ),
    .drying_reg_stt_ip   (stt_drying      ),
    .spraying_reg_stt_ip (stt_spraying    ),
    .using_reg_stt_ip    (stt_using       ),
    .ready_reg_stt_ip    (stt_ready       ),
    .clk                 (clk             ),
    .reset_n             (reset_n         ),
    .waddr               (waddr           ),
    .raddr               (raddr           ),
    .wdata               (wdata           ),
    .rdata               (rdata           ),
    .rstrobe             (rstrobe         ),
    .wstrobe             (wstrobe         ),
    .raddrerr            (raddrerr        ),
    .waddrerr            (waddrerr        ),
    .wack                (wack            ),
    .rack                (rack            )
  );

//-------------------------------------------------------------------------
// Module rb_apb_bridge Instance
//-------------------------------------------------------------------------
  rb_apb_bridge
  rb_apb_bridge ( 
    .presetn                           (presetn                            ),
    .pclk                              (pclk                               ),
    .paddr                             (paddr                              ),
    .psel                              (psel                               ),
    .penable                           (penable                            ),
    .pwrite                            (pwrite                             ),
    .pwdata                            (pwdata                             ),
    .pready                            (pready                             ),
    .prdata                            (prdata                             ),
    .pslverr                           (pslverr                            ),
    .clk                               (clk                                ),
    .reset_n                           (reset_n                            ),
    .rstrobe                           (rstrobe                            ),
    .raddr                             (raddr                              ),
    .rdata                             (rdata                              ),
    .rack                              (rack                               ),
    .raddrerr                          (raddrerr                           ),
    .wstrobe                           (wstrobe                            ),
    .waddr                             (waddr                              ),
    .wdata                             (wdata                              ),
    .wack                              (wack                               ),
    .waddrerr                          (waddrerr                           )
  ); 

endmodule