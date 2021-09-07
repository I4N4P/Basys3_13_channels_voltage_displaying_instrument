# Basys3_13_channels_voltage_displaying_instrument
use in src catalog:

vivado -nojournal -nolog -mode tcl -source run.tcl -tclargs <prefix>

These are prefixes used in various situations:
        program             Starts vivado looks for a project and progrms FPGA
        simulation          Starts vivado looks for a project and run simulation
        bitstream           Starts vivado looks for a project and run generate bitstream
        run                 Starts vivado looks for a project and run generate bitstream and progrms FPGA
 
