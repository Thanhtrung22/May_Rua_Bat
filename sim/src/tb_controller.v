`timescale 1ns/1ns
module tb_controller ();
reg clk               ;
reg reset_n           ;
reg reg_user_en       ;
reg reg_spray_en      ;
reg reg_spray_mode    ;
reg reg_auto_dis_en   ;
reg reg_de_ur         ;
wire led_user         ;
wire spray_an         ;
wire user_flushes     ;
wire dis_ur           ;
wire count_spray_done ;

always #5 clk = ~clk;

controller controller (
.clk             (clk),
.reset_n         (reset_n),
.reg_user_en     (reg_user_en),
.reg_spray_en    (reg_spray_en),
.reg_spray_mode  (reg_spray_mode),
.reg_auto_dis_en (reg_auto_dis_en),
.reg_de_ur       (reg_de_ur),
.led_user        (led_user),
.spray_an        (spray_an),
.user_flushes    (user_flushes),
.dis_ur          (dis_ur),
.count_spray_done(count_spray_done)
  );

initial begin
  clk = 0;
  reset_n = 1;
  reg_user_en     = 0;
  reg_spray_en    = 0;
  reg_spray_mode  = 0;
  reg_auto_dis_en = 0;
  reg_de_ur       = 0;
  @(posedge clk);
  reset_n = 0;
  @(posedge clk);
  reset_n = 1;
  #2;
  reg_user_en = 1;
  repeat(2) @(posedge clk);
  reg_spray_en = 1;
  reg_auto_dis_en = 1;
  reg_de_ur       = 1;
  repeat(50) @(posedge clk);
  reg_user_en     = 0;
  repeat(60) @(posedge clk);
  $finish;
end

endmodule