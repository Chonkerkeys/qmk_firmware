#!/bin/bash -e

if [[ "$FIRMWARE_CONFIG_OUTPUT" == "" ]]
then
    FIRMWARE_CONFIG_OUTPUT="config.c"
fi

TARGET=$1

if [[ "$TARGET" == "" ]]
then
    echo "fatal: Missing target. Usage: gen-config [gen,gen-original,gen-max]"
    exit 1
fi

if [[ "$TARGET" == "gen" ]]
then
    echo "generating custom config..."
	python3 gen/src/ch-qmk-gen.py --firmware-version=$FIRMWARE_VERSION --config=$FIRMWARE_CONFIG --output=$FIRMWARE_CONFIG_OUTPUT
elif [[ "$TARGET" == "gen-original" ]]
then
    echo "generating original config..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\"], \
		\"sizeOrdinals\": [ \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			] \
		], \
		\"keymaps\": [ \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"CH_ZOOM_RAISE_HAND_TOGGLE\"], \
        		[\"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_ZOOM_VIDEO_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"CH_ZOOM_RAISE_HAND_TOGGLE\"], \
        		[\"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_ZOOM_VIDEO_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-original-all" ]]
then
    echo "generating original config with all layers..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\", \"CH_TEAMS_WINDOWS\", \"CH_TEAMS_MACOS\", \"CH_SKYPE_WINDOWS\", \"CH_SKYPE_MACOS\", \"CH_GOOGLE_MEET_WINDOWS\", \"CH_GOOGLE_MEET_MACOS\"], \
		\"sizeOrdinals\": [ \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			], \
			[ \
				[0, 0, 129, 1], \
				[1, 0, 67, 65] \
			] \
		], \
		\"keymaps\": [ \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"CH_ZOOM_RAISE_HAND_TOGGLE\"], \
        		[\"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_ZOOM_VIDEO_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"CH_ZOOM_RAISE_HAND_TOGGLE\"], \
        		[\"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_ZOOM_VIDEO_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_LEAVE_MEETING\", \"CH_TEAMS_RAISE_HAND_TOGGLE\"], \
        		[\"CH_TEAMS_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_TEAMS_VIDEO_TOGGLE\", \"CH_TEAMS_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_LEAVE_MEETING\", \"CH_TEAMS_RAISE_HAND_TOGGLE\"], \
        		[\"CH_TEAMS_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_TEAMS_VIDEO_TOGGLE\", \"CH_TEAMS_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_LEAVE_MEETING\", \"CH_SKYPE_RAISE_HAND_TOGGLE\"], \
        		[\"CH_SKYPE_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_SKYPE_VIDEO_TOGGLE\", \"CH_SKYPE_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_LEAVE_MEETING\", \"CH_SKYPE_RAISE_HAND_TOGGLE\"], \
        		[\"CH_SKYPE_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_SKYPE_VIDEO_TOGGLE\", \"CH_SKYPE_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_LEAVE_MEETING\", \"CH_GOOGLE_MEET_RAISE_HAND_TOGGLE\"], \
        		[\"CH_GOOGLE_MEET_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_GOOGLE_MEET_VIDEO_TOGGLE\", \"CH_GOOGLE_MEET_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_LEAVE_MEETING\", \"CH_GOOGLE_MEET_RAISE_HAND_TOGGLE\"], \
        		[\"CH_GOOGLE_MEET_SHARE_SCREEN_START_STOP_TOGGLE\", \"KC_NO\", \"CH_GOOGLE_MEET_VIDEO_TOGGLE\", \"CH_GOOGLE_MEET_MUTE_TOGGLE\"] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-max" ]]
then
    echo "generating max config..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\"], \
		\"sizeOrdinals\": [ \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			] \
		], \
		\"keymaps\": [ \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_RAISE_HAND_TOGGLE\", \"CH_ZOOM_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_RAISE_HAND_TOGGLE\", \"CH_ZOOM_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-max-all" ]]
then
    echo "generating max config with all layers..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\", \"CH_TEAMS_WINDOWS\", \"CH_TEAMS_MACOS\", \"CH_SKYPE_WINDOWS\", \"CH_SKYPE_MACOS\", \"CH_GOOGLE_MEET_WINDOWS\", \"CH_GOOGLE_MEET_MACOS\"], \
		\"sizeOrdinals\": [ \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			], \
			[ \
				[0, 0, 129, 0], \
				[1, 1, 1, 66], \
				[1, 1, 1, 68] \
			] \
		], \
		\"keymaps\": [ \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_RAISE_HAND_TOGGLE\", \"CH_ZOOM_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_RAISE_HAND_TOGGLE\", \"CH_ZOOM_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_ZOOM_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_ZOOM_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_RAISE_HAND_TOGGLE\", \"CH_TEAMS_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_TEAMS_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_RAISE_HAND_TOGGLE\", \"CH_TEAMS_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_TEAMS_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_TEAMS_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_RAISE_HAND_TOGGLE\", \"CH_SKYPE_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_SKYPE_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_RAISE_HAND_TOGGLE\", \"CH_SKYPE_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_SKYPE_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_SKYPE_MUTE_TOGGLE\"] \
    		], \
			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_RAISE_HAND_TOGGLE\", \"CH_GOOGLE_MEET_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_GOOGLE_MEET_MUTE_TOGGLE\"] \
    		], \
   			[ \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_LEAVE_MEETING\", \"KC_NO\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_RAISE_HAND_TOGGLE\", \"CH_GOOGLE_MEET_VIDEO_TOGGLE\"], \
        		[\"KC_NO\", \"KC_NO\", \"CH_GOOGLE_MEET_SHARE_SCREEN_START_STOP_TOGGLE\", \"CH_GOOGLE_MEET_MUTE_TOGGLE\"] \
    		] \
		] \
	}"
else
	echo "fatal: Unknown target: $TARGET"
	exit 1
fi
