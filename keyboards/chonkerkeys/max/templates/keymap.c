#include QMK_KEYBOARD_H
#include "rgb_strands.h"
__INCLUDES__

// Defines the keycodes used by our macros in process_record_user
enum custom_keycodes {
    CH_CUSTOM = SAFE_RANGE,
    // zoom
    CH_ZOOM_MUTE_TOGGLE,
    CH_ZOOM_VIDEO_TOGGLE,
    CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE,
    CH_ZOOM_RAISE_HAND_TOGGLE,
    CH_ZOOM_LEAVE_MEETING,
    // teams
    CH_TEAMS_MUTE_TOGGLE,
    CH_TEAMS_VIDEO_TOGGLE,
    CH_TEAMS_SHARE_SCREEN_START_STOP_TOGGLE,
    CH_TEAMS_RAISE_HAND_TOGGLE,
    CH_TEAMS_LEAVE_MEETING,
    // skype
    CH_SKYPE_MUTE_TOGGLE,
    CH_SKYPE_VIDEO_TOGGLE,
    CH_SKYPE_SHARE_SCREEN_START_STOP_TOGGLE,
    CH_SKYPE_RAISE_HAND_TOGGLE,
    CH_SKYPE_LEAVE_MEETING,
    // google meet
    CH_GOOGLE_MEET_MUTE_TOGGLE,
    CH_GOOGLE_MEET_VIDEO_TOGGLE,
    CH_GOOGLE_MEET_SHARE_SCREEN_START_STOP_TOGGLE,
    CH_GOOGLE_MEET_RAISE_HAND_TOGGLE,
    CH_GOOGLE_MEET_LEAVE_MEETING,
    // rest
    CH_VOLUME_UP,
    CH_VOLUME_DOWN,
    CH_MEDIA_NEXT,
    CH_MEDIA_PLAY_PAUSE,
    CH_SWITCH_WINDOW,
    CH_LAST_KEYCODE
};

#define KEY_MACROS_MAX_COUNT  3
#define KEYCODE_COUNT (CH_LAST_KEYCODE - CH_CUSTOM)

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
    { KC_AUDIO_VOL_UP, KC_NO, KC_NO }, 
    { KC_AUDIO_VOL_DOWN, KC_NO, KC_NO },
    { KC_MEDIA_NEXT_TRACK, KC_NO, KC_NO },
    { KC_MEDIA_PLAY_PAUSE, KC_NO, KC_NO },
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
    { KC_AUDIO_VOL_UP, KC_NO, KC_NO }, 
    { KC_AUDIO_VOL_DOWN, KC_NO, KC_NO },
    { KC_MEDIA_NEXT_TRACK, KC_NO, KC_NO },
    { KC_MEDIA_PLAY_PAUSE, KC_NO, KC_NO },
    { KC_LGUI, KC_TAB, KC_NO },
};

enum layer_type {
    CH_CUSTOM_WINDOWS,
    CH_CUSTOM_MACOS,
    CH_ZOOM_WINDOWS,
    CH_ZOOM_MACOS,
    CH_TEAMS_WINDOWS,
    CH_TEAMS_MACOS,
    CH_SKYPE_WINDOWS,
    CH_SKYPE_MACOS,
    CH_GOOGLE_MEET_WINDOWS,
    CH_GOOGLE_MEET_MACOS,
};

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

const uint8_t PROGMEM key_anim[][MATRIX_ROWS][MATRIX_COLS] = {
__REPLACE_key_animations__
};
