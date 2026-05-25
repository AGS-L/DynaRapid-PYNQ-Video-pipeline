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

// 3x3 kernels ----------------------------------------------------------------------------------------------------------------------------

// Laplace Filter ---------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Inline grayscale conversion for each pixel
//     int gray_1_2 = (r_pixel_1_2 << 1) + (g_pixel_1_2 << 2) + b_pixel_1_2;
//     gray_1_2 >>= 3;

//     int gray_2_1 = (r_pixel_2_1 << 1) + (g_pixel_2_1 << 2) + b_pixel_2_1;
//     gray_2_1 >>= 3;

//     int gray_2_2 = (r_pixel_2_2 << 1) + (g_pixel_2_2 << 2) + b_pixel_2_2;
//     gray_2_2 >>= 3;

//     int gray_2_3 = (r_pixel_2_3 << 1) + (g_pixel_2_3 << 2) + b_pixel_2_3;
//     gray_2_3 >>= 3;

//     int gray_3_2 = (r_pixel_3_2 << 1) + (g_pixel_3_2 << 2) + b_pixel_3_2;
//     gray_3_2 >>= 3;

//     // Apply Laplacian kernel (edge detection)
//     int laplacian = (gray_2_2 << 2) - gray_2_3 - gray_3_2 - gray_1_2 - gray_2_1;
//     laplacian = laplacian & 0xFF;

//     // Return laplace result as RGB (for visualization)
//     return (laplacian << 16) | (laplacian << 8) | laplacian;
// }

// End Laplace Filter

// Emboss Filter ---------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Inline grayscale conversion for each pixel
//     int gray_1_1 = ((r_pixel_1_1 << 1) + (g_pixel_1_1 << 2) + b_pixel_1_1) >> 3;
//     int gray_1_2 = ((r_pixel_1_2 << 1) + (g_pixel_1_2 << 2) + b_pixel_1_2) >> 3;
//     int gray_2_1 = ((r_pixel_2_1 << 1) + (g_pixel_2_1 << 2) + b_pixel_2_1) >> 3;
//     int gray_2_2 = ((r_pixel_2_2 << 1) + (g_pixel_2_2 << 2) + b_pixel_2_2) >> 3;
//     int gray_2_3 = ((r_pixel_2_3 << 1) + (g_pixel_2_3 << 2) + b_pixel_2_3) >> 3;
//     int gray_3_2 = ((r_pixel_3_2 << 1) + (g_pixel_3_2 << 2) + b_pixel_3_2) >> 3;
//     int gray_3_3 = ((r_pixel_3_3 << 1) + (g_pixel_3_3 << 2) + b_pixel_3_3) >> 3;

//     // Apply Emboss kernel
//     int emboss = gray_2_2 + gray_2_3 + gray_3_2 + (gray_3_3 << 1) - (gray_1_1 << 1) - gray_1_2 - gray_2_1;
//     emboss = emboss & 0xFF;

//     // Return emboss result as RGB
//     return (emboss << 16) | (emboss << 8) | emboss;
// }

// End Emboss Filter

// Sharpen Filter ---------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Inline grayscale conversion for each pixel
//     int gray_1_2 = (r_pixel_1_2 << 1) + (g_pixel_1_2 << 2) + b_pixel_1_2;
//     int gray_2_1 = (r_pixel_2_1 << 1) + (g_pixel_2_1 << 2) + b_pixel_2_1;
//     int gray_2_2 = (r_pixel_2_2 << 1) + (g_pixel_2_2 << 2) + b_pixel_2_2;
//     int gray_2_3 = (r_pixel_2_3 << 1) + (g_pixel_2_3 << 2) + b_pixel_2_3;
//     int gray_3_2 = (r_pixel_3_2 << 1) + (g_pixel_3_2 << 2) + b_pixel_3_2;

//     // Apply Sharpen kernel
//     int sharpen = (5 * (gray_2_2 >> 3)) - ((gray_1_2 + gray_2_1 + gray_2_3 + gray_3_2) >> 3);
//     sharpen = sharpen & 0xFF;

