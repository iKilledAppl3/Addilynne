#import "Common.h"

// statically call the item
TSKSettingItem *kEnabled;

TSKSettingItem *kShowScreenshotPreview;

// How to use
TSKSettingItem *kHowToUse;

// Respring Button
TSKSettingItem *kRespringButton;

// Make sure our path is specified so our tweak knows where to store all of the settings :)
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ikilledappl3.addilynne.plist"

//preferences interface notice that it is of tpee TSKViewController and not of PSListController!
@interface AddilynneListController : TSKViewController
@property (nonatomic, strong) UIBlurEffect *respringBlur;
@property (nonatomic, strong) UIVisualEffectView *respringEffectView;
@end


// this is here so we can launch a task that "resprings" the Apple TV.
@interface NSTask : NSObject
@property (copy) NSArray *arguments;
@property (copy) NSString *currentDirectoryPath;
@property (copy) NSDictionary *environment;
@property (copy) NSString *launchPath;
@property (readonly) int processIdentifier;
@property (retain) id standardError;
@property (retain) id standardInput;
@property (retain) id standardOutput;
+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;
- (id)init;
- (void)interrupt;
- (bool)isRunning;
- (void)launch;
- (bool)resume;
- (bool)suspend;
- (void)terminate;
@end
