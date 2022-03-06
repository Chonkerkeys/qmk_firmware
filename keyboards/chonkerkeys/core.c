#include "quantum.h"
#include "keyconfig.h"
#include "rgb_strands/rgb_strands.h"
#include <math.h>

// This file is not meant to be compiled directly, but included in keymap.c
// LAYER_COUNT, keymaps etc are defined in config.c

#define LAYER_COUNT 2
extern const uint32_t firmware_version;
extern const uint8_t layers[LAYER_COUNT];
extern const uint64_t icons[MATRIX_ROWS][MATRIX_COLS];
extern const uint8_t key_size_and_ordinals[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS];
extern const uint32_t PROGMEM inactive_colors[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS];
extern const uint32_t PROGMEM active_colors[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS];
extern const uint16_t PROGMEM keymaps[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS];
extern const uint16_t PROGMEM custom_actions[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS][3];
extern const rgb_strands_anim_t key_anim[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS];

bool is_connected = false;

const uint16_t windows_configs[KEYCODE_COUNT][KEY_MACROS_MAX_COUNT] = {
    { KC_NO, KC_NO, KC_NO },
    // zoom
    { KC_LALT, KC_A, KC_NO },
    { KC_LALT, KC_V, KC_NO },
    { KC_LALT, KC_S, KC_NO },
    { KC_LALT, KC_Y, KC_NO },
    { KC_LALT, KC_Q, KC_NO },
    // teams
    { KC_LCTRL, KC_LSHIFT, KC_M },
    { KC_LCTRL, KC_LSHIFT, KC_O },
    { KC_LCTRL, KC_LSHIFT, KC_E },
    { KC_LCTRL, KC_LSHIFT, KC_K },
    { KC_LCTRL, KC_LSHIFT, KC_H },
    // skype
    { KC_LCTRL, KC_M, KC_NO },
    { KC_LCTRL, KC_LSHIFT, KC_K },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LSHIFT, KC_H },
    // google meet
    { KC_LCTRL, KC_D, KC_NO },
    { KC_LCTRL, KC_E, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LALT, KC_H },
    { KC_LALT, KC_F4, KC_NO },
    // rest
    { KC_LALT, KC_TAB, KC_NO },
};

const uint16_t macos_configs[KEYCODE_COUNT][KEY_MACROS_MAX_COUNT] = {
    { KC_NO, KC_NO, KC_NO },
    // zoom
    { KC_LGUI, KC_LSHIFT, KC_A },
    { KC_LGUI, KC_LSHIFT, KC_V },
    { KC_LGUI, KC_LSHIFT, KC_S },
    { KC_LALT, KC_Y, KC_NO },
    { KC_LGUI, KC_W, KC_NO },
    // teams
    { KC_LSHIFT, KC_LGUI, KC_M },
    { KC_LCTRL, KC_LGUI, KC_O },
    { KC_LCTRL, KC_LGUI, KC_E },
    { KC_LCTRL, KC_LGUI, KC_K },
    { KC_LCTRL, KC_LGUI, KC_H },
    // skype
    { KC_LSHIFT, KC_LGUI, KC_M },
    { KC_LSHIFT, KC_LGUI, KC_K },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LSHIFT, KC_LGUI, KC_H },
    // google meet
    { KC_LGUI, KC_D, KC_NO },
    { KC_LGUI, KC_E, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LGUI, KC_H },
    { KC_NO, KC_NO, KC_NO },
    // rest
    { KC_LGUI, KC_TAB, KC_NO },
};

uint8_t get_layer_count() {
    return LAYER_COUNT;
}

uint8_t get_layer_type(uint8_t index) {
    return layers[index];
}

uint8_t get_key_size_and_ordinal(uint8_t layer, uint8_t x, uint8_t y) {
    return pgm_read_byte(&key_size_and_ordinals[y][x]);
}

uint8_t get_key_action_type(uint8_t layer, uint8_t x, uint8_t y) {
    return pgm_read_word(&keymaps[layer][y][x]) - CH_CUSTOM;
}

uint64_t get_key_icon(uint8_t layer, uint8_t x, uint8_t y) {
    return icons[y][x];
}

uint32_t get_key_color(uint32_t const* color) {
    return pgm_read_dword(color);
}

uint32_t get_key_inactive_color(uint8_t layer, uint8_t x, uint8_t y) {
    return get_key_color(&inactive_colors[layer][y][x]);
}

