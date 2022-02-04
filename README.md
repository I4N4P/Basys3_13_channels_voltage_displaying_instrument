# Basys3_13_channels_voltage_displaying_instrument
It is a project that was created for the AGH University of Science and Technology so that integrated circuits could be tested in a simpler and faster way

# In order to run vivado from console
open src catalog in powershell and put:

vivado -nojournal -nolog -mode tcl -source run.tcl -tclargs "prefix"

These are prefixes used in various situations:
        
        program             Starts vivado searchs for a project and programs FPGA
        simulation          Starts vivado searchs for a project and run simulation
        bitstream           Starts vivado searchs for a project and run generate bitstream
        run                 Starts vivado searchs for a project and run generate bitstream and programs FPGA
 
