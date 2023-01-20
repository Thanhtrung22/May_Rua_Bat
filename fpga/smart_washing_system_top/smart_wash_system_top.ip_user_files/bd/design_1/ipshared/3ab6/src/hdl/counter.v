//-----------------------------------------------------------------------------------------------------------
//    Copyright (C) 2022 by Hanoi University of Science and Technology
//    All right reserved.
//
//    Copyright Notification
//    No part may be reproduced except as authorized by written permission.
//
//    Module: controller.v
//    Author: Pham Ngoc Lam, Nguyen Viet Thi, Nguyen Huy Nam
//    Date: 11:20:49 06/21/22
//-----------------------------------------------------------------------------------------------------------
module counter #(
  parameter BIT_COUNT = 5
  )  (
  input                           clk     ,  // Clock
  input                           reset_n ,  // Asynchronous reset active low
  input                           ce      , 
  input                           inc     , 
  input                           clr     ,
  output  reg [BIT_COUNT - 1 : 0] count    
);

always @(posedge clk or negedge reset_n) begin : proc_counter
  if(~reset_n) begin
    count <= 0;
  end else if (ce) begin
    if(inc) begin
      count <= count + 1'b1;
    end else begin 
      count <= count;
    end
  end else if (clr) begin
      count <= 0;
  end else begin
    count <= count;
  end
end

endmodule