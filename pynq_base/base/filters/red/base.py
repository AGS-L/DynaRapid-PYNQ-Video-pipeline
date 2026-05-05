# Copyright (C) 2025 Advanced Micro Devices, Inc.
# SPDX-License-Identifier: BSD-3-Clause

import pynq
from pynq.lib.video.clocks import *
from pynq.lib import AxiGPIO

class rgbleds_class(AxiGPIO):
    def write(self, value):
        super().write(0, value)

class BaseOverlay(pynq.Overlay):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
    def download(self):
        super().download()

class rgbleds_class(AxiGPIO):
    def write(self, value):
        super().write(0, value)
    def off(self):
        super().write(0,0)
    def on(self):
        super().write(0,0x0f)
