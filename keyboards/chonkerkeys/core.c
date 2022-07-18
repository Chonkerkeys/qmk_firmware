#include "quantum.h"
#include "keyconfig.h"
#include "rgb_strands/rgb_strands.h"
#include <math.h>

#define KEY_MACROS_MAX_COUNT  3

extern const uint8_t layer_count;
extern const uint32_t firmware_version;
extern const uint8_t layers[];
extern const uint64_t icons[MATRIX_ROWS][MATRIX_COLS];
extern const uint8_t PROGMEM key_size_and_ordinals[MATRIX_ROWS][MATRIX_COLS];
extern const uint32_t PROGMEM inactive_colors[][MATRIX_ROWS][MATRIX_COLS];
extern const uint32_t PROGMEM active_colors[][MATRIX_ROWS][MATRIX_COLS];
extern const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS];
extern const uint16_t PROGMEM custom_actions[][MATRIX_ROWS][MATRIX_COLS][KEY_MACROS_MAX_COUNT];
extern const uint8_t PROGMEM key_anim[][MATRIX_ROWS][MATRIX_COLS];

// hold vars, could use some refinement
bool hold_key_held = false;
bool hold_key_activated = false;
static uint16_t hold_timer;
uint8_t hold_vars[3];
uint16_t const* hold_macros;
uint8_t hold_original_animation;
uint8_t hold_key_index;


#define KEYCODE_COUNT (CH_LAST_KEYCODE - CH_CUSTOM)

const bool to_hold[KEYCODE_COUNT] = { // align indices with key_configs so only each leave meeting is hold-able
    0,
    0,0,0,0,1, //z w
    0,0,0,0,1, //z m
    0,0,0,0,1, //t w
    0,0,0,0,1, //t m
    0,0,0,0,1, //s w
    0,0,0,0,1, //s m
    0,0,0,0,1, //m w
    0,0,0,0,1, //m m
    0,0,0,0,1, //f w
    0,0,0,0,1, //f m
    0,0,
    0,0,0,0,
};

const uint16_t key_configs[KEYCODE_COUNT][KEY_MACROS_MAX_COUNT] = {
    { KC_NO, KC_NO, KC_NO },
    // zoom win
    { KC_LALT, KC_A, KC_NO },
    { KC_LALT, KC_V, KC_NO },
    { KC_LALT, KC_S, KC_NO },
    { KC_LALT, KC_Y, KC_NO },
    { KC_LALT, KC_Q, KC_NO },
    // zoom mac
    { KC_LGUI, KC_LSHIFT, KC_A },
    { KC_LGUI, KC_LSHIFT, KC_V },
    { KC_LGUI, KC_LSHIFT, KC_S },
    { KC_LALT, KC_Y, KC_NO },
    { KC_LGUI, KC_W, KC_NO },
    // teams win
    { KC_LCTRL, KC_LSHIFT, KC_M },
    { KC_LCTRL, KC_LSHIFT, KC_O },
    { KC_LCTRL, KC_LSHIFT, KC_E },
    { KC_LCTRL, KC_LSHIFT, KC_K },
    { KC_LCTRL, KC_LSHIFT, KC_H },
    // teams mac
    { KC_LSHIFT, KC_LGUI, KC_M },
    { KC_LSHIFT, KC_LGUI, KC_O },
    { KC_LSHIFT, KC_LGUI, KC_E },
    { KC_LSHIFT, KC_LGUI, KC_K },
    { KC_LSHIFT, KC_LGUI, KC_H },
    // skype win
    { KC_LCTRL, KC_M, KC_NO },
    { KC_LCTRL, KC_LSHIFT, KC_K },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LSHIFT, KC_H },
    // skype mac
    { KC_LSHIFT, KC_LGUI, KC_M },
    { KC_LSHIFT, KC_LGUI, KC_K },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LSHIFT, KC_LGUI, KC_H },
    // google meet win
    { KC_LCTRL, KC_D, KC_NO },
    { KC_LCTRL, KC_E, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LALT, KC_H },
    { KC_LALT, KC_F4, KC_NO },
    // google meet mac
    { KC_LGUI, KC_D, KC_NO },
    { KC_LGUI, KC_E, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LCTRL, KC_LGUI, KC_H },
    { KC_NO, KC_NO, KC_NO },
    // facetime win
    { KC_M, KC_NO, KC_NO },
    { KC_C, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_L, KC_NO, KC_NO },
    // facetime mac
    { KC_LGUI, KC_LSHIFT, KC_M },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_NO, KC_NO, KC_NO },
    { KC_LGUI, KC_W, KC_NO },
    // switch window
    { KC_LALT, KC_TAB, KC_NO },
    { KC_LGUI, KC_TAB, KC_NO },
    // rest
    { KC_AUDIO_VOL_UP, KC_NO, KC_NO },
    { KC_AUDIO_VOL_DOWN, KC_NO, KC_NO },
    { KC_MEDIA_NEXT_TRACK, KC_NO, KC_NO },
    { KC_MEDIA_PLAY_PAUSE, KC_NO, KC_NO },
};

