onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_core/core/clk
add wave -noupdate /tb_core/core/reset_n
add wave -noupdate /tb_core/core/reg_user_en
add wave -noupdate /tb_core/core/reg_toilet_using
add wave -noupdate /tb_core/core/reg_spray_en
add wave -noupdate /tb_core/core/reg_sp_dr_auto_en
add wave -noupdate /tb_core/core/reg_spray_mode
add wave -noupdate /tb_core/core/reg_auto_dis_en
add wave -noupdate /tb_core/core/reg_de_ur
add wave -noupdate /tb_core/core/warm_en
add wave -noupdate /tb_core/core/warm_up_on
add wave -noupdate /tb_core/core/open_toilet_lid
add wave -noupdate /tb_core/core/led_using
add wave -noupdate /tb_core/core/spray_an
add wave -noupdate /tb_core/core/user_flushes
add wave -noupdate /tb_core/core/dis_de
add wave -noupdate /tb_core/core/count_spray_done
add wave -noupdate /tb_core/core/count_drying_done
add wave -noupdate /tb_core/core/stt_ready
add wave -noupdate /tb_core/core/stt_using
add wave -noupdate /tb_core/core/stt_spraying
add wave -noupdate /tb_core/core/stt_drying
add wave -noupdate /tb_core/core/ce
add wave -noupdate /tb_core/core/enable
add wave -noupdate -expand -group controller /tb_core/core/controller/open_toilet_lid
add wave -noupdate -expand -group controller /tb_core/core/controller/led_using
add wave -noupdate -expand -group controller /tb_core/core/controller/spray_an
add wave -noupdate -expand -group controller /tb_core/core/controller/user_flushes
add wave -noupdate -expand -group controller /tb_core/core/controller/dis_de
add wave -noupdate -expand -group controller /tb_core/core/controller/count_spray_done
add wave -noupdate -expand -group controller /tb_core/core/controller/count_drying_done
add wave -noupdate -expand -group controller /tb_core/core/controller/stt_ready
add wave -noupdate -expand -group controller /tb_core/core/controller/stt_using
add wave -noupdate -expand -group controller /tb_core/core/controller/stt_spraying
add wave -noupdate -expand -group controller /tb_core/core/controller/stt_drying
add wave -noupdate -expand -group controller /tb_core/core/controller/count_spray
add wave -noupdate -expand -group controller /tb_core/core/controller/count_drying
add wave -noupdate -expand -group controller /tb_core/core/controller/inc_count_spray
add wave -noupdate -expand -group controller /tb_core/core/controller/clr_count_spray
add wave -noupdate -expand -group controller /tb_core/core/controller/inc_count_drying
add wave -noupdate -expand -group controller /tb_core/core/controller/clr_count_drying
add wave -noupdate -expand -group controller /tb_core/core/controller/open_toilet_lid_cld
add wave -noupdate -expand -group controller /tb_core/core/controller/spray_an_cld
add wave -noupdate -expand -group controller /tb_core/core/controller/user_flushes_cld
add wave -noupdate -expand -group controller /tb_core/core/controller/dis_de_cld
add wave -noupdate -expand -group controller /tb_core/core/controller/ready
add wave -noupdate -expand -group controller /tb_core/core/controller/using
add wave -noupdate -expand -group controller /tb_core/core/controller/current_state
add wave -noupdate -expand -group controller /tb_core/core/controller/next_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {5 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {3239 ns}
