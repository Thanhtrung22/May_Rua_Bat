//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: smart_toilet_system_top.v
//    Author: Pham Ngoc Lam, Nguyen Viet Thi, Nguyen Huy Nam
//    Date: 11:20:49 06/21/22
//-----------------------------------------------------------------------------------------------------------
module smart_toilet_system_top (
  input                     clk                 ,  // Clock
  input                     reset_n             ,  // Asynchronous reset active low
  input                     presetn             ,
  input                     pclk                ,
  input         [7:0]       paddr               ,
  input                     psel                ,
  input                     penable             ,
  input                     pwrite              ,
  input         [31:0]      pwdata              ,
  output  wire              pready              ,
  output  wire  [31:0]      prdata              ,
  output  wire              pslverr             ,
  input         [1:0]       data_tem            ,
  input                     ctrl_user_en        ,
  input                     ctrl_toilet_using   ,
  input                     ctrl_auto_dis_en    ,
  input                     ctrl_de_ur          ,
  input                     ctrl_sp_dr_auto_en  ,
  input                     ctrl_spray_en       ,
  input                     ctrl_spray_mode     ,
  output  wire              warm_up_on          ,
  output  wire              open_toilet_lid     ,
  output  wire              led_using           ,
  output  wire              spray_an            ,
  output  wire              user_flushes        ,
  output  wire              dis_de              
);

// -------------------------------------------------------------
// Signal Declaration
wire  ctrl_warm_en        ;
wire  stt_ready           ;
wire  stt_using           ;
wire  stt_spraying        ;
wire  stt_drying          ;
wire  stt_discharge       ;

core core(
  .clk               (clk                 ), 
  .reset_n           (reset_n             ), 
  .reg_user_en       (ctrl_user_en        ), 
  .reg_toilet_using  (ctrl_toilet_using   ), 
  .reg_spray_en      (ctrl_spray_en       ), 
  .reg_sp_dr_auto_en (ctrl_sp_dr_auto_en  ), 
  .reg_spray_mode    (ctrl_spray_mode     ), 
  .reg_auto_dis_en   (ctrl_auto_dis_en    ), 
  .reg_de_ur         (ctrl_de_ur          ), 
  .warm_en           (ctrl_warm_en        ), 
  .warm_up_on        (warm_up_on          ), 
  .open_toilet_lid   (open_toilet_lid     ), 
  .led_using         (led_using           ), 
  .spray_an          (spray_an            ), 
  .user_flushes      (user_flushes        ), 
  .dis_de            (dis_de              ), 
  .count_spray_done  ( ), 
  .count_drying_done ( ), 
  .count_dis_done    ( ), 
  .stt_ready         (stt_ready           ), 
  .stt_using         (stt_using           ), 
  .stt_spraying      (stt_spraying        ), 
  .stt_drying        (stt_drying          ), 
  .stt_discharge     (stt_discharge       )  
  );

register_block register_block(
  .data_tem           (data_tem           ),
  .ctrl_warm_en       (ctrl_warm_en       ),
  .stt_ready          (stt_ready          ),
  .stt_using          (stt_using          ),
  .stt_spraying       (stt_spraying       ),
  .stt_drying         (stt_drying         ),
  .stt_discharge      (stt_discharge      ),
  .presetn            (presetn            ),
  .pclk               (pclk               ),
  .paddr              (paddr              ),
  .psel               (psel               ),
  .penable            (penable            ),
  .pwrite             (pwrite             ),
  .pwdata             (pwdata             ),
  .pready             (pready             ),
  .prdata             (prdata             ),
  .pslverr            (pslverr            )
  );

endmodule