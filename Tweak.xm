#import "Addilynne.h"

%hook UIViewController 
-(void)viewDidLoad { 
	if (kEnabled) {
		%orig;

	tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(menuTapPress:)];
    tapGestureRecognizer.allowedPressTypes = @[[NSNumber numberWithInteger:UIPressTypeMenu]];
    tapGestureRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGestureRecognizer];
	}

	else {
		%orig;
	}

}

%new -(void)menuTapPress:(UITapGestureRecognizer *)sender {
		[self flashScreen];
	
}


%new -(void)flashScreen {
  UIWindow *mainAppRootWindow = [UIApplication sharedApplication].keyWindow;
  UIView *screenshotView = [[UIView alloc] init];
    screenshotView.frame = [[UIScreen mainScreen] bounds];
    screenshotView.backgroundColor = [UIColor whiteColor];
    [mainAppRootWindow addSubview:screenshotView];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [screenshotView setAlpha:0];
    [UIView commitAnimations];

    // fire a screenshot sound
		[self fireScreenshotSound];
    
}


%new -(void)fireScreenshotSound {
			screenshotSound = 0;
			AudioServicesDisposeSystemSoundID(screenshotSound);
			AudioServicesCreateSystemSoundID((CFURLRef)[NSURL fileURLWithPath:[NSString stringWithFormat:@"%@", screenshotSoundFile]],& screenshotSound);
			AudioServicesPlaySystemSound(screenshotSound);

			// take the screenshot
			[self performSelector:@selector(takeScreenshotWithTask:) withObject:nil afterDelay:0.7];
}


%new -(void)takeScreenshotWithTask:(NSTask *)task {
	// we launch a task because we need to call on nitoTV's screencapture utility!
	task = [[NSTask alloc] init];
    [task setLaunchPath:@"/usr/bin/screencapture"];
    [task launch];
}
%end


// Load preferences to make sure changes are written to the plist
static void loadPrefs() {

  NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  
    //our preference values that write to a plist file when a user selects somethings
  kEnabled = [([prefs objectForKey:@"kEnabled"] ?: @(NO)) boolValue];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("com.ikilledappl3.addilynne.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}
