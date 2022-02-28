# Chonkerkeys Keycap Icon Encoding Spec

Each chonkerkeys keyboard comes with a set of keycap icon that is not using ordinary ANSI or whatever ISO standard keyboard layout. Since chonkerkeys app has to display the keycap icon, we need to come up with a custom encoding. The idea is that the firmware would store which key has which icon, and the app could retreive the correct icon for each key during initialization.

Chonkerkeys also supports keycap customization: the flow being that customers will order a keycap whose icon is customized and uploaded to chonkerkeys server, and get back the keycap directly from chonkerkeys. The customized keycap comes with a unique code (you can think of it as a model number) to identify itself. User could enter the code in the app and the app would be able to get back an icon from the unique code via chonkerkeys' server.

## Spec

The encoding for the icon is called the chonkerkeys keycap icon encoding. Each icon has an icon code. Each icon code is a 64 bit unsigned number. Techincally we can simply use 128 bit uuid, but for the sake of reducing firmware size (at the time of writing, firmware binary already reaches ~90% of the maximum size, before including the icon), a 64 bit number is used instead.

### Storage

In firmware, the number is stored directly as a `uint64_t`. No fancy text encoding and what not. 

The same goes for the app.

Server can use whatever storage mechanism it wants as long as it's forward and backward compatible with the icon API. For example, if the users of chonkerkeys grow so fast that it's conceivable that 64 bit number is not enough, server can migrate to using uuid and convert all of 64 bit to uuid internally.

### Reserved Icon

The first 8 bit, i.e. 0x0 to 0xFF for the icon code is reserved.

### Predefined Icon

The next 12 bits, i.e. 0x100 to 0xF FF00 is reserved for predefined icon. Predefined icon are icons that are reserved and used by chonkerkeys. The chonkerkeys app has domain knowledge of these predefined icons and could identity a unique icon from the icon code on its own. Chonkerkeys has at max 9 keys at launch. Practically, chonkerkeys is likely to have at most ~1000 predefined icons. To simplify bit manipulation, it's decided that predefined icon can use 12 bits, thus 4096 - 1 = 4095 icon (8 bit = 256 is too few, 16 bit = 65536 might be too many. -1 since 0x000 is reserved).

### User-Customized Icon

The rest of the 64 bit unsigned number, i.e. 0x100000 to 0xFFFF FFFF FFF0 0000 is for user customized icon. User customized icon are icons whose code from which the chonkerkeys app could not identify a unique icon. The app has to query the server for the actual icon supplied by user instead.

There can be at most 2 ^ 44 - 1 = 17,592,186,044,415 user customized icon.

### TL;DR

- Each keycap has an icon which is identified by an unsigned 64 bit number
- 8 bits in the 64 bit numbers are reserved.
- 12 bits in the 64 bit numbers are reserved for predefined icons, so there are 4096 - 1 of them
- 44 bits in the 64 bit numbers are reserved for user customized icons, so there are lots of them
- The app can distinguish between predfined and user customized icons by a simple bit mask
- The app would use bundled icon for predefined icon, and ask server for user customized icon

### Predefined Icon List

```
enum PredefinedIcon
{
    Mic = 1,
    Video = 2,
    ShareScreen = 3,
    RaiseHand = 4,
    LeaveMeeting = 5,
    VolumeUp = 6,
    VolumeDown = 7,
    MediaNext = 8,
    MediaPlayPause = 9
}
```