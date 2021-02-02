#import "AddilynneListController.h"


// All preferences on tvOS are added in programatically in groups.

@implementation AddilynneListController

// this is to make sure our tweak's property list is loaded and all settings values are changed.
inline NSString *GetPrefVal(NSString *key){
    return [[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key];
}


// Lets load our prefs!
- (id)loadSettingGroups {
    
    id facade = [[NSClassFromString(@"TVSettingsPreferenceFacade") alloc] initWithDomain:@"com.ikilledappl3.addilynne" notifyChanges:TRUE];
    
    NSMutableArray *_backingArray = [NSMutableArray new];
    
    // to add more settings add them like so...
    kEnabled = [TSKSettingItem toggleItemWithTitle:@"Enable Tweak" description:@"This screenshot tweak has superpowers!" representedObject:facade keyPath:@"kEnabled" onTitle:@"Enabled" offTitle:@"Disabled"];
    
     // to add more settings add them like so...
    kShowScreenshotPreview = [TSKSettingItem toggleItemWithTitle:@"Screenshot Preview" description:@"Shows a preview of the screenshot before AirDropping it." representedObject:facade keyPath:@"kShowScreenshotPreview" onTitle:@"Enabled" offTitle:@"Disabled"];
    
        // Respring Button here baby!
    kHowToUse = [TSKSettingItem actionItemWithTitle:@"How to Use" description:@"I knew nothing could come good from these city folk and their new fangaled screenshot thingy." representedObject:facade keyPath:PLIST_PATH target:self action:@selector(showMeHowToUse)];
    
    // Respring Button here baby!
    kRespringButton = [TSKSettingItem actionItemWithTitle:@"Respring" description:@"Apply Changes with a Respring! \n Copyright 2020 - 2021 J.K. Hayslip (@iKilledAppl3) & iKilledAppl3 LLC. All rights reserved." representedObject:facade keyPath:PLIST_PATH target:self action:@selector(doAFancyRespring)];
    
    
    // you add your settings to a group basically an NSArray so the Settings app can see them.
    TSKSettingGroup *group = [TSKSettingGroup groupWithTitle:@"Tweak Options" settingItems:@[kEnabled, kShowScreenshotPreview]];
    TSKSettingGroup *group2 = [TSKSettingGroup groupWithTitle:@"How To Use" settingItems:@[kHowToUse]];
    TSKSettingGroup *group3 = [TSKSettingGroup groupWithTitle:@"Apply Changes" settingItems:@[kRespringButton]];
    
    [_backingArray addObject:group];
    [_backingArray addObject:group2];
    [_backingArray addObject:group3];
    
    [self setValue:_backingArray forKey:@"_settingGroups"];
    
    return _backingArray;
    
}


-(void)showMeHowToUse {
    // call the main view controller of the application so we can push the alert to the main view.
UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;


//then call ther alert controller
UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Tutorial"
                               message:@"It's dangerous to go alone take this! \n Double tap the menu button on the Siri Remote to take a screenshot. \n That is all! \n What were you expecting a list? C'mon I don't have all day!"
                               preferredStyle:UIAlertControllerStyleAlert];
 
UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
 
[alert addAction:okAction];
[vc presentViewController:alert animated:YES completion:nil];

}

// Let's blur the screen before we kill backboardd >:)
-(void)doAFancyRespring {
    self.respringBlur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.respringEffectView = [[UIVisualEffectView alloc] initWithEffect:self.respringBlur];
    self.respringEffectView.frame = self.view.frame;
    [self.respringEffectView setAlpha:0.0];
    [[self view] addSubview:self.respringEffectView];

     [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.respringEffectView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self respring];
    }];
    
}

-(void)respring {
    NSTask *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];
    
}

// this is to make sure our preferences our loaded
- (TVSPreferences *)ourPreferences {
    return [TVSPreferences preferencesWithDomain:@"com.ikilledappl3.addilynne"];
}


// This is to show our preferences in the tweaks section of tvOS.
- (void)showViewController:(TSKSettingItem *)item {
    TSKTextInputViewController *testObject = [[TSKTextInputViewController alloc] init];
    
    testObject.headerText = @"Addilynne";
    testObject.initialText = [[self ourPreferences] stringForKey:item.keyPath];
    
    [self.navigationController pushViewController:testObject animated:TRUE];
}


// This is to show our tweak's icon instead of the boring Apple TV logo :)
-(id)previewForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TSKPreviewViewController *item = [super previewForItemAtIndexPath:indexPath];
    
    NSString *imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"Addilynne" ofType:@"png"];
    UIImage *icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        TSKVibrantImageView *imageView = [[TSKVibrantImageView alloc] initWithImage:icon];
        [item setContentView:imageView];
        
    }
    
    return item;
    
}

@end
