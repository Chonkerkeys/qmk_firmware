#pragma once

#include "quantum.h"
#include "layer_type.h"

struct flash_color {
    int r, g, b;
};

struct flash_color get_layer_type_color(int layer_type) {
    struct flash_color c;
    switch (layer_type) {
        case CH_CUSTOM_WINDOWS:
            c.r = 255; c.g = 255; c.b = 255;
            return c;
            break;
        default:
            c.r = 255; c.g = 255; c.b = 255;
            return c;
            break;
    }
}
