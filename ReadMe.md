Make xcframework from universal framework for iOS.

Example:

Download `Bugly.framework` from https://bugly.qq.com/v2/downloads

```bash
./make_xcframework.sh Bugly
```

After finished, `Bugly.xcframework` will be created.

```
Bugly.xcframework
|--ios-arm64_armv7_armv7s
|   --Bugly.framework
|--ios-i386_x86_64-simulator
|   --Bugly.framework
|--Info.plist
```