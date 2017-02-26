//
//  ViewController.m
//  Lumen3.1
//
//  Created by Preston Perriott on 1/23/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <CNPPopupControllerDelegate, UITableViewDelegate, UITableViewDataSource, NetworkInfoDelegate, NewLumenDelegate, EHHorizontalSelectionViewProtocol, RKDropdownAlertDelegate, LumenTableViewCellDelegate>


@end

@implementation ViewController

-(void)viewDidAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.Netdelegate = self;
    [super viewDidAppear:animated];
    
}
- (void)viewDidLoad {
    
    
    self.modalPresentationCapturesStatusBarAppearance = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    [[UIApplication sharedApplication]setStatusBarHidden:YES];
    
    
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
   _NetINFO = [defaults objectForKey:@"networkInfo"];
    NSLog(@"NSUser defaults : %@", _NetINFO);

    _PlacesArray = [[NSMutableArray alloc]initWithObjects:@"Living Room", @"Kitchen", @"Bedroom", @"Attic", @"Bathroom", nil];
    
    NSArray *array = [NSArray arrayWithObjects:@"",@"",@"",@"",@"",@"",@"", nil];
    _LumenDict = [NSMutableDictionary dictionaryWithObjects:array forKeys:@[@"name",@"location",@"timerop",@"date",@"time",@"scent1",@"scent2"]];
    
    _LumenNames = [[NSMutableArray alloc]init];
    
    _BGImage = [UIImage imageNamed:@"GradientPlanner.jpg"];
   // _BGImage = [UIImage imageNamed:@"gradient-blue.png"];
    _BGImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _BGImageView.contentMode = UIViewContentModeScaleAspectFill;
    _BGImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _BGImageView.layer.masksToBounds = TRUE;
    _BGImageView.image = _BGImage;
    [self.view addSubview:_BGImageView];
    
    
    _hSelView4 = [[EHHorizontalSelectionView alloc]init];
    _hSelView4.translatesAutoresizingMaskIntoConstraints = false;
    _hSelView4.delegate = self;
    //_hSelView4.backgroundColor = [[UIColor blueColor]colorWithAlphaComponent:.45];
    _hSelView4.backgroundColor = [UIColor colorWithRed:199/255   green:175/255 blue:189/255 alpha:.45];
    [_hSelView4 setTextColor:[UIColor whiteColor]];
    
    [_hSelView4 registerCellWithClass:[EHHorizontalLineViewCell class]];
    
    [self.view addSubview:_hSelView4];
    
    [_hSelView4.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = TRUE;
    [_hSelView4.widthAnchor constraintEqualToAnchor:self.view.widthAnchor].active = TRUE;
    [_hSelView4.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [_hSelView4.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    
    _MenuVBF = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake(0, 0, 15, 15) buttonType:buttonMenuType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    _MenuVBF.lineThickness = .5;
    _MenuVBF.roundBackgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.47];
    _MenuVBF.tintColor = [UIColor whiteColor];
    [_MenuVBF addTarget:self action:@selector(handleConnectedDevices:) forControlEvents:UIControlEventTouchUpInside];
    
    
 /*   [self.navigationController.navigationBar setFrame:CGRectMake(0, self.view.frame.size.height-180, self.view.frame.size.width, 40)];
    [self.view addSubview:self.navigationController.navigationBar];
  
    UIBarButtonItem *barbtn = [[UIBarButtonItem alloc]initWithCustomView:_MenuVBF];
    self.navigationItem.leftBarButtonItem = barbtn;

    self.navigationController.navigationBar.translucent = YES;
  
    */
    
    UIImageView *Title = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo_text.png"]];
    //Title.translatesAutoresizingMaskIntoConstraints = false;
    Title.alpha = .5;
    Title.frame = CGRectMake(0, 0, 30, 30);
    
    
    //[self.view addSubview:Title];

    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    UINavigationItem *bottomNavigationItem = [[UINavigationItem alloc] init];
    bottomNavigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_MenuVBF];
    //bottomNavigationItem.titleView = Title;
    bottomNavigationItem.title = @"L U M E N";
    
    
    
    UINavigationBar *bottomBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    bottomBar.items = @[bottomNavigationItem];
    [self.view addSubview:bottomBar];
    
    
    [bottomBar setTranslucent:YES];

    [bottomBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [bottomBar setShadowImage:[UIImage new]];
    //_VBFButton = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((self.view.bounds.size.width/2) - 34,self.view.bounds.size.height/2 - 30 , 80, 80) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    
    
    /*[Title.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:50].active = TRUE;
    [Title.heightAnchor constraintEqualToConstant:50].active = TRUE;
    [Title.widthAnchor constraintEqualToConstant:150].active = TRUE;
    [Title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         Title.alpha = .89;
                     }
                     completion:^(bool fin){
                         [self ButtonFloat:_VBFButton];
                     }];*/
    
    
    
    
    
    _LumenDevicesView = [[UIView alloc]init];
    _LumenDevicesView.translatesAutoresizingMaskIntoConstraints = false;
    _LumenDevicesView.backgroundColor = [[UIColor purpleColor]colorWithAlphaComponent:.001];
    _LumenDevicesView.alpha = 0;
    _LumenDevicesView.layer.cornerRadius = 3;
    _LumenDevicesView.layer.shadowColor = [UIColor blackColor].CGColor;
    _LumenDevicesView.layer.shadowOpacity = .22f;
    _LumenDevicesView.layer.shadowOffset =CGSizeMake(8.0f, 8.0f);
    _LumenDevicesView.layer.shadowRadius = 5.0f;
    _LumenDevicesView.layer.masksToBounds = NO;
    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
   // blurEffectView.translatesAutoresizingMaskIntoConstraints = false;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.alpha =  .16;
    
    
    [_LumenDevicesView addSubview:blurEffectView];
    [self.view addSubview:_LumenDevicesView];
    
    [blurEffectView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [blurEffectView.topAnchor constraintEqualToAnchor:_LumenDevicesView.topAnchor].active = TRUE;
    [blurEffectView.widthAnchor constraintEqualToAnchor:_LumenDevicesView.widthAnchor].active = TRUE;
    [blurEffectView.heightAnchor constraintEqualToConstant:50].active = TRUE;
    
    
    [_LumenDevicesView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-30].active = TRUE;
    [_LumenDevicesView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:.55].active = TRUE;
    [_LumenDevicesView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:44].active = TRUE;
    [_LumenDevicesView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    [self.view layoutIfNeeded];
    
    
    _LumenDeviceTBView = ({   UITableView *tableView = [[UITableView alloc] init];
        tableView.translatesAutoresizingMaskIntoConstraints = false;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.layer.masksToBounds = YES;
        tableView.layer.cornerRadius = 3;
        tableView.delegate = self;
        tableView.scrollEnabled = YES;
        tableView.userInteractionEnabled = YES;
        tableView.dataSource = self;
        tableView.opaque = YES;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = YES;
        tableView.showsVerticalScrollIndicator = NO;
        tableView;
    });
    _LumenDeviceTBView.alpha = .006;
    
    [self.view addSubview:_LumenDeviceTBView];
    
    [_LumenDeviceTBView.topAnchor constraintEqualToAnchor:_LumenDevicesView.topAnchor constant:10].active = TRUE;
    [_LumenDeviceTBView.widthAnchor constraintEqualToAnchor:_LumenDevicesView.widthAnchor constant:-10].active = TRUE;
    [_LumenDeviceTBView.heightAnchor constraintEqualToAnchor:_LumenDevicesView.heightAnchor constant:-5].active = TRUE;
    [_LumenDeviceTBView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    
    
    
    _VBFButton = [[VBFPopFlatButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width/2)-34, _LumenDevicesView.frame.size.height+160, 50, 50) buttonType:buttonAddType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    
    _VBFButton.alpha = .75;
    _VBFButton.lineThickness = 3;
    _VBFButton.roundBackgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67];
    _VBFButton.tintColor = [UIColor whiteColor];
    _VBFButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _VBFButton.layer.shadowOpacity = .22f;
    _VBFButton.layer.shadowOffset =CGSizeZero;
    _VBFButton.layer.shadowRadius = 5.0f;
    _VBFButton.layer.masksToBounds = NO;
    
    [_VBFButton addTarget:self action:@selector(AddLumen:) forControlEvents:UIControlEventTouchUpInside];
    
    //Nice Hover Shadow for button
    /*CGRect ovalRect = CGRectMake(0.0f, _VBFButton.frame.size.height + 105, _VBFButton.frame.size.width - 25, 10);
     UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
     _VBFButton.layer.shadowPath = path.CGPath;*/
    
    _ButtonFrameCopy = _VBFButton.frame;
    _ButtonFrameCopy.origin.y += -80;
    // [_VBFButton setFrame:_ButtonFrameCopy];
    
    [self.view addSubview:_VBFButton];
    
    _VBFButton2 = [[VBFPopFlatButton alloc] initWithFrame:CGRectMake((_VBFButton.center.x) + 84,_VBFButton.center.y - 75 , 30, 30) buttonType:buttonMinusType buttonStyle:buttonRoundedStyle animateToInitialState:YES];
    
    _VBFButton2.lineThickness = 3;
    _VBFButton2.roundBackgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67];
    _VBFButton2.tintColor = [UIColor whiteColor];
    _VBFButton2.layer.shadowColor = [UIColor blackColor].CGColor;
    _VBFButton2.layer.shadowOpacity = .22f;
    _VBFButton2.layer.shadowOffset =CGSizeZero;
    _VBFButton2.layer.shadowRadius = 5.0f;
    _VBFButton2.layer.masksToBounds = NO;
    
    /* CGRect ovalRect = CGRectMake(0.0f, _VBFButton2.frame.size.height + 85, _VBFButton2.frame.size.width - 25, 3);
     UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
     _VBFButton2.layer.shadowPath = path.CGPath;*/
    
    [_VBFButton2 addTarget:self action:@selector(RemoveLumen:) forControlEvents:UIControlEventTouchUpInside];
    
    _VBFButton2.alpha = .99;
    [self.view addSubview:_VBFButton2];
    

    
    
   // [self ButtonFloat:_VBFButton];
   // [self ButtonFloat:_VBFButton2];
    
    [self.view layoutIfNeeded];
    [_LumenDevicesView updateConstraints];
    
    /*  [UIView animateWithDuration:7.0 animations:^{
     _LumenDevicesView.alpha = .56;
     _VBFButton2.alpha = 1;
     [self.view layoutIfNeeded];
     }];*/
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"NOTIFICATION_2" object:nil];
    
    
    
    [super viewDidLoad];
}
#warning  Make NOtification For Main VC to Side VC

#pragma NSNotification Center Check
-(void) receivedNotification:(NSNotification*) notification
{
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _VBFButton.userInteractionEnabled = YES;
        [_VBFButton addTarget:self action:@selector(AddLumen:) forControlEvents:UIControlEventTouchUpInside];
        [self.view setNeedsDisplay];
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma RESideMenu Reveal
-(void)handleConnectedDevices:(UINavigationItem*)sender{
    [self.sideMenuViewController presentLeftMenuViewController];
    if (_MenuVBF.currentButtonType == buttonMenuType) {
        [_MenuVBF animateToType:buttonCloseType];
    }else{
        [_MenuVBF animateToType:buttonMenuType];
    }}
#pragma Float Ability
-(void)ButtonFloat:(VBFPopFlatButton*)button{
    
    [UIView animateWithDuration:3.0
                          delay:0.0
                        options: UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         button.center = CGPointMake(button.center.x,button.center.y + 10);
                     }
                     completion:NULL];
}
#pragma Current Wifi
- (NSString *)wifiName{
    //Doesnt work with simulator
    NSString *wifiName = @"Not Found";
    CFArrayRef interfaces = CNCopySupportedInterfaces();
    if (interfaces)
    {
        CFDictionaryRef networkDetails = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(interfaces, 0));
        if (networkDetails)
        {
            wifiName = (NSString *)CFDictionaryGetValue(networkDetails, kCNNetworkInfoKeySSID);
            CFRelease(networkDetails);
        }
    }
    NSLog(@"Wifi Name : %@" , wifiName);
    return wifiName;
}
#pragma NetworkInfo Delegate Required
-(void)dataFromOnboard:(NSMutableArray *)Networkdata {
    
    _NetworkObjects = [NSMutableArray arrayWithArray:Networkdata];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    _SelectedNetwork = [Networkdata objectAtIndex:0];
    _Password = [Networkdata objectAtIndex:1];
   
    if ((_SelectedNetwork.length > 0)&&(_Password.length > 0 ))
    {
        _didEnterNetworkInfo = TRUE;
    }
    NSLog(@"Network : %@",_SelectedNetwork);
    NSLog(@"Password : %@", _Password);
    NSLog(@"Valid Network Info Entered : %d", _didEnterNetworkInfo);

    if (_didEnterNetworkInfo) {
      dispatch_async(dispatch_get_main_queue(), ^{
  
          [RKDropdownAlert title:@"Lumen Connected" message:[NSString stringWithFormat:@"Your Lumen Device is now connected to %@", _SelectedNetwork] backgroundColor:nil textColor:nil time:5 delegate:self];
          
          
          
           });
    }
         });
}
-(void)NetworkInfoPassed:(BOOL)Passed{
    if (Passed) {
        NSLog(@"Shit should be happening");
    }
}
#pragma Delegate MEthods for DROPWDOWN POP UP
- (BOOL)dropdownAlertWasTapped:(RKDropdownAlert*)alert {
    NSLog(@"Tapped");
    return YES;
}

