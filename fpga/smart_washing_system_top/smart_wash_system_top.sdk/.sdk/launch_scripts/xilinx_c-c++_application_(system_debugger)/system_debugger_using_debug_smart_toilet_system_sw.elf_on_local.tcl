connect -url tcp:127.0.0.1:3121
source /media/nguyenvietthi/DATA/nam4/HTN/embedded_system_20212/fpga/smart_toilet_system_top/smart_toilet_system_top.sdk/design_1_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248AC888E"} -index 0
rst -system
after 3000
targets -set -filter {jtag_cable_name =~ "Digilent Zed 210248AC888E" && level==0} -index 1
fpga -file /media/nguyenvietthi/DATA/nam4/HTN/embedded_system_20212/fpga/smart_toilet_system_top/smart_toilet_system_top.sdk/design_1_wrapper_hw_platform_0/design_1_wrapper.bit
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248AC888E"} -index 0
loadhw -hw /media/nguyenvietthi/DATA/nam4/HTN/embedded_system_20212/fpga/smart_toilet_system_top/smart_toilet_system_top.sdk/design_1_wrapper_hw_platform_0/system.hdf -mem-ranges [list {0x40000000 0xbfffffff}]
configparams force-mem-access 1
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248AC888E"} -index 0
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248AC888E"} -index 0
dow /media/nguyenvietthi/DATA/nam4/HTN/embedded_system_20212/fpga/smart_toilet_system_top/smart_toilet_system_top.sdk/smart_toilet_system_sw/Debug/smart_toilet_system_sw.elf
configparams force-mem-access 0
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248AC888E"} -index 0
con
