## Constraints for CLK
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
## create_clock -name external_clock -period 10.00 [get_ports clk]
create_clock -period 10.000 [get_ports clk]
set_input_jitter [get_clocks -of_objects [get_ports clk]] 0.1
set_false_path -to [get_cells  -hier {*seq_reg*[0]} -filter {is_sequential}]
set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]


## Pmod Header JXADC
## Sch name = XA1_P
set_property PACKAGE_PIN J3 [get_ports {iadcp}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {iadcp}]
set_property PACKAGE_PIN K3 [get_ports {iadcn}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {iadcn}]

## Pmod Header JA
 set_property PACKAGE_PIN J2 [get_ports {AD2_SCL_JA}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SCL_JA}]
 set_property PACKAGE_PIN G2 [get_ports {AD2_SDA_JA}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SDA_JA}]

## Pmod Header JB
 set_property PACKAGE_PIN B15 [get_ports {AD2_SCL_JB}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SCL_JB}]
 set_property PACKAGE_PIN B16 [get_ports {AD2_SDA_JB}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SDA_JB}]

## Pmod Header JC
 set_property PACKAGE_PIN P17 [get_ports {AD2_SCL_JC}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SCL_JC}]
 set_property PACKAGE_PIN R18 [get_ports {AD2_SDA_JC}]						
 	set_property IOSTANDARD LVCMOS33 [get_ports {AD2_SDA_JC}]

## Uart
set_property PACKAGE_PIN A18 [get_ports {tx}]					
 	set_property IOSTANDARD LVCMOS33 [get_ports {tx}]

## Buttons
set_property PACKAGE_PIN U18 [get_ports {rst}]
set_property IOSTANDARD LVCMOS33 [get_ports {rst}]

## Switches
set_property PACKAGE_PIN V17 [get_ports {uart_enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {uart_enable}]

## Constraints for VS and HS
set_property PACKAGE_PIN R19 [get_ports {vs}]
set_property IOSTANDARD LVCMOS33 [get_ports {vs}]
set_property PACKAGE_PIN P19 [get_ports {hs}]
set_property IOSTANDARD LVCMOS33 [get_ports {hs}]

## Constraints for RED
set_property PACKAGE_PIN G19 [get_ports {r[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[0]}]
set_property PACKAGE_PIN H19 [get_ports {r[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[1]}]
set_property PACKAGE_PIN J19 [get_ports {r[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[2]}]
set_property PACKAGE_PIN N19 [get_ports {r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {r[3]}]

## Constraints for GRN
set_property PACKAGE_PIN J17 [get_ports {g[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[0]}]
set_property PACKAGE_PIN H17 [get_ports {g[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[1]}]
set_property PACKAGE_PIN G17 [get_ports {g[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[2]}]
set_property PACKAGE_PIN D17 [get_ports {g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {g[3]}]

## Constraints for BLU
set_property PACKAGE_PIN N18 [get_ports {b[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[0]}]
set_property PACKAGE_PIN L18 [get_ports {b[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[1]}]
set_property PACKAGE_PIN K18 [get_ports {b[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[2]}]
set_property PACKAGE_PIN J18 [get_ports {b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {b[3]}]

## Constraints for CFGBVS
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]


