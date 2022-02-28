# Firmware Code Generator for QMK

Since QMK currently doesn't support changing key layout etc via EPPROM, we need to flash the firmware everytime the layout changes. The firmware obviously is a binaries that needs to be compiled from source - and if we need to update the firmware we need to update the source. This is the code generator that is responsble for generating the necessary configuration in plain c.

## Getting Started

Run
```
gen/gen-config.sh gen-original
```
at `keyboards/chonkerkeys` to generate `config.c`. 

### Args

`gen-original` to generate the default firmware for original, `gen-max` for max, and `gen` for custom configuration. `gen` requires two more additional args: `FIRMWARE_VERSION` and `FIRMWARE_CONFIG`, specified via env var.

To facilitate debugging, 2 more default variants for `gen-original` and `gen-max` are also available: `gen-original-all` and `gen-max-all`. These `-all` variants include all layers by default.

### Specifying output path

```
export FIRMWARE_CONFIG_OUTPUT=original/keymaps/default/config.c
gen/gen-config.sh gen-original
```

## JSON schema of FIRMWARE_CONFIG

**NOTE**: Do NOT use QMK's online configuration's schema as chonkerkeys has custom data.

### Schema of config

```
{
	"name": <name of keyboard, e.g. Chonkerkeys Original>,
    "layers": <array of layer_type (in layer_type.h)>,
	"sizeOrdinals": <nested array of the size + ordinal (specified below) of each key, in each row, in each layer>,
	"keymaps": <nested array of the custom_keycodes (in keyconfig.h) of each key, in each row, in each layer>,
	"customActions": <nested array of QMK's key code, e.g. KC_A for each action of each key, in each row, in each layer>,
	"icons": <nested array of the icon of each key, with unsigned 64 bit number in string to avoid precision issues>,
	"keyOffColors": <nested array of ARGB color (encode in 4 bytes, 1 byte for each channel) of each key, in each row, in each layer>,
	"keyOnColors": <nested array of ARGB color (encode in 4 bytes, 1 byte for each channel) of each key, in each row, in each layer>
}
```

#### Why Icon Use String

[RFC 7159](https://www.rfc-editor.org/rfc/rfc7159#section-6) effectively says json's number is implementation defined (although in practice most are just using IEEE754 double for numbers), but we need to use unsigned 64 bit number. To prevent precision issue caused by json libraries etc, the schema uses string and implementation (i.e. `gen`) is expected to parse the string into unsigned 64 bit number manually.

#### Example

```
// default config of original
{
		"name": "Chonkerkeys Original",
		"layers":["CH_ZOOM_WINDOWS", "CH_ZOOM_MACOS"],
		"sizeOrdinals": [
			[
				[1, 129, 0, 0],
				[65, 67, 0, 1]
			],
			[
				[1, 129, 0, 0],
				[65, 67, 0, 1]
			]
		],
		"keymaps": [
   			[
        		["CH_ZOOM_RAISE_HAND_TOGGLE", "CH_ZOOM_LEAVE_MEETING", "KC_NO", "KC_NO"],
        		["CH_ZOOM_MUTE_TOGGLE", "CH_ZOOM_VIDEO_TOGGLE", "KC_NO", "CH_CUSTOM"]
    		],
    		[
        		["CH_ZOOM_RAISE_HAND_TOGGLE", "CH_ZOOM_LEAVE_MEETING", "KC_NO", "KC_NO"],
        		["CH_ZOOM_MUTE_TOGGLE", "CH_ZOOM_VIDEO_TOGGLE", "KC_NO", "CH_CUSTOM"]
    		]
		],
		// TBC if empty array is acceptable in QMK, otherwise insert KC_NO
		// Max macro length is 3
		"customActions:" [
			[
				[[],[],[],[]],
				[[],[],[],[KC_LSHIFT, KC_A, KC_NO]]
			],
			[
				[[],[],[],[]],
				[[],[],[],[KC_LSHIFT, KC_A, KC_NO]]
			]
		],
		// See icon spec for the meaning of these numbers
		// Again: using string becoz json's specification on number is effectively implementation defined but we strictly need unsigned 64 bit number
		"icons": [
			[
				["1024", "1280", "0", "0"],
				["256", "512", "0", "768"]
			],
			[
				["1024", "1280", "0", "0"],
				["256", "512", "0", "768"]
			]
		],
		// 16711680 = red, 65280 = green, 16777215 = white
		"keyOffColors: [
			[
				[16711680, 0, 0, 0],
				[65280, 16711680, 0, 16777215]
			],
			[
				[16711680, 0, 0, 0],
				[65280, 16711680, 0, 16777215]
			]
		],
		"keyOnColors: [
			[
				[65280, 0, 0, 0],
				[16711680, 65280, 0, 16777215]
			],
			[
				[65280, 0, 0, 0],
				[16711680, 65280, 0, 65280]
			]
		],
}
```

### Size and Ordinal of Key

```
enum Size {
    Key1U = 0,
    Key1_5U,    // 1.5U
    Key3U
}

enum Ordinal {
    Empty = 0,   // a.k.a KC_NO
    Left,
    Top,
    Right,
    Bottom
}

uint8_t sizeOrdinal(Size size, Ordinal ordinal) {
    return (size << 6) & ordinal;
}
```

#### Example

- 1U + left slot: 0 & 1 = 1
- 1.5U + left slot: (1 << 6) & 1 = 64 & 1 = 65
- 1.5U + right slot: (1 << 6) & 3 = 64 & 3 = 67
- 3U + left slot: (2 << 6) & 1 = 128 & 1 = 129

### Icon

See [keycap_icon.md](../keycap_icon.md).
