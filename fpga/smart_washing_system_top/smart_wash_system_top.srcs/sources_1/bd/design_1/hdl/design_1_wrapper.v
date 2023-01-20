//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.1 (lin64) Build 2188600 Wed Apr  4 18:39:19 MDT 2018
//Date        : Tue Jun 28 13:42:04 2022
//Host        : nguyenvietthi running 64-bit Ubuntu 20.04.4 LTS
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
   (DDR_addr,
    DDR_ba,
    DDR_cas_n,
    DDR_ck_n,
    DDR_ck_p,
    DDR_cke,
    DDR_cs_n,
    DDR_dm,
    DDR_dq,
    DDR_dqs_n,
    DDR_dqs_p,
    DDR_odt,
    DDR_ras_n,
    DDR_reset_n,
    DDR_we_n,
    FIXED_IO_ddr_vrn,
    FIXED_IO_ddr_vrp,
    FIXED_IO_mio,
    FIXED_IO_ps_clk,
    FIXED_IO_ps_porb,
    FIXED_IO_ps_srstb,
    button_reset,
    ctrl_auto_dis_en,
    ctrl_de_ur,
    ctrl_sp_dr_auto_en,
    ctrl_spray_en,
    ctrl_spray_mode,
    ctrl_toilet_using,
    ctrl_user_en,
    data,
    data_tem,
    dis_de,
    led_using,
    oled_dc_n,
    oled_reset_n,
    oled_spi_clk,
    oled_spi_data,
    oled_vbat,
    oled_vdd,
    open_toilet_lid,
    spray_an,
    user_flushes,
    warm_up_on);
  inout [14:0]DDR_addr;
  inout [2:0]DDR_ba;
  inout DDR_cas_n;
  inout DDR_ck_n;
  inout DDR_ck_p;
  inout DDR_cke;
  inout DDR_cs_n;
  inout [3:0]DDR_dm;
  inout [31:0]DDR_dq;
  inout [3:0]DDR_dqs_n;
  inout [3:0]DDR_dqs_p;
  inout DDR_odt;
  inout DDR_ras_n;
  inout DDR_reset_n;
  inout DDR_we_n;
  inout FIXED_IO_ddr_vrn;
  inout FIXED_IO_ddr_vrp;
  inout [53:0]FIXED_IO_mio;
  inout FIXED_IO_ps_clk;
  inout FIXED_IO_ps_porb;
  inout FIXED_IO_ps_srstb;
  input button_reset;
  input ctrl_auto_dis_en;
  input ctrl_de_ur;
  input ctrl_sp_dr_auto_en;
  input ctrl_spray_en;
  input ctrl_spray_mode;
  input ctrl_toilet_using;
  input ctrl_user_en;
  inout data;
  input [1:0]data_tem;
  output dis_de;
  output led_using;
  output oled_dc_n;
  output oled_reset_n;
  output oled_spi_clk;
  output oled_spi_data;
  output oled_vbat;
  output oled_vdd;
  output open_toilet_lid;
  output spray_an;
  output user_flushes;
  output warm_up_on;

  wire [14:0]DDR_addr;
  wire [2:0]DDR_ba;
  wire DDR_cas_n;
  wire DDR_ck_n;
  wire DDR_ck_p;
  wire DDR_cke;
  wire DDR_cs_n;
  wire [3:0]DDR_dm;
  wire [31:0]DDR_dq;
  wire [3:0]DDR_dqs_n;
  wire [3:0]DDR_dqs_p;
  wire DDR_odt;
  wire DDR_ras_n;
  wire DDR_reset_n;
  wire DDR_we_n;
  wire FIXED_IO_ddr_vrn;
  wire FIXED_IO_ddr_vrp;
  wire [53:0]FIXED_IO_mio;
  wire FIXED_IO_ps_clk;
  wire FIXED_IO_ps_porb;
  wire FIXED_IO_ps_srstb;
  wire button_reset;
  wire ctrl_auto_dis_en;
  wire ctrl_de_ur;
  wire ctrl_sp_dr_auto_en;
  wire ctrl_spray_en;
  wire ctrl_spray_mode;
  wire ctrl_toilet_using;
  wire ctrl_user_en;
  wire data;
  wire [1:0]data_tem;
  wire dis_de;
  wire led_using;
  wire oled_dc_n;
  wire oled_reset_n;
  wire oled_spi_clk;
  wire oled_spi_data;
  wire oled_vbat;
  wire oled_vdd;
  wire open_toilet_lid;
  wire spray_an;
  wire user_flushes;
  wire warm_up_on;

  design_1 design_1_i
       (.DDR_addr(DDR_addr),
        .DDR_ba(DDR_ba),
        .DDR_cas_n(DDR_cas_n),
        .DDR_ck_n(DDR_ck_n),
        .DDR_ck_p(DDR_ck_p),
        .DDR_cke(DDR_cke),
        .DDR_cs_n(DDR_cs_n),
        .DDR_dm(DDR_dm),
        .DDR_dq(DDR_dq),
        .DDR_dqs_n(DDR_dqs_n),
        .DDR_dqs_p(DDR_dqs_p),
        .DDR_odt(DDR_odt),
        .DDR_ras_n(DDR_ras_n),
        .DDR_reset_n(DDR_reset_n),
        .DDR_we_n(DDR_we_n),
        .FIXED_IO_ddr_vrn(FIXED_IO_ddr_vrn),
        .FIXED_IO_ddr_vrp(FIXED_IO_ddr_vrp),
        .FIXED_IO_mio(FIXED_IO_mio),
        .FIXED_IO_ps_clk(FIXED_IO_ps_clk),
        .FIXED_IO_ps_porb(FIXED_IO_ps_porb),
        .FIXED_IO_ps_srstb(FIXED_IO_ps_srstb),
        .button_reset(button_reset),
        .ctrl_auto_dis_en(ctrl_auto_dis_en),
        .ctrl_de_ur(ctrl_de_ur),
        .ctrl_sp_dr_auto_en(ctrl_sp_dr_auto_en),
        .ctrl_spray_en(ctrl_spray_en),
        .ctrl_spray_mode(ctrl_spray_mode),
        .ctrl_toilet_using(ctrl_toilet_using),
        .ctrl_user_en(ctrl_user_en),
        .data(data),
        .data_tem(data_tem),
        .dis_de(dis_de),
        .led_using(led_using),
        .oled_dc_n(oled_dc_n),
        .oled_reset_n(oled_reset_n),
        .oled_spi_clk(oled_spi_clk),
        .oled_spi_data(oled_spi_data),
        .oled_vbat(oled_vbat),
        .oled_vdd(oled_vdd),
        .open_toilet_lid(open_toilet_lid),
        .spray_an(spray_an),
        .user_flushes(user_flushes),
        .warm_up_on(warm_up_on));
endmodule