bool is_connected = false;
bool is_heart_beat_received = false;
deferred_token heart_beat_checker_token;

uint8_t get_layer_count() {
    return layer_count;
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

uint8_t get_current_layer_index(void) {
    uint8_t current_layer = 0;
    for (uint8_t i = 0; i < layer_count; ++i) {
        if (IS_LAYER_ON(i)) {
            current_layer = i;
            break;
        }
    }
    return current_layer;
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

void start_key_anim(uint8_t x, uint8_t y, uint8_t anim, uint8_t r, uint8_t g, uint8_t b) {
    from_app_to_firmware_origin(&x, &y);
    uint8_t rgb_strand = from_x_y_to_index(x, y);
    const rgb_strand_anim_config_t *dcfg = get_default_rgb_strand_anim_config(anim);
    rgb_strand_anim_config_t cfg;
    memcpy(&cfg, dcfg, sizeof(rgb_strand_anim_config_t));
    if (anim == RGB_STRAND_EFFECT_STATIC) {
        set_rgb_strand_config_color(&cfg, r, g, b);
    }
    rgb_strand_animation_start(rgb_strand, anim,
        &cfg,
        RGB_STRAND_ANIM_STATE_STEADY);
    if (anim != RGB_STRAND_EFFECT_STATIC) {
        rgb_strand_animation_set_state(rgb_strand, RGB_STRAND_ANIM_STATE_START);
    }
}

void flash_all_light(void) {
    for (uint16_t y = 0; y < MATRIX_ROWS; ++y) {
        for (uint16_t x = 0; x < MATRIX_COLS; ++x) {
            // Animation ignore color, set all of them to 0
            start_key_anim(x, y, RGB_STRAND_EFFECT_MOMENTARY, 0, 0, 0);
        }
    }
}

void switch_layer(uint16_t index) {
    layer_clear();
    layer_on(index);
    flash_all_light();
}

void switch_to_next_layer(void) {
    uint8_t current_layer = get_current_layer_index();
    // Assume layer_count is > 0
    // Checking before addition to avoid overflow (although it's not likely...we only support
    // max 8 layers anyways)
    uint8_t next_layer = current_layer == layer_count - 1 ? 0 : current_layer + 1;
    switch_layer(next_layer);
}

void virtser_recv(uint8_t c) {
    process_protocol(c);
    is_heart_beat_received = true;
}

void send_protocol(uint8_t c) {
    virtser_send(c);
}

void on_connected() {
    is_connected = true;
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

bool is_common_action(uint16_t keycode) {
    return (keycode >= CH_VOLUME_UP) || (keycode < SAFE_RANGE) || (keycode == CH_CUSTOM);
}

const uint32_t connectionReadTimeoutMs = 5000;
const uint32_t repeatDurationMs = 10000;  // connectionReadTimeoutMs * 2, Nyquist theorem
uint32_t check_heart_beat(uint32_t trigger_time, void *cb_arg) {
    if (is_connected) {
        if (!is_heart_beat_received) {
            flash_all_light();
            is_connected = false;
        } else {
            is_heart_beat_received = false;
        }
    }
    return repeatDurationMs;
}

void keyboard_post_init_user(void) {
    heart_beat_checker_token = defer_exec(repeatDurationMs, check_heart_beat, NULL);
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
                if (is_connected) {
                    switch_layer_combo_down();
                } else {
                    switch_to_next_layer();
                }
                return false;
            }
        }
        is_either_pressed = record->event.pressed;
    }

    uint8_t row = record->event.key.row;
    uint8_t col = record->event.key.col;
    uint8_t key_strand = from_x_y_to_index(col, row);
    // It's not trivial to handle media keys and volume up/down in macOS as the virtual key codes
    // for these actions are non-existent. They updated the virtual key code of the os in recent releases
    // to stick to the usb spec but we might want to work down level. So, the simplest solution is to let
    // QMK send these "common actions" directly.
    const bool should_qmk_handle = is_common_action(keycode);
    if (is_connected && !should_qmk_handle) {
        if (record->event.pressed) {
            key_down(get_current_layer_index(), app_x, app_y);
        }
        else { // release
            // Enable when agent is ready
            //key_up(get_current_layer_index(), app_x, app_y);
        }
    }
    else { // handle in hardware like normal keyboards
        uint8_t current_layer_index = get_current_layer_index();
        if (keycode >= CH_CUSTOM && keycode < CH_LAST_KEYCODE) {
            if (keycode == CH_CUSTOM) {
                if (record->event.pressed) {
                    for (uint32_t i = 0; i < KEY_MACROS_MAX_COUNT; ++i) {
                        uint16_t code = get_key_custom_action(current_layer_index, col, row, i);
                        if (code == KC_NO) continue;
                        register_code(code);
                    }
                }
                else {
                    for (int32_t i = KEY_MACROS_MAX_COUNT - 1; i >= 0; --i) {
                        uint16_t code = get_key_custom_action(current_layer_index, col, row, i);
                        if (code == KC_NO) continue;
                        unregister_code(code);
                    }
                }
            }
            else {  // CH_ defined key codes
                uint16_t key_config_index = keycode - CH_CUSTOM;
                uint16_t const* key_macros = key_configs[key_config_index];
                if (record->event.pressed) {
                    if (!to_hold[key_config_index]) { //just register as normal keypress
                        for (uint32_t i = 0; i < KEY_MACROS_MAX_COUNT; ++i) {
                            uint16_t code = key_macros[i];
                            if (code == KC_NO) continue;
                            register_code(code);
                        }
                    } else { // start hold timer and save variables
                        hold_key_held = true; hold_key_activated = false;
                        hold_timer = timer_read();
                        hold_key_index = key_config_index;
                        hold_macros = key_macros;
                        hold_vars[0] = current_layer_index; hold_vars[1] = col; hold_vars[2] = row;
                        hold_original_animation = pgm_read_byte(&key_anim[current_layer_index][row][col]);
                    }
                }
                else { // release
                    hold_key_held = false;
                    for (int32_t i = KEY_MACROS_MAX_COUNT - 1; i >= 0; --i) {
                        uint16_t code = key_macros[i];
                        if (code == KC_NO) continue;
                        unregister_code(code);
                    }
                }
            }
        }
        else {  // regular QMK keycodes
            if (record->event.pressed) {
                register_code(keycode);
            }
            else {
                unregister_code(keycode);
            }
        }

        // Process animation
        if (record->event.pressed) {
            // start animation
            if (!to_hold[hold_key_index]) {
                uint8_t anim = pgm_read_byte(&key_anim[current_layer_index][row][col]);
                const rgb_strand_anim_config_t *dcfg = get_default_rgb_strand_anim_config(anim);
                rgb_strand_anim_config_t cfg;
                memcpy(&cfg, dcfg, sizeof(rgb_strand_anim_config_t));
                rgb_strand_animation_start(key_strand, anim, &cfg, RGB_STRAND_ANIM_STATE_STEADY);
            } else {
                uint8_t hold_anim = RGB_STRAND_EFFECT_BLINKY;
                const rgb_strand_anim_config_t *hold_dcfg = get_default_rgb_strand_anim_config(hold_anim);
                rgb_strand_anim_config_t hold_cfg;
                memcpy(&hold_cfg, hold_dcfg, sizeof(rgb_strand_anim_config_t));
                // set custom blink parameters
                hold_cfg.period = 500;
                hold_cfg.color.h = 0; hold_cfg.color.s = 0; hold_cfg.color.v = 100;
                rgb_strand_animation_start(key_strand, hold_anim, &hold_cfg, RGB_STRAND_ANIM_STATE_START);
            }

        }
        else {  // released
            // end animation
            if (!to_hold[hold_key_index]) {
                rgb_strand_animation_set_state(key_strand, RGB_STRAND_ANIM_STATE_START);
            } else if (!hold_key_activated) {
                rgb_strand_animation_set_state(key_strand, RGB_STRAND_ANIM_STATE_OFF);
            }
            hold_key_index = 0;
        }
    }
    return false;
}

