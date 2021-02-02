// Headers we need.
@import UIKit;
@import AVFoundation;
@import AudioToolbox;
#import <objc/runtime.h>

// Enables the tweak
BOOL kEnabled;

// show the image view or not
BOOL kShowScreenshotPreview;

// the PLIST path where all user settings are stored.
#define PLIST_PATH @"/var/mobile/Library/Preferences/com.ikilledappl3.addilynne.plist"

// static stuff
UITapGestureRecognizer *tapGestureRecognizer;

// Original Apple Shutter Sound.
NSString *screenshotSoundFile = [[NSBundle bundleWithPath:@"/System/Library/Audio/UISounds/"] pathForResource:@"photoShutter" ofType:@"caf"];

// set the sound ID
SystemSoundID screenshotSound;

// show the screenshot image 
extern "C" UIImage* _UICreateScreenUIImage();

 UIImageView *screenshotImageView;
 UIWindow *mainAppRootWindow;

// interfaces 
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

@interface UIViewController (Addilynne)
-(void)flashScreen;
-(void)fireScreenshotSound;
@end

