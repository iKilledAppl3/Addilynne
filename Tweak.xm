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
  mainAppRootWindow = [UIApplication sharedApplication].keyWindow;
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


      if (kShowScreenshotPreview) {
          //preview the screenshot
      [self performSelector:@selector(showScreenshotImageView) withObject:nil afterDelay:0.7];
      }

      else {
          // take the screenshot
         [self performSelector:@selector(takeScreenshotWithTask:) withObject:nil afterDelay:0.7];
      }
}

// preview the screenshot
%new -(void)showScreenshotImageView {
        screenshotImageView = [[UIImageView alloc] initWithImage:_UICreateScreenUIImage()];
        screenshotImageView.frame = CGRectMake(110, 815, 450, 250);
        screenshotImageView.layer.cornerRadius = 10.0f;
        screenshotImageView.layer.borderWidth = 10.0f;
        screenshotImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
        screenshotImageView.layer.shadowOffset = CGSizeMake(3.0, 3.0);
        screenshotImageView.layer.shadowOpacity = 0.5;
        screenshotImageView.layer.shadowRadius = 10.0;
        screenshotImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        [screenshotImageView setAlpha:0.0];
        [screenshotImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [screenshotImageView setContentMode:UIViewContentModeScaleAspectFill];
        
        [UIView animateWithDuration:0.6 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [screenshotImageView setAlpha:1.0];
        } completion:^(BOOL finished) {

            // take the screenshot
            [self performSelector:@selector(takeScreenshotWithTask:) withObject:self afterDelay:3.0];
        }];
     [mainAppRootWindow addSubview:screenshotImageView];
}

%new -(void)takeScreenshotWithTask:(NSTask *)task {
  // hide the screenshot image view 
  [screenshotImageView setAlpha:0.0];

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
  // enable this by default
  kShowScreenshotPreview = [([prefs objectForKey:@"kShowScreenshotPreview"] ?: @(NO)) boolValue];
}

%ctor {
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("com.ikilledappl3.addilynne.prefschanged"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
  loadPrefs();
}