uint32_t get_key_active_color(uint8_t layer, uint8_t x, uint8_t y) {
    return get_key_color(&active_colors[layer][y][x]);
}

uint8_t get_key_custom_action(uint8_t layer, uint8_t x, uint8_t y, uint8_t index) {
    // To stick to QMK keycode type, custom_actions uses uint16_t.
    // But we know the basic key code aren't using the higer byte, and custom actions
    // shouldn't use non-basic key code anyways, so just convert to uint8_t.
    return (uint8_t) pgm_read_word(&custom_actions[layer][y][x][index]);
}

bool is_windows(uint8_t layer) {
    return layer % 2 == 0;
}

uint16_t get_current_layer(void) {
    uint16_t current_layer = 0;
    for (uint16_t i = 0; i < LAYER_COUNT; ++i) {
        if (IS_LAYER_ON(i)) {
            current_layer = i;
            break;
        }
    }
    return current_layer;
}

void switch_layer(uint16_t index) {
    layer_clear();
    layer_on(index);
}

void switch_to_next_layer(void) {
    uint16_t current_layer = get_current_layer();
    uint16_t next_layer = current_layer + 1;
    if (next_layer >= LAYER_COUNT) {
        next_layer = 0;
    }
    switch_layer(next_layer);
}

void virtser_recv(uint8_t c) {
    process_protocol(c);
}

void send_protocol(uint8_t c) {
    virtser_send(c);
}

void on_connected() {
    is_connected = true;
}

uint8_t from_x_y_to_index(uint8_t x, uint8_t y) {
    return (y * MATRIX_COLS) + x;
}

void from_app_to_firmware_origin(uint8_t *x, uint8_t *y) {
    // TODO: Flip x as well once w use top-right as origin
    *x = MATRIX_COLS - 1 - *x;
    *y = MATRIX_ROWS - 1 - *y;
}

void from_firmware_to_app_origin(uint8_t *x, uint8_t *y) {
    // app to firmware is the reverse op of itself, so just call it once more
    from_app_to_firmware_origin(x, y);
}

float ch_max(float a, float b, float c) {
   return ((a > b)? (a > c ? a : c) : (b > c ? b : c));
}

float ch_min(float a, float b, float c) {
   return ((a < b)? (a < c ? a : c) : (b < c ? b : c));
}

int rgb_to_hsv(float r, float g, float b, float *h, float *s, float *v) {
   // R, G, B values are divided by 255
   // to change the range from 0..255 to 0..1:
   float inv255 = 1.0f / 255.0f;
   r *= inv255;
   g *= inv255;
   b *= inv255;
   float cmax = ch_max(r, g, b); // maximum of r, g, b
   float cmin = ch_min(r, g, b); // minimum of r, g, b
   float diff = cmax-cmin; // diff of cmax and cmin.
   if (cmax == cmin)
      *h = 0;
   else if (cmax == r)
      *h = fmod((60 * ((g - b) / diff) + 360), 360.0);
   else if (cmax == g)
      *h = fmod((60 * ((b - r) / diff) + 120), 360.0);
   else if (cmax == b)
      *h = fmod((60 * ((r - g) / diff) + 240), 360.0);
   // if cmax equal zero
      if (cmax == 0)
         *s = 0;
      else
         *s = (diff / cmax) * 100;
   // compute v
   *v = cmax * 100;
   return 0;
}

void set_rgb_strand_config_color(rgb_strand_anim_config_t* cfg, uint8_t r, uint8_t g, uint8_t b) {
    float h;
    float s;
    float v;
    rgb_to_hsv(r, g, b, &h, &s, &v);
    cfg->color.h = (uint8_t) (h / 360.0f * 255.0f);
    cfg->color.s = (uint8_t) (s / 100.0f * 255.0f);
    cfg->color.v = (uint8_t) (v / 100.0f * 255.0f);
}

void start_key_anim(uint8_t x, uint8_t y, rgb_strands_anim_t anim, uint8_t r, uint8_t g, uint8_t b) {
    from_app_to_firmware_origin(&x, &y);
    uint8_t rgb_strand = from_x_y_to_index(x, y);
    const rgb_strand_anim_config_t *dcfg = get_default_rgb_strand_anim_config(anim);
    rgb_strand_anim_config_t cfg;
    memcpy(&cfg, dcfg, sizeof(rgb_strand_anim_config_t));
    set_rgb_strand_config_color(&cfg, r, g, b);
    rgb_strand_animation_start(rgb_strand, anim,
        &cfg,
        RGB_STRAND_ANIM_STATE_STEADY);
    if (anim != RGB_STRAND_EFFECT_STATIC) {
        rgb_strand_animation_set_state(rgb_strand, RGB_STRAND_ANIM_STATE_START);
    }
}

