#OLED
set_property PACKAGE_PIN U10 [get_ports oled_dc_n];
set_property PACKAGE_PIN U9 [get_ports oled_reset_n];
set_property PACKAGE_PIN AB12 [get_ports oled_spi_clk];
set_property PACKAGE_PIN AA12 [get_ports oled_spi_data];
set_property PACKAGE_PIN U11 [get_ports oled_vbat];
set_property PACKAGE_PIN U12 [get_ports oled_vdd];
set_property IOSTANDARD LVCMOS33 [get_ports oled_dc_n];
set_property IOSTANDARD LVCMOS33 [get_ports oled_reset_n];
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_clk];
set_property IOSTANDARD LVCMOS33 [get_ports oled_spi_data];
set_property IOSTANDARD LVCMOS33 [get_ports oled_vbat];
set_property IOSTANDARD LVCMOS33 [get_ports oled_vdd];

#LEDS
set_property PACKAGE_PIN  T22    [get_ports {warm_up_on     }];
set_property PACKAGE_PIN  T21    [get_ports {open_toilet_lid}];
set_property PACKAGE_PIN  U22    [get_ports {led_using      }];
set_property PACKAGE_PIN  U21    [get_ports {spray_an       }];
set_property PACKAGE_PIN  V22    [get_ports {dis_de         }];

set_property PACKAGE_PIN  Y11    [get_ports {user_flushes}];  # "JA1"
set_property PACKAGE_PIN AA11    [get_ports {data        }];  # "JA2"

set_property IOSTANDARD LVCMOS33 [get_ports {warm_up_on     }];
set_property IOSTANDARD LVCMOS33 [get_ports {open_toilet_lid}];
set_property IOSTANDARD LVCMOS33 [get_ports {led_using      }];
set_property IOSTANDARD LVCMOS33 [get_ports {spray_an       }];
set_property IOSTANDARD LVCMOS33 [get_ports {dis_de         }];

set_property IOSTANDARD LVCMOS33 [get_ports {user_flushes   }];
set_property IOSTANDARD LVCMOS33 [get_ports {data           }];

#ctrl_input
set_property PACKAGE_PIN F22 [get_ports {data_tem[0]       }];  # "SW0"
set_property PACKAGE_PIN G22 [get_ports {data_tem[1]       }];  # "SW1"
set_property PACKAGE_PIN H22 [get_ports {ctrl_toilet_using }];  # "SW2"
set_property PACKAGE_PIN F21 [get_ports {ctrl_spray_mode   }];  # "SW3"
set_property PACKAGE_PIN H19 [get_ports {ctrl_spray_en     }];  # "SW4"
set_property PACKAGE_PIN H18 [get_ports {ctrl_sp_dr_auto_en}];  # "SW5"
set_property PACKAGE_PIN H17 [get_ports {ctrl_de_ur        }];  # "SW6"
set_property PACKAGE_PIN M15 [get_ports {ctrl_auto_dis_en  }];  # "SW7"
set_property IOSTANDARD LVCMOS33 [get_ports {data_tem[1]       }];
set_property IOSTANDARD LVCMOS33 [get_ports {data_tem[0]       }];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_toilet_using }];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_spray_mode   }];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_spray_en     }];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_sp_dr_auto_en}];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_de_ur        }];
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_auto_dis_en  }];

set_property PACKAGE_PIN P16     [get_ports {ctrl_user_en}];  # "BTNC"
set_property PACKAGE_PIN R16     [get_ports {button_reset}];  # "BTND"
set_property IOSTANDARD LVCMOS33 [get_ports {ctrl_user_en}];
set_property IOSTANDARD LVCMOS33 [get_ports {button_reset}];