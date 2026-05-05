#######################################################################################################################
# Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
# Engineering and Architecture Department
# AGSL - Adaptive Heterogeneous Systems Lab
# Created by the AGSL Team (andrea.guerrieri@hevs.ch)
# All rights reserved.
# See LICENSE file for full license information.
#######################################################################################################################

set_project .
set_top_file filter.cpp
synthesize -use-lsq=false -simple-buffers=true -verbose
write_hdl

exit
