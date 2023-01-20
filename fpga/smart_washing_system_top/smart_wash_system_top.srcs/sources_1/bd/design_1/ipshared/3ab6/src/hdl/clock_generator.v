//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: clock_generator.v
//    Author: Pham Ngoc Lam, Nguyen Viet Thi, Nguyen Huy Nam
//    Date: 11:20:49 06/21/22
//-----------------------------------------------------------------------------------------------------------
module clock_generator #(
  parameter SYS_FREQ  = 10000000,
  parameter CLOCK     = 1,
  parameter DIV       = SYS_FREQ/(CLOCK*2)
  )(
  input       clk    , // Clock
  input       reset_n, // Asynchronous reset active low
  input       enable ,
  output wire ce      
);

reg [$clog2(DIV) - 1 : 0] count_ce;

always @(posedge clk or negedge reset_n) begin : proc_ce
  if(~reset_n) begin
    count_ce <= 0;
  end
  else if (enable) begin
    if (count_ce == (DIV - 1)) begin
      count_ce <= 0;
    end
    else count_ce <= count_ce + 1;
  end
  else count_ce = count_ce;
end

assign ce = (count_ce == (DIV - 1));

endmodule