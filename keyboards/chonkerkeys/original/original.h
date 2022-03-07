/* Copyright 2021 Chonkerkeys
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

#pragma once

#include "quantum.h"

/* ChonkerKeys top right is row 0 column 0. Key column and row number extends down and to the left
 * from the USB-C connector.
 */
#define LAYOUT( \
    k03, k02, k01, k00, \
    k13, k12, k11, k10, \
) { \
    { k00, k01, k02, k03 }, \
    { k10, k11, k12, k13 }, \
}

#define LAYOUT_CUSTOM_KEYS( \
    k03_0, k03_1, k03_2,  k02_0, k02_1, k02_2,  k01_0, k01_1, k01_2,  k00_0, k00_1, k00_2, \
    k13_0, k13_1, k13_2,  k12_0, k12_1, k12_2,  k11_0, k11_1, k11_2,  k10_0, k10_1, k10_2, \
) { \
    { {k00_0, k00_1, k00_2},  {k01_0, k01_1, k01_2},  {k02_0, k02_1, k02_2},  {k03_0, k03_1, k03_2} }, \
    { {k10_0, k10_1, k10_2},  {k11_0, k11_1, k11_2},  {k12_0, k12_1, k12_2},  {k13_0, k13_1, k13_2} }, \
}
