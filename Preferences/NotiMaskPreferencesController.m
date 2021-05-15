#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>

@interface NotiMaskPreferencesController : PSListController
- (void)clearFields:(id)sender;
@end

@implementation NotiMaskPreferencesController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.table.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (NSArray *)specifiers {
	if (!_specifiers) _specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:path];
	return settings[specifier.properties[@"key"]] ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:path];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];

	CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}
}

- (void)clearFields:(id)sender {
	for (PSSpecifier *specifier in _specifiers) {
		if ([specifier isKindOfClass:NSClassFromString(@"PSTextFieldSpecifier")]) {
			if ([self readPreferenceValue:specifier] && ![[self readPreferenceValue:specifier] isEqualToString:@""]) {
				[self setPreferenceValue:@"" specifier:specifier];
				[self reloadSpecifier:specifier animated:YES];
			}
		}
	}
}

@end