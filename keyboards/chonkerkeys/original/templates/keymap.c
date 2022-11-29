#include QMK_KEYBOARD_H
#include "rgb_strands.h"
#include "layer_type.h"
#include "keyconfig.h"
__INCLUDES__

const uint32_t firmware_version = 1;

#define LAYER_COUNT __LAYER_COUNT__

const uint8_t layer_count = LAYER_COUNT;

const uint8_t layers[LAYER_COUNT] = {
__REPLACE_layer_types__
};

const uint64_t icons[MATRIX_ROWS][MATRIX_COLS] = __REPLACE_icons__;

const uint8_t PROGMEM key_size_and_ordinals[MATRIX_ROWS][MATRIX_COLS] = __REPLACE_size_ordinals__;

const uint32_t PROGMEM inactive_colors[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS] = {
__REPLACE_key_off_colors__
};

const uint32_t PROGMEM active_colors[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS] = {
__REPLACE_key_on_colors__
};

const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = {
__KEYMAP_GOES_HERE__
};

const uint16_t PROGMEM custom_actions[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS][3] = {
__CUSTOM_KEYS_GO_HERE__
};

const uint8_t PROGMEM default_layout = __DEFAULT_LAYOUT_GOES_HERE__;

const uint8_t PROGMEM key_anim[][MATRIX_ROWS][MATRIX_COLS] = {
__REPLACE_key_animations__
};
