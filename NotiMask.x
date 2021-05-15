#import <UIKit/UIKit.h>

#pragma mark - Interfaces
@interface UIImage (Private)
+ (instancetype)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(CGFloat)arg3;
@end

@interface SBApplication
@property(nonatomic, readonly) NSString *displayName;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (SBApplication *)applicationWithBundleIdentifier:(id)arg1;
@end

@interface NCNotificationContent : NSObject {
	NSArray *_icons;
}
@end

@interface NCMutableNotificationContent : NCNotificationContent
@property(nonatomic, copy) NSString *header;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *message;
@property(nonatomic, retain) UIImage *icon;
@property(nonatomic, retain) NSArray *icons;
@property(nonatomic, retain) UIImage *attachmentImage;
@end

#pragma mark - Preferences
static BOOL enabled = NO;
static BOOL hideAttachments = NO;
static NSString *app;
static NSString *title;
static NSString *message;

#pragma mark - Hooks

%hook NCNotificationRequest

- (NSString *)sectionIdentifier {
	NSString *bundleID = %orig;

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dunkston.notimask-applist.plist"];
	enabled = prefs[[NSString stringWithFormat:@"enabled-%@", bundleID]] ? [prefs[[NSString stringWithFormat:@"enabled-%@", bundleID]] boolValue] : NO;
	if (enabled && (!app || [app isEqualToString:@""])) app = bundleID;

	return bundleID;
}

%end

%hook NCNotificationContent

- (instancetype)initWithNotificationContent:(NCNotificationContent *)arg1 {
	if (enabled) {
		NCMutableNotificationContent *nc = [arg1 isMemberOfClass:NSClassFromString(@"NCMutableNotificationContent")] ? arg1 : [arg1 mutableCopy];
		nc.icon = [UIImage _applicationIconImageForBundleIdentifier:app format:0 scale:1.46];
		nc.icons = @[[UIImage _applicationIconImageForBundleIdentifier:app format:0 scale:1.46]];
		nc.header = [[%c(SBApplicationController) sharedInstance] applicationWithBundleIdentifier:app].displayName;
		nc.title = title ? [title stringByReplacingOccurrencesOfString:@"$orig$" withString:nc.title] : nil;
		nc.message = message ? [message stringByReplacingOccurrencesOfString:@"$orig$" withString:nc.message] : nil;
		if (hideAttachments) nc.attachmentImage = nil;
		return %orig(nc);
	}
	return %orig;
}

// Had to force like that for icons
- (UIImage *)icon {
	return enabled ? [UIImage _applicationIconImageForBundleIdentifier:app format:0 scale:1.46] : %orig;
}

- (NSArray *)icons {
	return enabled ? @[[UIImage _applicationIconImageForBundleIdentifier:app format:0 scale:1.46]] : %orig;
}

%end

static void loadPrefs() {
	NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dunkston.notimask.plist"];
	hideAttachments = prefs[@"hideAttachments"] ? [prefs[@"hideAttachments"] boolValue] : NO;
	title = prefs[@"title"] ?: @"";
	message = prefs[@"message"] ?: @"";
	prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.dunkston.notimask-applist.plist"];
	app = prefs[@"app"] ?: @"";
}

%ctor {
	loadPrefs();

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.dunkston.notimask.preferencesChanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}