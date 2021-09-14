set project voltmeter
set top_module voltmeter
set target xc7a35tcpg236-1
# if generate_rtl 1 then during executing bitstream will be created rtl_schematic pdf
set generate_rtl 0
# set path where vivado has to put project and running output
set build_path ../vivado/build
# set simulation top module
set top_sim_module draw_rect_ctl

set bitstream_file ${build_path}/${project}.runs/impl_1/${top_module}.bit


proc usage {} {
        puts "usage: vivado -mode tcl -source [info script] -tclargs \[simulation/bitstream/program/run\]"
        exit 1
}

# files for bitstream

proc attach_rtl_files {} {

        remove_files [get_files -quiet]
        read_xdc {
                constraints/voltmeter.xdc
        }

        read_vhdl {
                rtl/pmodAD2_ctrl.vhd
                rtl/TWICtl.vhd
        }

        read_verilog {
                rtl/voltmeter.v
                rtl/clk_generator.v
                rtl/internal_reset.v
                
                rtl/internal_adc.v
                rtl/xadc.v
                rtl/voltage_scaler.v
                rtl/bin2bcd.v
                
                rtl/external_adc.v
                rtl/pmod_control.v
                
                rtl/uart_control.v
                rtl/uart.v
                rtl/mod_m_counter.v
                rtl/fifo.v
                rtl/uart_tx.v
                   
                rtl/vga_timing.v
                rtl/vga_draw_background.v
                rtl/image_rom.v
                rtl/top_draw_rect.v
                rtl/vga_top_draw_char.v
                rtl/draw_rect.v
                rtl/vga_draw_char.v
                rtl/delay.v 
                rtl/vga_font_rom.v
                rtl/bcdword2ascii1_16.v
                rtl/bcd2ascii1_4.v
                rtl/vga_measurements_rom.v



        }
}

# files for simulation

proc attach_sim_files {} {

        remove_files [get_files -quiet]

        # if you run simulation for the same top module that bitstream then leave this section otherwise 
        # comment attach_rtl_files and uncomment PUT YOUR CODE HERE where you need to add your own sim files 

        # attach_rtl_files

        #-------------------PUT YOUR CODE HERE-------------------
        read_xdc {
                constraints/voltmeter.xdc
        }

        # read_vhdl {
        # }

        read_verilog {
                rtl/uart_control.v
        }

        # read_mem {
        # }
        
        add_files -fileset sim_1 {
                sim/draw_rect_ctl_test.v
               
        }
        #--------------------------------------------------------

        # add_files -fileset sim_1 {
        #         sim/testbench.v
        #         sim/tiff_writer.v
        # }
}

proc check_project {} {
        global project
        global build_path

        set pexist [file exist ${build_path}/${project}.xpr]
        puts "project exists : $pexist"
        if {$pexist == 0} {
                make_project 
        } else {
                open_project_f
        }
}

proc make_project {} {
        global project
        global target
        global build_path

        file mkdir ${build_path}
        create_project ${project} ${build_path} -part ${target} -force
}

proc open_project_f {} {
        global project
        global build_path

        open_project ${build_path}/${project}.xpr
}

proc make_bitstream {} {
        global top_module

        attach_rtl_files

        set_property top ${top_module} [current_fileset]
        update_compile_order -fileset sources_1
        update_compile_order -fileset sim_1

        reset_run   synth_1
        launch_runs synth_1 -jobs 8
        wait_on_run synth_1

        reset_run   impl_1
        launch_runs impl_1 -to_step write_bitstream -jobs 8
        wait_on_run impl_1
}

proc program_board {} {
        global bitstream_file

        open_hw
        connect_hw_server
        current_hw_target [get_hw_targets *]
        open_hw_target
        current_hw_device [lindex [get_hw_devices] 0]
        refresh_hw_device -update_hw_probes false [lindex [get_hw_devices] 0]

        set_property PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property FULL_PROBES.FILE {} [lindex [get_hw_devices] 0]
        set_property PROGRAM.FILE ${bitstream_file} [lindex [get_hw_devices] 0]

        program_hw_devices [lindex [get_hw_devices] 0]
        refresh_hw_device [lindex [get_hw_devices] 0]
}
proc clean {} {
        file delete -force .Xil
}

if {($argc != 1) || ([lindex $argv 0] ni {"simulation" "bitstream" "program" "run"})} {
        usage
}

if {[lindex $argv 0] == "program"} {
        program_board
        clean
        exit
} else {
        check_project
}

if {[lindex $argv 0] == "simulation"} {

        attach_sim_files

        set_property top ${top_sim_module} [current_fileset]
        update_compile_order -fileset sources_1
        update_compile_order -fileset sim_1

        launch_simulation
        start_gui
        # add_wave {{/draw_rect_ctl_test/my_draw_rect_ctl/xpos}} {{/draw_rect_ctl_test/my_draw_rect_ctl/ypos}} 
        # run all
} else { 
        if {[lindex $argv 0] == "run"} {
                make_bitstream 
                program_board
                clean
                exit
        } else {
                make_bitstream

                # Sekwencja pokazujaca i zapisujaca schemat rtl
                if {${generate_rtl} == 0 } {
                        clean
                        exit
                } else {
                        start_gui
                        synth_design -rtl -name rtl_1 
                        show_schematic [concat [get_cells] [get_ports]]
                        write_schematic -force -format pdf rtl_schematic.pdf -orientation landscape -scope visible
                        clean
                        exit
                }
        }
}
