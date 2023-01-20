// (c) Copyright 1995-2022 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.


// IP VLNV: user.org:user:system_controller:1.0
// IP Revision: 2

`timescale 1ns/1ps

(* DowngradeIPIdentifiedWarnings = "yes" *)
module design_1_system_controller_0_0 (
  clk,
  reset_n,
  presetn,
  pclk,
  paddr,
  psel,
  penable,
  pwrite,
  pwdata,
  pready,
  prdata,
  pslverr,
  data_tem,
  ctrl_user_en,
  ctrl_toilet_using,
  ctrl_auto_dis_en,
  ctrl_de_ur,
  ctrl_sp_dr_auto_en,
  ctrl_spray_en,
  ctrl_spray_mode,
  warm_up_on,
  open_toilet_lid,
  led_using,
  spray_an,
  user_flushes,
  dis_de
);

(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME clk, FREQ_HZ 10000000, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK1" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 clk CLK" *)
input wire clk;
(* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME reset_n, POLARITY ACTIVE_LOW" *)
(* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 reset_n RST" *)
input wire reset_n;
input wire presetn;
input wire pclk;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PADDR" *)
input wire [7 : 0] paddr;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PSEL" *)
input wire psel;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PENABLE" *)
input wire penable;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PWRITE" *)
input wire pwrite;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PWDATA" *)
input wire [31 : 0] pwdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PREADY" *)
output wire pready;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PRDATA" *)
output wire [31 : 0] prdata;
(* X_INTERFACE_INFO = "xilinx.com:interface:apb:1.0 interface_apb PSLVERR" *)
output wire pslverr;
input wire [1 : 0] data_tem;
input wire ctrl_user_en;
input wire ctrl_toilet_using;
input wire ctrl_auto_dis_en;
input wire ctrl_de_ur;
input wire ctrl_sp_dr_auto_en;
input wire ctrl_spray_en;
input wire ctrl_spray_mode;
output wire warm_up_on;
output wire open_toilet_lid;
output wire led_using;
output wire spray_an;
output wire user_flushes;
output wire dis_de;

  smart_toilet_system_top inst (
    .clk(clk),
    .reset_n(reset_n),
    .presetn(presetn),
    .pclk(pclk),
    .paddr(paddr),
    .psel(psel),
    .penable(penable),
    .pwrite(pwrite),
    .pwdata(pwdata),
    .pready(pready),
    .prdata(prdata),
    .pslverr(pslverr),
    .data_tem(data_tem),
    .ctrl_user_en(ctrl_user_en),
    .ctrl_toilet_using(ctrl_toilet_using),
    .ctrl_auto_dis_en(ctrl_auto_dis_en),
    .ctrl_de_ur(ctrl_de_ur),
    .ctrl_sp_dr_auto_en(ctrl_sp_dr_auto_en),
    .ctrl_spray_en(ctrl_spray_en),
    .ctrl_spray_mode(ctrl_spray_mode),
    .warm_up_on(warm_up_on),
    .open_toilet_lid(open_toilet_lid),
    .led_using(led_using),
    .spray_an(spray_an),
    .user_flushes(user_flushes),
    .dis_de(dis_de)
  );
endmodule