void set_led_off(uint8_t key_x, uint8_t key_y) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_STATIC, 0, 0, 0);
}

void set_led_steady(uint8_t key_x, uint8_t key_y, uint8_t r, uint8_t g, uint8_t b) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_STATIC, r, g, b);
}

void set_led_blink(uint8_t key_x, uint8_t key_y, uint8_t r, uint8_t g, uint8_t b, uint8_t frequency_tbc) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_BLINKY, r, g, b);
}

void set_led_like(uint8_t key_x, uint8_t key_y, uint8_t r, uint8_t g, uint8_t b) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_LIKE, r, g, b);
}

void set_led_leave_meeting(uint8_t key_x, uint8_t key_y, uint8_t r, uint8_t g, uint8_t b) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_DRAINSWIRL, r, g, b);
}

void set_led_momentary(uint8_t key_x, uint8_t key_y, uint8_t r, uint8_t g, uint8_t b, uint32_t duration_ms) {
    start_key_anim(key_x, key_y, RGB_STRAND_EFFECT_MOMENTARY, r, g, b);
}

void on_switch_layer(uint8_t index) {
    switch_layer(index);
}

bool process_record_user(uint16_t keycode, keyrecord_t *record) {
    static bool is_either_pressed = false;
    uint8_t app_x = record->event.key.col;
    uint8_t app_y = record->event.key.row;
    // QMK uses top left as origin, but the app uses KU origin (i.e. bottom left) for switching layer
    from_firmware_to_app_origin(&app_x, &app_y);
    // Requirement is, use the bottom row and left-most keys as key-switching hotkey
    if (app_y == 0 && app_x <= 1) {
        if (record->event.pressed) {   
            if (is_either_pressed) {
                switch_to_next_layer();
                return false;
            }
        }
        is_either_pressed = record->event.pressed;
    }

    uint8_t row = record->event.key.row;
    uint8_t col = record->event.key.col;
    uint8_t key_strand = from_x_y_to_index(col, row);
    if (record->event.pressed) {
        if (is_connected) {
            key_down(get_current_layer(), app_x, app_y);
        } else {
            if (keycode > CH_CUSTOM && keycode < CH_LAST_KEYCODE) {
                uint16_t key_config_index = keycode - CH_CUSTOM;
                uint16_t current_layer = get_current_layer();
                uint16_t const* keyMacros = is_windows(current_layer) ? windows_configs[key_config_index] : macos_configs[key_config_index];
                for (uint32_t i = 0; i < KEY_MACROS_MAX_COUNT; ++i) {
                    uint16_t code = keyMacros[i];
                    if (code == KC_NO) continue;
                    register_code(code);
                }
                for (int32_t i = KEY_MACROS_MAX_COUNT - 1; i >= 0; --i) {
                    uint16_t code = keyMacros[i];
                    if (code == KC_NO) continue;
                    unregister_code(code);
                }
            } else {
                register_code(keycode);
                unregister_code(keycode);
            }
            uint8_t current_layer = get_current_layer();
            rgb_strands_anim_t anim = pgm_read_byte(&key_anim[current_layer][row][col]);
            const rgb_strand_anim_config_t *dcfg = get_default_rgb_strand_anim_config(anim);
            rgb_strand_anim_config_t cfg;
            memcpy(&cfg, dcfg, sizeof(rgb_strand_anim_config_t));
            uint32_t color = get_key_active_color(current_layer, col, row);
            uint8_t r = (uint8_t) (color >> 24) && 0xff;
            uint8_t g = (uint8_t) (color >> 16) && 0xff;
            uint8_t b = (uint8_t) (color >> 8) && 0xff;
            set_rgb_strand_config_color(&cfg, r, g, b);
            rgb_strand_animation_start(key_strand, anim,
                    &cfg,
                    RGB_STRAND_ANIM_STATE_STEADY);
        }
    } else { // released
        rgb_strand_animation_set_state(key_strand, RGB_STRAND_ANIM_STATE_START);
    }
    return false;
}

layer_state_t layer_state_set_user(layer_state_t state) {
  for (uint32_t i = 0; i < LAYER_COUNT; ++i) {
      if (IS_LAYER_ON_STATE(state, i)) {
          layer_switched(i);
          break;
      }
  }
  return state;
}
