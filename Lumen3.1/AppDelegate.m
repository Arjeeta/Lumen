//
//  AppDelegate.m
//  Lumen3.1
//
//  Created by Preston Perriott on 1/23/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import "AppDelegate.h"
#import "EmptyFlameViewController.h"

static NSString* const kUserHasOnboardedKey = @"user_has_onboarded";


@interface AppDelegate () <CNPPopupControllerDelegate,SKSplashDelegate, RESideMenuDelegate, UITableViewDelegate, UITableViewDataSource, NetworkRequestHandlerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _SelectedNetworkItems = [[NSMutableArray alloc]init];
    
    UIImage *Logo = [UIImage imageNamed:@"Logo_full.png"];
    [Logo imageScaledToSize:CGSizeMake(70, 70)];
    [Logo scale];
    
    CGSize newSize = CGSizeMake(CGRectGetMaxX(self.window.frame)*.7, 150 );
    UIGraphicsBeginImageContext(newSize);
    
    // draw in new context, with the new size
    [Logo drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    
    
    //SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:[UIImage imageNamed:@"Logo_full.png"] animationType:SKIconAnimationTypePing];
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc]initWithImage:newImage animationType:SKIconAnimationTypePing];
     [twitterSplashIcon sizeToFit];
    
    //UIColor *twitterColor = [UIColor colorWithRed:147.0/255.0 green:112.0/255.0 blue:219.0/255.0 alpha:1.0];
    UIColor *twitterColor = [UIColor colorWithRed:245.0/255.0 green:84.0/255.0 blue:23.0/255.0 alpha:.85];
   // [twitterSplashIcon setIconSize:CGSizeMake(150, 150)];
   
    
    _splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon animationType:SKSplashAnimationTypeFade];
    _splashView.delegate = self; //Optional -> if you want to receive updates on animation beginning/end
    _splashView.backgroundColor = twitterColor;
    _splashView.animationDuration = 2.8; //Optional -> set animation duration. Default: 1s
    
    [self.window addSubview:_splashView];
    [self.window bringSubviewToFront:_splashView];
    [self.window makeKeyAndVisible];
    [self.window.rootViewController setView:_splashView];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                                                              
                                                              
                                                              @"kuserhasOnBoarded": @NO,                   @"bool_1": @NO,
                                                              @"bool_2": @NO,
                                                              @"text": @"",
                                                              @"text2" : @"",
                                                              @"number": @0,
                                                              @"date": [NSDate date],
                                                              @"time": [NSDate date],
                                                              @"scent_1": @"",
                                                              @"scent_2": @"",
                                                              
                                        @"networkInfo" : @"",
                                                              
                                                              @"SavedData" : [NSDictionary new],
                                                              }];
    
    return YES;
}
- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
        NSLog(@"Started animating from delegate");
    //To start activity animation when splash animation starts
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
        //To stop activity animation when splash animation ends
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    if (userHasOnboarded) {
        [self setupNormalRootViewController];
    }else{
        self.window.rootViewController = [self generateStandardOnboardingVC];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [_splashView startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Lumen3_1"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

-(void)setupNormalRootViewController{
    [self handleOnboardingCompletion];
}
- (OnboardingViewController *)generateStandardOnboardingVC{
    
    
    
    //A button optionmost likely isn't useful for the initial page as the user doesnt know what the zip code would be used for
    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome" body:@"Here at Lumen our main focus is to make sure you have an enlightening home experience" image:[UIImage imageNamed:@"logo_circle.png"] buttonText:nil action:^{}];
    
    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"How It Works" body:@"Once you power up your Lumen device, using your Iphone, please connect to the new Lumen Network in settings.." image:[UIImage imageNamed:@"logo_circle.png"] buttonText:@"Open Settings" action:^{
        
#pragma Opn Setting function
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url options:[NSDictionary new] completionHandler:nil];
        }
        else {
            // Present some dialog telling the user to open the settings app.
        }
    }];
    
    secondPage.movesToNextViewController =YES;
    secondPage.viewDidAppearBlock = ^{
    };
    //Only need pop up option on last and final page
    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Lastly" body:@"Select a WiFi Network, enter it's password to complete the set up of your Lumen" image:[UIImage imageNamed:@"Round Neighborhood Logo 2 copy.png"] buttonText:@"Surrounding Networks" action:^{
        
        [[NetworkRequestHandler sharedHandler]setDelegate:self];
        [[NetworkRequestHandler sharedHandler]GetNetworks];
        
        if (_NetworkNames.count > 3) {
            [_NetworkTBView reloadData];
        }
        [self didPop];
    }];
    
    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    onboardingVC.fadeSkipButtonOnLastPage = YES;
    onboardingVC.shouldMaskBackground = YES;
    
    
    firstPage.bodyLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:28];
    secondPage.bodyLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:22];
    thirdPage.bodyLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:22];
    
    firstPage.titleLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:34];
    secondPage.titleLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:24];
    thirdPage.titleLabel.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:34];
    
    firstPage.actionButton.font = [UIFont fontWithName:@"AvenirNext-UltraLightItalic" size:24];
    
    
    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
    // when the user hits the skip button.
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipHandler = ^{
        [self handleOnboardingCompletion];
        
        [self UserHasOnBoarded];
    };
    
    return onboardingVC;
    
}
-(void)handleOnboardingCompletion{
    ViewController *HomeVC = [[ViewController alloc]init];
    UINavigationController *HomeNav = [[UINavigationController alloc]initWithRootViewController:HomeVC];

   
    
    ConnectedDevicesVC *CDVC = [[ConnectedDevicesVC alloc]init];
    CDVC.EVC.Gistdelegate = self;
    
    //UINavigationController *ConnectedDNavCont = [[UINavigationController alloc]initWithRootViewController:CDVC];
    
    
    RESideMenu *SideMenu = [[RESideMenu alloc]initWithContentViewController:HomeNav leftMenuViewController:CDVC rightMenuViewController:nil];
    
    SideMenu.backgroundImage = [UIImage imageNamed:@"black-gradient-wallpaper.png"];
    SideMenu.menuPreferredStatusBarStyle = 1;
    SideMenu.delegate = self;
    SideMenu.contentViewShadowColor = [UIColor blackColor];
    SideMenu.contentViewShadowOffset = CGSizeMake(0, 0);
    SideMenu.contentViewShadowOpacity = .6;
    SideMenu.contentViewShadowRadius = 12;
    SideMenu.contentViewShadowEnabled = YES;
    SideMenu.contentViewScaleValue = .4;
    [SideMenu.view setNeedsDisplay];
    
      [self.window setRootViewController:SideMenu];
    
    NSDictionary * dict =[NSDictionary dictionaryWithObject:@"Ravi" forKey:@"name"];
    NSNotification * notification =[[NSNotification alloc]initWithName:@"NOTIFICATION_2" object:nil userInfo:dict];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    [self UserHasOnBoarded];
    
}