- (BOOL)dropdownAlertWasDismissed {
    NSLog(@"Dismissed");
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [RKDropdownAlert title:@"Next Steps" message:[NSString stringWithFormat:@"Complete your Lumen Setup by pressing the add button and entering details"] backgroundColor:nil textColor:nil time:5 delegate:self];
    });

    
    

    return YES;
}
-(void)AddLumen:(VBFPopFlatButton*)sender{
    if (_NetINFO.length > 3) {

        NSLog(@"Network Infor Created");
        if (_VBFButton.currentButtonType == buttonAddType) {
            
            
            _progressView = [[M13ProgressViewRing alloc]init];
            //  _progressView.frame = CGRectMake(CGRectGetMinX(_VBFButton.frame) - 36.2, CGRectGetMinY(_VBFButton.frame) - 33, 150, 150);
            _progressView.frame = CGRectMake(0, 0, 100, 100);
            _progressView.center = _VBFButton.center;
            // _progressView.translatesAutoresizingMaskIntoConstraints = false;
            _progressView.primaryColor = [[UIColor blueColor]colorWithAlphaComponent:.45];
            [_progressView setShowPercentage:NO];
            
            [self.view addSubview:_progressView];
            
            [_progressView setIndeterminate:YES];
            
            /* static dispatch_once_t onceToken;
             dispatch_once(&onceToken, ^{
             [self AddLumen];
             });*/
        }
        
        
        //NVActivityIndicatorView
        if (_VBFButton.currentButtonType != buttonFastForwardType) {
            
            //If no hub present pop up to connect
            EmptyFlameViewController *EVC = [[EmptyFlameViewController alloc]init];
            EVC.delegate = self;
            UINavigationController *EFVC = [[UINavigationController alloc]initWithRootViewController:EVC];
            
            [self presentViewController: EFVC animated:YES completion:nil];
            
            [_VBFButton animateToType:buttonFastForwardType];
        }else
        {
            [_VBFButton animateToType:buttonAddType];
        }
        
    }else{
        NSLog(@"NEtwork stuff not entered");
        _progressView = [[M13ProgressViewRing alloc]init];
        //  _progressView.frame = CGRectMake(CGRectGetMinX(_VBFButton.frame) - 36.2, CGRectGetMinY(_VBFButton.frame) - 33, 150, 150);
        _progressView.frame = CGRectMake(0, 0, 150, 150);
        _progressView.center = _VBFButton.center;
        // _progressView.translatesAutoresizingMaskIntoConstraints = false;
        _progressView.primaryColor = [[UIColor blueColor]colorWithAlphaComponent:.45];
        [_progressView setShowPercentage:NO];
        
        [self.view addSubview:_progressView];
        
        [_progressView setIndeterminate:YES];
        
        NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
        paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping   ;
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"We unfortunately cannot locate a hub at this time..." attributes:@{NSFontAttributeName : [UIFont fontWithName: @"AvenirNext-UltraLightItalic" size:24], NSForegroundColorAttributeName : [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineOne = [[NSAttributedString alloc] initWithString:@"To connect a new hub/light,\nplease go into System Prefrences" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"AvenirNext-UltraLightItalic" size:20], NSForegroundColorAttributeName : [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineTwo = [[NSAttributedString alloc] initWithString:@"Then connect to the Network Labeled ESP" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"AvenirNext-UltraLightItalic" size:18],  NSForegroundColorAttributeName : [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1], NSParagraphStyleAttributeName : paragraphStyle}];
        
        NSAttributedString *lineThree = [[NSAttributedString alloc] initWithString:@"After, you have connected please return here, and enter the Network Name" attributes:@{NSFontAttributeName : [UIFont fontWithName: @"AvenirNext-UltraLightItalic" size:16],  NSForegroundColorAttributeName : [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1], NSParagraphStyleAttributeName : paragraphStyle}];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_circle"]];
        imageView.frame = CGRectMake(0, 0, 50, 50);
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.attributedText = title;
        
        
        UILabel *lineOneLabel = [[UILabel alloc] init];
        lineOneLabel.numberOfLines = 0;
        lineOneLabel.attributedText = lineOne;
        
        //
        
        UILabel *lineTwoLabel = [[UILabel alloc]init];
        lineTwoLabel.numberOfLines = 0;
        lineTwoLabel.attributedText = lineTwo;
        
        UILabel *lineThreeLabel = [[UILabel alloc]init];
        lineThreeLabel.numberOfLines= 0;
        lineThreeLabel.attributedText = lineThree;
        
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 55)];
        customView.backgroundColor = [UIColor lightGrayColor];
        customView.layer.cornerRadius = 4;
        
        
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 230, 35)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.placeholder = @"Lumen SSID";
        [customView addSubview:tf];
        
        CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [button setTitle:@"Connect" forState:UIControlStateNormal];
        button.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1];
        button.layer.cornerRadius = 10;
        self.Popup =[[CNPPopupController alloc] initWithContents:@[imageView,titleLabel, lineOneLabel, lineTwoLabel, lineThreeLabel, customView, button]];
        self.Popup.theme = [CNPPopupTheme defaultTheme];
        self.Popup.delegate = self;
        [self.Popup presentPopupControllerAnimated:YES];
        
        button.selectionHandler = ^(CNPPopupButton *button){
            
            _progressView.alpha = 0;
            _progressView.userInteractionEnabled = NO;
            [self.Popup dismissPopupControllerAnimated:YES];
            
            //After we dismiss this Popup we need create yet another that displays the Networks that,
            //Are taken by dele method from the Lumen WebPge and presented in TableView form for selection
            [self selectNetworkPopUp];
            
            NSLog(@"Block for button: %@", button.titleLabel.text);
        };

    }
