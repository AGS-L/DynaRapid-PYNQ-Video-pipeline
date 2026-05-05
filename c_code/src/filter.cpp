/********************************************************************************************************************
 * Copyright (C) HES-SO University of Applied Sciences and Arts Western Switzerland
 * Engineering and Architecture Department
 * AGSL - Adaptive Heterogeneous Systems Lab
 * Created by the AGSL Team (andrea.guerrieri@hevs.ch)
 * All rights reserved.
 * See LICENSE file for full license information.
 ********************************************************************************************************************/
#include <stdlib.h>

#define AMOUNT_OF_TEST 1

// Passthrough Filter --------------------------------------------------------------------------

int filter(int pixel1) {
    return pixel1;
}

// End Passthrough Filter ------------------------------------------------------------------------

// Negative Filter --------------------------------------------------------------------------

// int filter(int pixel1) {
//     // Extract RGB components for pixel1 (assuming RGB is stored in the lower 24 bits)
//     int r1 = (pixel1 >> 16) & 0x000000FF; // Red component
//     int g1 = (pixel1 >> 8) & 0x000000FF;  // Green component
//     int b1 = pixel1 & 0x000000FF;         // Blue component

//     // Apply negative filter to each component
//     r1 = 255 - r1;
//     g1 = 255 - g1;
//     b1 = 255 - b1;

//     // Pack the inverted RGB components back into 32-bit integers
//     return (r1 << 16) | (g1 << 8) | b1;
// }

// End Negative Filter ------------------------------------------------------------------------

// Blue Filter --------------------------------------------------------------------------

// int filter(int pixel1) {
//     return pixel1 & 0x000000FF;
// }

// End Blue Filter ------------------------------------------------------------------------

// Green Filter --------------------------------------------------------------------------

// int filter(int pixel1) {
//     return pixel1 & 0x0000FF00;
// }

// End Green Filter ------------------------------------------------------------------------

// Red Filter --------------------------------------------------------------------------

// int filter(int pixel1) {
//     return pixel1 & 0x00FF0000;
// }

// End Red Filter ------------------------------------------------------------------------

int main(void) {
    int d_i[AMOUNT_OF_TEST][1000];
    int idx[AMOUNT_OF_TEST][1000];
    int out[AMOUNT_OF_TEST][1000];

    srand(13);
    for (int i = 0; i < AMOUNT_OF_TEST; ++i) {
        for (int j = 0; j < 1000; ++j) {
            d_i[0][j] = rand() % 100;
            idx[0][j] = rand() % 100;
        }
    }

    for (int i = 0; i < 1; ++i) {
        filter(d_i[0][0]);
    }
}
