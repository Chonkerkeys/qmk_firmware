import json
import argparse

def print_array(array, indent):
    result = ""
    for i in range(0, indent):
        result += "    "
    result += "{\n"
    size = len(array)
    for i, element in enumerate(array):
        if (isinstance(element, list)):
            result += print_array(element, indent + 1)
        else:
            for j in range(0, indent + 1):
                result += "    "
            result += "{}".format(element)
        if (i + 1 < size):
            result += ",\n"
        else:
            result += "\n"
    for i in range(0, indent):
        result += "    "
    result += "}"
    return result

def map_element_or_list_mapper(element, func):
    if (isinstance(element, list)):
        return list(map(lambda e: map_element_or_list_mapper(e, func), element))
    else:
        return func(element)

def map_element_or_list(func, array):
    return list(map(lambda e: map_element_or_list_mapper(e, func), array))

def simplify_key_action(action):
    if ('MUTE_TOGGLE' in action):
        return "MUTE_TOGGLE"
    elif ('VIDEO_TOGGLE' in action):
        return "VIDEO_TOGGLE"
    elif ("SHARE_SCREEN_START_STOP_TOGGLE" in action):
        return "SHARE_SCREEN_START_STOP_TOGGLE"
    elif ("RAISE_HAND_TOGGLE" in action):
        return "RAISE_HAND_TOGGLE"
    elif ("LEAVE_MEETING" in action):
        return "LEAVE_MEETING"
    else:
        return ""

parser = argparse.ArgumentParser()
parser.add_argument("--firmware-version", type=int, required=True)
parser.add_argument("--config", type=str, required=True)
parser.add_argument("--output", type=str, required=True)

args = parser.parse_args()

firmware_version = args.firmware_version
config = json.loads(args.config)
name = config["name"]
layers = config["layers"]
layer_count = len(layers)
size_ordinals = config["sizeOrdinals"]
keymaps = config["keymaps"]
actionTypeToAnimationMaps = {
    "MUTE_TOGGLE": "RGB_STRAND_EFFECT_MOMENTARY",
    "VIDEO_TOGGLE": "RGB_STRAND_EFFECT_MOMENTARY",
    "SHARE_SCREEN_START_STOP_TOGGLE": "RGB_STRAND_EFFECT_BLINKY",
    "RAISE_HAND_TOGGLE": "RGB_STRAND_EFFECT_LIKE",
    "LEAVE_MEETING": "RGB_STRAND_EFFECT_DRAINSWIRL"
}
noAnimation = "RGB_STRAND_EFFECT_NONE"
animations = map_element_or_list(lambda k: actionTypeToAnimationMaps.get(simplify_key_action(k)) or noAnimation, keymaps)

if (len(size_ordinals) != layer_count or len(keymaps) != layer_count):
    print("length of size ordinals or keymaps doesn't match layer count")
    exit(1)

# TODO: Validate row/column count

c_output_path = args.output

c_output = "#include \"../../../keyconfig.h\"\n"
c_output += "#include \"../../../layer_type.h\"\n"
c_output += "\n"
c_output += "const uint32_t firmware_version = {};\n".format(firmware_version)
c_output += "\n"
c_output += "#define LAYER_COUNT {}\n".format(layer_count)
c_output += "\n"
c_output += "const uint8_t layers[LAYER_COUNT] = "
c_output += print_array(layers, 0)
c_output += ";\n"
c_output += "\n"
c_output += "const uint8_t key_size_and_ordinals[LAYER_COUNT][MATRIX_ROWS][MATRIX_COLS] = "
c_output += print_array(size_ordinals, 0)
c_output += ";\n"
c_output += "\n"
c_output += "const uint16_t PROGMEM keymaps[][MATRIX_ROWS][MATRIX_COLS] = "
c_output += print_array(keymaps, 0)
c_output += ";\n"
c_output += "\n"
c_output += "const rgb_strands_anim_t key_anim[][MATRIX_ROWS][MATRIX_COLS] = "
c_output += print_array(animations, 0)
c_output += ";\n"

file = open(c_output_path, "w")
file.write(c_output)
file.close()


h_output_path = "config.h"
h_output = "#pragma once\n"
h_output += "\n"
h_output += "#define PRODUCT {}\n".format(name)

file = open(h_output_path, "w")
file.write(h_output)
file.close()
