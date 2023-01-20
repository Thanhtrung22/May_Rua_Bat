//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: core.v
//    Author: Pham Ngoc Lam, Nguyen Viet Thi, Nguyen Huy Nam
//    Date: 11:20:49 06/21/22
//-----------------------------------------------------------------------------------------------------------
module core (
  input         clk               ,  // Clock 1MHz
  input         reset_n           ,  // Asynchronous reset active low
  input         reg_user_en       , 
  input         reg_toilet_using  , 
  input         reg_spray_en      , 
  input         reg_sp_dr_auto_en , 
  input         reg_spray_mode    , 
  input         reg_auto_dis_en   , 
  input         reg_de_ur         , 
  input         warm_en           , 
  output  wire  warm_up_on        , 
  output  wire  open_toilet_lid   , 
  output  wire  led_using         , 
  output  wire  spray_an          , 
  output  wire  user_flushes      , 
  output  wire  dis_de            , 
  output  wire  count_spray_done  , 
  output  wire  count_drying_done , 
  output  wire  count_dis_done    , 
  output  wire  stt_ready         , 
  output  wire  stt_using         , 
  output  wire  stt_spraying      , 
  output  wire  stt_drying        , 
  output  wire  stt_discharge       
);

// -------------------------------------------------------------
// Signal Declaration
// -------------------------------------------------------------
wire ce;
wire enable;

// -------------------------------------------------------------
// Clock generator
// -------------------------------------------------------------
clock_generator clock_generator (
  .clk    (clk      ),
  .reset_n(reset_n  ),
  .enable (enable   ),
  .ce     (ce       )
  );

// -------------------------------------------------------------
// Controller
// -------------------------------------------------------------
controller controller (
  .clk              (clk              ), 
  .reset_n          (reset_n          ), 
  .reg_user_en      (reg_user_en      ), 
  .reg_toilet_using (reg_toilet_using ), 
  .reg_spray_en     (reg_spray_en     ), 
  .reg_spray_mode   (reg_spray_mode   ), 
  .reg_sp_dr_auto_en(reg_sp_dr_auto_en), 
  .reg_auto_dis_en  (reg_auto_dis_en  ), 
  .reg_de_ur        (reg_de_ur        ), 
  .ce               (ce               ), 
  .enable           (enable           ), 
  .count_spray_done (count_spray_done ), 
  .count_drying_done(count_drying_done), 
  .count_dis_done   (count_dis_done   ), 
  .open_toilet_lid  (open_toilet_lid  ), 
  .led_using        (led_using        ), 
  .spray_an         (spray_an         ), 
  .user_flushes     (user_flushes     ), 
  .dis_de           (dis_de           ), 
  .stt_ready        (stt_ready        ), 
  .stt_using        (stt_using        ), 
  .stt_drying       (stt_drying       ), 
  .stt_spraying     (stt_spraying     ), 
  .stt_discharge    (stt_discharge    )  
  );

// -------------------------------------------------------------
// Warm up
// -------------------------------------------------------------
warm_up warm_up(
  .warm_en    (warm_en    ),
  .warm_up_on (warm_up_on )
  );

endmodule