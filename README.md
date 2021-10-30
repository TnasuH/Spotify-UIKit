# Spotify-UIKit

This project developed using via UIKit without Storyboard / Particle-SDK cocoapods usage / getting started.

Built using XCode 13.0 (Swift 5.5)


### How to run the example?

1. Clone this repo
1. Open shell window and navigate to project folder
1. Run `pod install`
1. Open `Spotify.xcworkspace` and run the project on selected device or simulator
1. Create an `ClientConfig.plist` file in the Project->Spotify->Resources folder like 

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>ClientID</key>
    <string>56c8955b963e4****</string>
    <key>ClientSecret</key>
    <string>aeawc3e801c94****</string>
</dict>
</plist>
```

1. ps: ClientID and ClientSecret values can be generated in [Developer Spotify Web Site](https://developer.spotify.com/)
