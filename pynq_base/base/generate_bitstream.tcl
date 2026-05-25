#######################################################################################################################
# Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
# Engineering and Architecture Department
# AGSL - Adaptive Heterogeneous Systems Lab
# Created by John Biselx (john.biselx@hevs.ch)
# All rights reserved.
# See LICENSE file for full license information.
#######################################################################################################################

# Determine the number of CPU cores
set num_processors 0

if {$tcl_platform(platform) eq "windows"} {
    if {[info exists ::env(NUMBER_OF_PROCESSORS)]} {
        set num_processors $::env(NUMBER_OF_PROCESSORS)
    }
} elseif {$tcl_platform(platform) eq "unix"} {
    if {[info exists env(TERM)]} {
        if {![catch {exec nproc} result]} {
            set num_processors [string trim $result]
        }
    }

    if {$num_processors == 0 && ![catch {set f [open "/proc/cpuinfo" r]}]} {
        set content [read $f]
        close $f
        set num_processors [regexp -all -line {^processor\s} $content]
    }
}

if {![string is integer -strict $num_processors] || $num_processors < 1} {
    set num_processors 2
}

set desired_threads [expr {$num_processors - 2}]

if {$desired_threads < 1} {
    set desired_threads 1
}

set_param general.maxThreads $desired_threads

# Actual script
set overlay_name "base"
set circuit_name [lindex $argv 0]
set output "./filters/${circuit_name}"
set circuit_dcp1 "${output}/filter_routed1.dcp"

# Check if design exists
if {![file exists $circuit_dcp1]} {
    puts "ERROR: Design 1 couldn't be found at '${circuit_dcp1}'"
    return -code error
}

set circuit_dcp2 "${output}/filter_routed2.dcp"

# Check if design exists
if {![file exists $circuit_dcp2]} {
    puts "ERROR: Design 2 couldn't be found at '${circuit_dcp2}'"
    return -code error
}

set shell_dcp ./dcp/shell.dcp

# Check if routed shell exist
if {![file exists $shell_dcp]} {
    puts "ERROR: Placed & routed shell couldn't be found at '${shell_dcp}'"
    return -code error
}

# Load shell
open_checkpoint $shell_dcp

set accel1_cell_name "base_i/mipi/dyna_accel_1/inst/dynarapid_accel1"
set accel2_cell_name "base_i/mipi/dyna_accel_1/inst/dynarapid_accel2"

# Load and insert dynarapid circuits
read_checkpoint -cell $accel1_cell_name $circuit_dcp1
read_checkpoint -cell $accel2_cell_name $circuit_dcp2

# Only routing is required between shell and circuits
set_param general.maxThreads 2
route_design
set_param general.maxThreads $desired_threads

# Save design before bitstream creation, for debugging purposes only
write_checkpoint -force "${output}/filter_bitstream.dcp"

# Write bitstream
write_bitstream -force "${output}/${overlay_name}.bit"

# Copy PYNQ files into folder
foreach file_name [glob -nocomplain -directory "./pynq_files/" *] {
    file copy -force $file_name $output
}