//     // Return sharpen result as RGB
//     return (sharpen << 16) | (sharpen << 8) | sharpen;
// }

// End Sharpen Filter

// Gauss filter ---------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Apply Gaussian kernel to each channel
//     int r_result = r_pixel_1_1 + r_pixel_1_3 + r_pixel_3_1 + r_pixel_3_3;
//     r_result += ((r_pixel_1_2 + r_pixel_2_1 + r_pixel_2_3 + r_pixel_3_2) << 1);
//     r_result += (r_pixel_2_2 << 2);
//     r_result >>= 4;

//     int g_result = g_pixel_1_1 + g_pixel_1_3 + g_pixel_3_1 + g_pixel_3_3;
//     g_result += ((g_pixel_1_2 + g_pixel_2_1 + g_pixel_2_3 + g_pixel_3_2) << 1);
//     g_result += (g_pixel_2_2 << 2);
//     g_result >>= 4;

//     int b_result = b_pixel_1_1 + b_pixel_1_3 + b_pixel_3_1 + b_pixel_3_3;
//     b_result += ((b_pixel_1_2 + b_pixel_2_1 + b_pixel_2_3 + b_pixel_3_2) << 1);
//     b_result += (b_pixel_2_2 << 2);
//     b_result >>= 4;

//     // Recombine into RGB int
//     return (r_result << 16) | (g_result << 8) | b_result;
// }

// End gauss filter

// Single pixel filters ----------------------------------------------------------------------------------------------------------------------------

// Passthrough Filter --------------------------------------------------------------------------

int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
           int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
           int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
           int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
    // Simply put input on output
    return (r_pixel_2_2 << 16) | (g_pixel_2_2 << 8) | (b_pixel_2_2);
}

// End Passthrough Filter ------------------------------------------------------------------------

// Negative Filter --------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Apply negative filter to each component
//     int r1 = 255 - r_pixel_2_2;
//     int g1 = 255 - g_pixel_2_2;
//     int b1 = 255 - b_pixel_2_2;

//     // Pack the inverted RGB components back into 32-bit integers
//     return (r1 << 16) | (g1 << 8) | b1;
// }

// End Negative Filter ------------------------------------------------------------------------

// Blue Filter --------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     return b_pixel_2_2;
// }

// End Blue Filter ------------------------------------------------------------------------

// Green Filter --------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     return (g_pixel_2_2 << 8);
// }

// End Green Filter ------------------------------------------------------------------------

// Red Filter --------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     return (r_pixel_2_2 << 16);
// }

// End Red Filter ------------------------------------------------------------------------

// RGB2Gray Filter --------------------------------------------------------------------------

// int filter(int r_pixel_1_1, int g_pixel_1_1, int b_pixel_1_1, int r_pixel_1_2, int g_pixel_1_2, int b_pixel_1_2, int r_pixel_1_3, int g_pixel_1_3,
//            int b_pixel_1_3, int r_pixel_2_1, int g_pixel_2_1, int b_pixel_2_1, int r_pixel_2_2, int g_pixel_2_2, int b_pixel_2_2, int r_pixel_2_3,
//            int g_pixel_2_3, int b_pixel_2_3, int r_pixel_3_1, int g_pixel_3_1, int b_pixel_3_1, int r_pixel_3_2, int g_pixel_3_2, int b_pixel_3_2,
//            int r_pixel_3_3, int g_pixel_3_3, int b_pixel_3_3) {
//     // Apply RGB to gray
//     int gray = (77 * r_pixel_2_2 + 150 * g_pixel_2_2 + 29 * b_pixel_2_2);
//     gray >>= 8;

//     // Pack the RGB components back into 32-bit integers
//     int output = (gray << 16) | (gray << 8) | gray;

//     return output;
// }

// End RGB2Gray Filter ------------------------------------------------------------------------

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
        filter(d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0],
               d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0], d_i[0][0],
               d_i[0][0], d_i[0][0], d_i[0][0]);
    }
}
