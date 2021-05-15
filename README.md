# NotiMask
> Created by dunkston

**Description:** Disguise your notifications

## Update by Redentic
Asked by `u/RUGMJ7443` [on Reddit](https://www.reddit.com/r/jailbreak/comments/nai8t8/request_could_someone_update_notimask_for_ios_14/).  
Package available [here](packages/com.dunkston.notimask_1.1.0-34+debug_iphoneos-arm.deb), without-icon version [here](packages/com.dunkston.notimask_1.1.0-1+debug_iphoneos-arm.deb).

### Changelog
- Semi-rewrite to support iOS 12+
- Switched to ARC
- Fixed app not saving
- Fixed keyboard not dismissing in prefs
- Added option to hide attachments
- Added clear button
- Fixed fields resetting after applist change
- Changed behavior when no app is selected
- Changed text in settings for better understanding
- Global improvements in code

### Known issues
- Notification icon (property `icons` in `NCNotificationContent`) cannot be changed **only on iOS 14**
- `setPreferenceValue:specifier:` and `readPreferenceValue:` might need to be changed with proper subclassing
