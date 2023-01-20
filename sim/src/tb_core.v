`timescale 1ns/1ns
module tb_core ();
reg   clk               ;
reg   reset_n           ;
reg   reg_user_en       ;
reg   reg_wash_using  ;
reg   reg_spray_en      ;
reg   reg_sp_dr_auto_en ;
reg   reg_spray_mode    ;
reg   reg_auto_dis_en   ;
reg   reg_de_ur         ;
reg   warm_en           ;
wire  warm_up_on        ;
wire  open_wash_lid   ;
wire  led_using         ;
wire  spray_an          ;
wire  user_flushes      ;
wire  dis_de            ;
wire  count_spray_done  ;
wire  count_drying_done ;
wire  stt_ready         ;
wire  stt_using         ;
wire  stt_spraying      ;
wire  stt_drying        ;
wire  stt_discharge     ;

always #5 clk = ~clk;

core core (
  .clk              (clk              ),
  .reset_n          (reset_n          ),
  .reg_user_en      (reg_user_en      ),
  .reg_wash_using (reg_wash_using ),
  .reg_spray_en     (reg_spray_en     ),
  .reg_sp_dr_auto_en(reg_sp_dr_auto_en),
  .reg_spray_mode   (reg_spray_mode   ),
  .reg_auto_dis_en  (reg_auto_dis_en  ),
  .reg_de_ur        (reg_de_ur        ),
  .warm_en          (warm_en          ),
  .warm_up_on       (warm_up_on       ),
  .open_wash_lid  (open_wash_lid  ),
  .led_using        (led_using        ),
  .spray_an         (spray_an         ),
  .user_flushes     (user_flushes     ),
  .dis_de           (dis_de           ),
  .count_spray_done (count_spray_done ),
  .count_drying_done(count_drying_done),
  .count_dis_done   (count_dis_done   ),
  .stt_ready        (stt_ready        ),
  .stt_using        (stt_using        ),
  .stt_spraying     (stt_spraying     ),
  .stt_drying       (stt_drying       ),
  .stt_discharge    (stt_discharge    )
  );

initial begin
  clk               = 0;
  reset_n           = 1;
  reg_user_en       = 0;
  reg_wash_using  = 0;
  reg_spray_en      = 0;
  reg_sp_dr_auto_en = 1;
  reg_spray_mode    = 0;
  reg_auto_dis_en   = 1;
  reg_de_ur         = 0;
  warm_en           = 0;
  @(posedge clk);
  reset_n = 0;
  @(posedge clk);
  reset_n = 1;
  #2;
  reg_user_en       = 1;
  repeat(5) @(posedge clk);
  reg_wash_using  = 1;
  repeat(10) @(posedge clk);
  reg_spray_en      = 1;
  reg_de_ur         = 1;
  repeat(250) @(posedge clk);
  reg_spray_en      = 0;
  reg_wash_using  = 0;
  reg_user_en       = 0;
  repeat(50) @(posedge clk);
  $finish;
end

endmodule