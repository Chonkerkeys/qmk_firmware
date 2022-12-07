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
        case CH_CUSTOM_MACOS:
            c.r = 255; c.g = 255; c.b = 255;
            return c;
            break;
        case CH_ZOOM_WINDOWS:
        case CH_ZOOM_MACOS:
            c.r = 0; c.g = 0; c.b = 255;
            return c;
            break;
        case CH_TEAMS_WINDOWS:
        case CH_TEAMS_MACOS:
            c.r = 99; c.g = 112; c.b = 255;
            return c;
            break;
        case CH_SKYPE_WINDOWS:
        case CH_SKYPE_MACOS:
            c.r = 0; c.g = 255; c.b = 255;
            return c;
            break;
        case CH_GOOGLE_MEET_WINDOWS:
        case CH_GOOGLE_MEET_MACOS:
            c.r = 0; c.g = 255; c.b = 0;
            return c;
            break;
        default:
            c.r = 255; c.g = 255; c.b = 255;
            return c;
            break;
    }
}