-(void)didPop{
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping   ;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Please Select the Network to Connect To" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"AvenirNext-UltraLightItalic" size:24], NSForegroundColorAttributeName : [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1], NSParagraphStyleAttributeName : paragraphStyle}];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_circle"]];
    imageView.frame = CGRectMake(0, 0, 50, 50);
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.attributedText = title;
    
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 170)];
    customView.backgroundColor = [UIColor clearColor];
    customView.layer.cornerRadius = 4;
    
    UIView *customView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 250, 70)];
    customView2.backgroundColor = [UIColor clearColor];
    customView.layer.cornerRadius = 4;
    
    _NetworkTBView = ({
        UITableView *tableView = [[UITableView alloc] init];
        // tableView.translatesAutoresizingMaskIntoConstraints = false;
        //  tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.layer.masksToBounds = YES;
        tableView.layer.cornerRadius = 1;
        tableView.delegate = self;
        tableView.scrollEnabled = YES;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:.56];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.bounces = YES;
        tableView;
    });
    
    [customView addSubview:_NetworkTBView];
    _NetworkTBView.frame = CGRectMake(0, 0, customView.frame.size.width, customView.frame.size.height);
    //NetworkTBView.frame = CGRectMake(0, 0, 250, 220);
    _NetworkTBView.center = customView.center;
    
    _Networktf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 230, 35)];
    //tf.borderStyle = UITextBorderStyleRoundedRect;
    _Networktf.borderStyle = UITextBorderStyleNone;
    _Networktf.placeholder = @"Network Password";
    _Networktf.backgroundColor = [UIColor clearColor];
    _Networktf.textColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1];
    _Networktf.textAlignment = NSTextAlignmentCenter;
    _Networktf.secureTextEntry = YES;
    [customView2 addSubview:_Networktf];
    
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Connect" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:.56];
    button.layer.cornerRadius = 10;
    self.PopupNet =[[CNPPopupController alloc] initWithContents:@[imageView, titleLabel, customView, customView2, button]];
    self.PopupNet.theme = [CNPPopupTheme defaultTheme];
    self.PopupNet.delegate = self;
    [self.PopupNet presentPopupControllerAnimated:YES];
    
    button.selectionHandler = ^(CNPPopupButton *button){
        
        //set NSuser defualts
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        //[prefs setObject:[_SelectedNetworkItems lastObject] forKey:@"networkInfo"];
        [prefs setObject:_Networktf.text forKey:@"networkInfo"];
        
        _CompiledData = [NSMutableArray new];
        [_CompiledData addObject:[_SelectedNetworkItems lastObject]];
        [_CompiledData addObject:_Networktf.text];
        NSLog(@"Compiled Data is : %@",_CompiledData);
        
#pragma POST message for AFNetworking
        
        
        NSDictionary *params = @ {@"Nname" :[_SelectedNetworkItems lastObject], @"Npwd" :_Networktf.text };

        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:0 error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        
        NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"http://192.168.4.1"] parameters:nil error:nil];

        [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [req setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
        
    /*    [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            
            if (!error) {
                NSLog(@"Reply JSON: %@", responseObject);
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    //blah blah
                }
            } else {
                NSLog(@"Error: %@, %@, %@", error, response, responseObject);
            }
        }] resume];  */
       

        
        dispatch_async(dispatch_get_main_queue(), ^{
        if ([_Netdelegate respondsToSelector:@selector(dataFromOnboard:)]) {
            [_Netdelegate dataFromOnboard:_CompiledData];
            if ([_Netdelegate respondsToSelector:@selector(NetworkInfoPassed:)]) {
                [_Netdelegate NetworkInfoPassed:TRUE];
                [self handleOnboardingCompletion];

            }
        }
        });
        
        [self.PopupNet dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
        
        
        
        //delegate methodsd for passing back info to Lumen
    };
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self resignFirstResponder];
    
    NSString *SelectedNetwork = [NSString new];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            SelectedNetwork = [NSString stringWithFormat:@"%@",cell.textLabel.text];
            
            NSLog(@"Selected Network is:%@", SelectedNetwork);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [_Networktf becomeFirstResponder];
            [ _SelectedNetworkItems addObject:SelectedNetwork];
            
            
            break;
            
        default:
            SelectedNetwork = [NSString stringWithFormat:@"%@",cell.textLabel.text];
            NSLog(@"Selected Network is:%@", SelectedNetwork);
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
            [_Networktf becomeFirstResponder];
            
            [ _SelectedNetworkItems addObject:SelectedNetwork];
            
            break;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    return _NetworkNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    cell.textLabel.text = [_NetworkNames objectAtIndex:indexPath.row];
    
    return cell;
    
}
#pragma Network Request Handler Delegate mEthods
-(void)requestHandler:(NetworkRequestHandler *)request didGetNetworks:(NSArray<Networks *> *)networks{
    
    _NetworkNames = [[NSMutableArray alloc]init];
    for (Networks *network in networks) {
        [_NetworkNames addObject:network.SSID];
    }
    NSLog(@"The Network Names :%@", _NetworkNames);
    [_NetworkTBView reloadData];
}
-(void)UserHasOnBoarded{

     NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    [defaults setBool:TRUE forKey:kUserHasOnboardedKey];
   }

@end