//Notification Center?
}
-(void)selectNetworkPopUp{
    
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
        tableView.layer.cornerRadius = 3;
        tableView.delegate = self;
        tableView.scrollEnabled = YES;
        tableView.userInteractionEnabled = YES;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:.56];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = YES;
        tableView;
    });
    
    [customView addSubview:_NetworkTBView];
    _NetworkTBView.frame = CGRectMake(0, 0, customView.frame.size.width, customView.frame.size.height);
    //NetworkTBView.frame = CGRectMake(0, 0, 250, 220);
    _NetworkTBView.center = customView.center;
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, 230, 35)];
    //tf.borderStyle = UITextBorderStyleRoundedRect;
    tf.borderStyle = UITextBorderStyleNone;
    tf.placeholder = @"Network Password";
    tf.backgroundColor = [UIColor clearColor];
    tf.textColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:1];
    tf.textAlignment = NSTextAlignmentCenter;
    [customView2 addSubview:tf];
    
    
    CNPPopupButton *button = [[CNPPopupButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [button setTitle:@"Connect" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:.56];
    button.layer.cornerRadius = 10;
    self.Popup =[[CNPPopupController alloc] initWithContents:@[imageView, titleLabel, customView, customView2, button]];
    self.Popup.theme = [CNPPopupTheme defaultTheme];
    self.Popup.delegate = self;
    [self.Popup presentPopupControllerAnimated:YES];
    
    button.selectionHandler = ^(CNPPopupButton *button){
        
        [self.Popup dismissPopupControllerAnimated:YES];
        NSLog(@"Block for button: %@", button.titleLabel.text);
    };

}
#pragma NetworkTableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_LumenDeviceTBView]) {
        
        
    }else{
        [self resignFirstResponder];
        [self nextResponder];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_LumenDeviceTBView]) {
        return 140;
    }else{
        return 24;
}
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    if ([tableView isEqual:_LumenDeviceTBView]) {
        if ([[_LumenDict valueForKey:@"name"]length] > 3) {
            
            return [_LumenNames count];
        }
        //return 3;
        }else if ([tableView isEqual:_NetworkTBView]){
        return 1;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    if ([tableView isEqual:_LumenDeviceTBView]) {
        
    
            LumenTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[LumenTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            [cell setTitle:[_LumenDict objectForKey:@"name"]];
            [cell setLocation:[_LumenDict objectForKey:@"location"]];
            [cell setTime:[_LumenDict objectForKey:@"date"]];
          
              [cell setScent1:[_LumenDict objectForKey:@"scent1"]];
            cell.delegate = self;
            
            
        }
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:21];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
            cell.selectedBackgroundView = [[UIView alloc] init];
            cell.textLabel.text = @"Network Names";
        
    }
        return cell;
    }
}
#pragma NewLumen Delegate MEthods Required
-(void)ProgressViewDismissed:(BOOL)finished{
    if (finished) {
        [_progressView setAlpha:0];
        [_progressView setUserInteractionEnabled:NO];
        [_VBFButton animateToType:buttonAddType];
    }
}
- (void)LumenInfoPassed:(NSArray *)array{
    _LumenObjects = [NSMutableArray arrayWithArray:array];
    
    [_LumenNames insertObject:[_LumenObjects objectAtIndex:0] atIndex:0];
    NSLog(@"_Lumen Names : %@", _LumenNames);
    
    
    [_LumenDict setValue:[_LumenObjects objectAtIndex:0] forKey:@"name"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:1] forKey:@"location"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:2] forKey:@"timerop"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:3] forKey:@"date"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:4] forKey:@"time"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:5] forKey:@"scent1"];
    [_LumenDict setValue:[_LumenObjects objectAtIndex:6] forKey:@"scent2"];
    
    NSLog(@"Location in Dictionary : %@",[_LumenDict objectForKey:@"location"]);
    
    NSDictionary * dict =[NSDictionary dictionaryWithObject:[_LumenObjects objectAtIndex:0] forKey:@"name"];
    NSNotification * notification =[[NSNotification alloc]initWithName:@"NOTIFICATION_3" object:nil userInfo:dict];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
     //Tries to esnure the the first string for the horizontal selector is the String for location the user entered
    
    for (int x = 0; x <=[_PlacesArray count]-1; x++) {
        if ( ([[_LumenDict objectForKey:@"location"] isEqualToString:[_PlacesArray objectAtIndex:x]])) {
            
            NSLog(@"THEY ARE EQUALL!!!!!");
            NSObject *temp = [_PlacesArray objectAtIndex:x];
            
            [_PlacesArray removeObject:[_PlacesArray objectAtIndex:x]];
             [_PlacesArray insertObject:temp atIndex:0];
            [_hSelView4 reloadData];
        }
    }
}
#pragma Optional
-(void)LumenCreated:(BOOL)finished{
    if (finished) {
       
    //Always check How many Lumen Devices Have been Created
    //Just Create UIView to Hold Table View
    //Create TableView wth custom Cell that has labels,images
      //  [_LumenDeviceTBView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        [_LumenDeviceTBView reloadData];
        [_hSelView4 selectIndex:0]; 
        //ONly add Second Button and LumenHolderView Once...
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            

            });
    }
}
- (void)dataFromController:(NSString *)data
{
    
}
-(void)RemoveLumen:(VBFPopFlatButton*)sender{
    NSLog(@"Lumen Removed");
    if ([_LumenNames count]) {
        [_LumenNames removeObjectAtIndex:[_LumenNames count]-1];
        
    }else{
        NSLog(@"There are no Lumens to delete");
        
    }

    //[_LumenDeviceTBView reloadData];
    [_LumenDeviceTBView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
#pragma mark - EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    return [_PlacesArray count];
}
- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    
            return [NSString stringWithFormat:@"%@",[_PlacesArray objectAtIndex:index]];
}

- (EHHorizontalViewCell *)selectionView:(EHHorizontalSelectionView *)selectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EHHorizontalLineViewCell *cell = [[EHHorizontalLineViewCell alloc]init];
    cell.titleLabel.text = [_PlacesArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)horizontalSelection:(EHHorizontalSelectionView * _Nonnull)hSelView didSelectObjectAtIndex:(NSUInteger)index{
    
    NSLog(@"Object at Inedx : %@", [_PlacesArray objectAtIndex:index]);
    if ([[_PlacesArray objectAtIndex:index] isEqualToString:[_LumenDict objectForKey:@"location"]]) {
        
        [_LumenDeviceTBView setAlpha:1];
    }else{
        [_LumenDeviceTBView setAlpha:0];
    }
}
-(BOOL)prefersStatusBarHidden{
    return  YES;
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
#pragma LumenTableViewCellDelegat Meth
-(void)LoadLumenInfoScreen:(VLAFloatingViewController *)controller{

    controller = [[VLAFloatingViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];
#warning Think about passsing information from cell or from LumenInfoPassed to populate slide up view
}

@end
