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
	if [[ "$FIRMWARE_VERSION" == "" ]]
	then
		FIRMWARE_VERSION=1
	fi
    python3 gen/src/ch-qmk-gen.py --firmware-version=$FIRMWARE_VERSION --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"name\":\"Chonkerkeys Original\",
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\"], \
		\"sizeOrdinals\": [ \
			[0, 0, 129, 1], \
			[1, 0, 67, 65] \
		], \
		\"icons\": [ \
			[\"0\", \"0\", \"1280\", \"1024\"], \
			[\"768\", \"0\", \"512\", \"256\"] \
		], \
		\"keyOffColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			] \
		], \
		\"keyOnColors\": [ \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
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
		], \
		\"customActions\": [ \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-original-all" ]]
then
    echo "generating original config with all layers..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"name\":\"Chonkerkeys Original\",
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\", \"CH_TEAMS_WINDOWS\", \"CH_TEAMS_MACOS\", \"CH_SKYPE_WINDOWS\", \"CH_SKYPE_MACOS\", \"CH_GOOGLE_MEET_WINDOWS\", \"CH_GOOGLE_MEET_MACOS\"], \
		\"sizeOrdinals\": [ \
			[0, 0, 129, 1], \
			[1, 0, 67, 65] \
		], \
		\"icons\": [ \
			[\"0\", \"0\", \"1280\", \"1024\"], \
			[\"768\", \"0\", \"512\", \"256\"] \
		], \
		\"keyOffColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[4294901760, 0, 4278190080, 4278190080] \
			] \
		], \
		\"keyOnColors\": [ \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 16711680], \
				[16711680, 0, 16711680, 16711680] \
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
		], \
		\"customActions\": [ \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-max" ]]
then
    echo "generating max config..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"name\":\"Chonkerkeys Max\",
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\"], \
		\"sizeOrdinals\": [ \
			[0, 0, 129, 0], \
			[1, 1, 1, 66], \
			[1, 1, 1, 68] \
		], \
		\"icons\": [ \
			[\"0\", \"0\", \"1280\", \"0\"], \
			[\"2048\", \"1536\", \"1024\", \"512\"], \
			[\"2304\", \"1792\", \"768\", \"256\"] \
		], \
		\"keyOffColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			] \
		], \
		\"keyOnColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
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
		], \
		\"customActions\": [ \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		] \
		] \
	}"
elif [[ "$TARGET" == "gen-max-all" ]]
then
    echo "generating max config with all layers..."
    python3 gen/src/ch-qmk-gen.py --firmware-version=1 --output=$FIRMWARE_CONFIG_OUTPUT --config="{ \
		\"name\":\"Chonkerkeys Max\",
		\"layers\":[\"CH_ZOOM_WINDOWS\", \"CH_ZOOM_MACOS\", \"CH_TEAMS_WINDOWS\", \"CH_TEAMS_MACOS\", \"CH_SKYPE_WINDOWS\", \"CH_SKYPE_MACOS\", \"CH_GOOGLE_MEET_WINDOWS\", \"CH_GOOGLE_MEET_MACOS\"], \
		\"sizeOrdinals\": [ \
			[0, 0, 129, 0], \
			[1, 1, 1, 66], \
			[1, 1, 1, 68] \
		], \
		\"icons\": [ \
			[\"0\", \"0\", \"1280\", \"0\"], \
			[\"2048\", \"1536\", \"1024\", \"512\"], \
			[\"2304\", \"1792\", \"768\", \"256\"] \
		], \
		\"keyOffColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 0, 4278190080], \
				[0, 0, 4294901760, 4278190080] \
			] \
		], \
		\"keyOnColors\": [ \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
			], \
			[ \
				[0, 0, 0, 0], \
				[0, 0, 16711680, 16711680], \
				[0, 0, 16711680, 16711680] \
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
		], \
		\"customActions\": [ \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		], \
   			[ \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]], \
        		[[\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"], [\"KC_NO\", \"KC_NO\", \"KC_NO\"]] \
    		] \
		] \
	}"
else
	echo "fatal: Unknown target: $TARGET"
	exit 1
fi