void matrix_scan_kb(void) {
        if (hold_key_held && (timer_elapsed(hold_timer) > 1500) && !hold_key_activated) { // if still held after time, activate key
        // register each code from config in sequence
        for (uint32_t i = 0; i < KEY_MACROS_MAX_COUNT; ++i) {
            uint16_t code = hold_macros[i];
            if (code == KC_NO) continue;
            register_code(code);
        }

        // start default key animation
        uint8_t key_strand = from_x_y_to_index(hold_vars[1], hold_vars[2]);
        const rgb_strand_anim_config_t *hold_dcfg = get_default_rgb_strand_anim_config(hold_original_animation);
        rgb_strand_anim_config_t hold_cfg;
        memcpy(&hold_cfg, hold_dcfg, sizeof(rgb_strand_anim_config_t));
        rgb_strand_animation_start(key_strand, hold_original_animation, &hold_cfg, RGB_STRAND_ANIM_STATE_START);

        // deregister each code from config in sequence
        for (int32_t i = KEY_MACROS_MAX_COUNT - 1; i >= 0; --i) {
            uint16_t code = hold_macros[i];
            if (code == KC_NO) continue;
            unregister_code(code);
        }
        hold_key_activated = true;
    }
}

layer_state_t layer_state_set_user(layer_state_t state) {
  for (uint32_t i = 0; i < layer_count; ++i) {
      if (IS_LAYER_ON_STATE(state, i)) {
          layer_switched(i);
          break;
      }
  }
  return state;
}
