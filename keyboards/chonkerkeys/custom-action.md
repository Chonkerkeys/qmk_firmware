# Custom Action Guide

QMK allows defining custom key code so that it can be handled in `process_record_user`. Chonkerkeys utilize custom key code to implement layer specific custom action, such as leave meeting, toggle mute, etc. This doc explains some of the design decision and things to be aware of when updating the set of custom key code.

## Design

All custom actions are defined simply as a continuous enum of custom key code, with action "duplicated" for each layer, aka a flattened list. So, instead of defining `LEAVE_MEETING`, and do lookup based on layer type when the pressed key code is `LEAVE_MEETING`,  `ZOOM_LEAVE_MEETING` is defined for zoom, and `TEAMS_LEAVE_MEETING` is defined for teams, and there is no extra lookup when a key is pressed - you know it's for zoom or teams right away. 

This design is adopted due to both historical and performance reason:

1. First design include significantly more actions for zoom. To prevent complicated lookup (by layer + by key + by ignore logic) when a key is pressed, it was decided that a "flattened" list is better than keeping two separate sets (layer + action) and allowing ignored action on some layers. As time goes on, the scope is reduced, the number of zoom specific action is reduced, and at the time of writing all layers have the same actions.
2. A flattened list allows O(1) lookup of key action with just a single read. Reading a different array based on layer requires an extra or more reads (although it's still O(1))
3. Common actions is simpler for a flattened list. Unioning the layer and action sets incurs more cost (either waste space or waste runtime perf) as common action is supposed to be layer-agnostic.

TLDR: A flattened enum is simpler, faster, and use less space than the alternative.

## Updating Custom Action

To maintain the same O(1) read performance benefit, the app adopts the exact custom action enum. Thus, when a key pressed event is sent to the app, the app knows exactly what action it needs to perform.

It also means that the app needs to synchronize it's custom action enum with the firmware. If custom action is updated in the firmware in a _non-backward-compatible way_, the app _must_ update as well.

Since chonkerkeys support no-app scenario, the keyboard is expected to send out macros even when the app is not ran (i.e. the keyboard is not connected to the app). If a custom action is added/removed, the respective macro should be inserted/removed in `windows_configs` and `macos_configs`.

TLDR:
If `custom_keycodes` is updated:
1. Synchronize app's `KeyboardActionType` in both the sdk (C++, the background process) and the app (TS, the UI).
2. Add/remove entries in `windows_configs`.

### Protocol Consideration

The protocol currently uses `uint8_t` for key action. If the number of custom action exceeds 255, use `uint16_t` instead. This is a breaking change and would require app to update it's protocol as well.

## Notes

The protocol handler subtract `CH_*` by `CH_CUSTOM` so that the app gets the enum value it's expecting (`CH_CUSTOM` starts at `SAFE_RANGE` whereas `KeyboardActionType.Custom` starts at 0).
