//
//  EmptyFlameViewController.m
//  Lumen3.0
//
//  Created by Preston Perriott on 12/27/16.
//  Copyright © 2016 Preston Perriott. All rights reserved.
//

#import "EmptyFlameViewController.h"

@interface EmptyFlameViewController ()

@end

@implementation EmptyFlameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAppearance];
    
    
    _BGImage = [UIImage imageNamed:@"gradient-blue.png"];
    _BGImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _BGImageView.contentMode = UIViewContentModeScaleAspectFill;
    _BGImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _BGImageView.layer.masksToBounds = TRUE;
    _BGImageView.image = _BGImage;
   // [self.view addSubview:_BGImageView];

    _aView = [[UIView alloc]init];
    _aView.translatesAutoresizingMaskIntoConstraints = false;
    _aView.layer.cornerRadius = 5;
    _aView.backgroundColor = [UIColor purpleColor];
    _aView.userInteractionEnabled = TRUE;
    
    [self.view addSubview:_aView];
    
    [_aView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = TRUE;
    [_aView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:-10].active = TRUE;
    [_aView.widthAnchor constraintEqualToAnchor:self.view.widthAnchor constant:-10].active = TRUE;
    [_aView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:3/4].active = TRUE;
    
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(Back:)];
}
- (void)setupAppearance
{
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [UINavigationBar appearance].translucent = YES;
    //[UINavigationBar appearance].barTintColor = [UIColor blueColor];
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [UITableView appearance].backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67];
    
    [BOTableViewSection appearance].headerTitleColor = [UIColor whiteColor];
    [BOTableViewSection appearance].footerTitleColor = [UIColor lightGrayColor];
    
    [BOTableViewCell appearance].mainColor = [UIColor lightGrayColor];
    [BOTableViewCell appearance].secondaryColor = [UIColor lightGrayColor];
    [BOTableViewCell appearance].selectedColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67];
}
-(void)Back:(UINavigationItem*)sender{
    if ([_delegate respondsToSelector:@selector(ProgressViewDismissed:)]) {
        [_delegate ProgressViewDismissed:YES];
    }
    
[self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  }
- (void)setup {
    self.title = @"L U M E N";
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Device Name & Location" handler:^(BOTableViewSection *section) {
        [section addCell:[BOTextTableViewCell cellWithTitle:@"Name" key:@"text" handler:^(BOTextTableViewCell *cell) {
            cell.textField.placeholder = @"Enter text";
            cell.inputErrorBlock = ^(BOTextTableViewCell *cell, BOTextFieldInputError error) {
                [weakSelf showInputErrorAlert:error];
            };
        }]];
        
        [section addCell:[BOChoiceTableViewCell cellWithTitle:@"Location" key:@"text2" handler:^(BOChoiceTableViewCell *cell) {
            cell.options = @[@"Living Room", @"Kitchen", @"Bedroom", @"Attic", @"Bathroom"];
            cell.footerTitles = @[@"Living Room", @"Kitchen", @"Bedroom", @"Attic", @"Bathroom"];
        }]];
           }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Date & Time" handler:^(BOTableViewSection *section) {
        
        [section addCell:[BOSwitchTableViewCell cellWithTitle:@"Timer" key:@"bool_1" handler:nil]];
        
        
        [section addCell:[BODateTableViewCell cellWithTitle:@"Date" key:@"date" handler:^(BODateTableViewCell *cell) {
            cell.visibilityKey = @"bool_1";
            cell.visibilityBlock = ^BOOL(id settingValue) {
                return [settingValue boolValue];
            };
            
        }]];
        
        [section addCell:[BOTimeTableViewCell cellWithTitle:@"Time" key:@"time" handler:^(BOTimeTableViewCell *cell) {
            cell.datePicker.minuteInterval = 5;
            cell.visibilityKey = @"bool_1";
            cell.visibilityBlock = ^BOOL(id settingValue) {
                return [settingValue boolValue];
            };

        }]];
        
            }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Fragrances" handler:^(BOTableViewSection *section) {
    
    [section addCell:[BOChoiceTableViewCell cellWithTitle:@"Major Scent" key:@"scent_1" handler:^(BOChoiceTableViewCell *cell) {
        cell.options = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
        cell.footerTitles = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
    }]];
    
    [section addCell:[BOChoiceTableViewCell cellWithTitle:@"Minor Scent" key:@"scent_2" handler:^(BOChoiceTableViewCell *cell) {
        cell.options = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
        //  cell.destinationViewController = [OptionsTableViewController new];
    }]];

    }]];
    
    [self addSection:[BOTableViewSection sectionWithHeaderTitle:@"Section 3" handler:^(BOTableViewSection *section) {
        
        [section addCell:[BOButtonTableViewCell cellWithTitle:@"Create" key:nil handler:^(BOButtonTableViewCell *cell) {
            cell.actionBlock = ^{
                [weakSelf showTappedButtonAlert];
            };
        }]];
        
        section.footerTitle = @"a Lumen Product";
    }]];
}

- (void)presentAlertControllerWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showInputErrorAlert:(BOTextFieldInputError)error {
    NSString *message;
    
    switch (error) {
        case BOTextFieldInputTooShortError:
            message = @"The text is too short";
            break;
            
        case BOTextFieldInputNotNumericError:
            message = @"Please input a valid number";
            break;
            
        default:
            break;
    }

    if (message) {
        [self presentAlertControllerWithTitle:@"Error" message:message];
    }
}

- (void)showTappedButtonAlert {
   // [self presentAlertControllerWithTitle:@"Button tapped!" message:nil];
    if ([_delegate respondsToSelector:@selector(ProgressViewDismissed:)]) {
        [_delegate ProgressViewDismissed:YES];
   
        if ([_delegate respondsToSelector:@selector(dataFromController:)]) {
            [_delegate dataFromController:@"Data Passed"];
    }
}
        [self dismissViewControllerAnimated:YES completion:nil];
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSString *tf1  = [defaults stringForKey:@"text"];
    
    
    NSString *tf2 = [defaults stringForKey:@"text2"];
    NSInteger newnew = [tf2 integerValue];
    NSArray *RoomArray = @[@"Living Room", @"Kitchen", @"Bedroom", @"Attic", @"Bathroom"];
    NSString *realRoom = [RoomArray objectAtIndex:newnew];
    NSLog(@"THE REAL SCENT : %@", realRoom);
    
    
    NSString *timerOp = [defaults objectForKey:@"bool_1"];
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[defaults objectForKey:@"date"]
        dateStyle:NSDateFormatterShortStyle
    timeStyle:NSDateFormatterShortStyle];
    
    NSString *time = [defaults objectForKey:@"time"];
    NSString *scent1 = [defaults stringForKey:@"scent_1"];
    NSLog(@"Selected Scent : %@", scent1);
    
    NSInteger newint = [scent1 integerValue];
    NSArray *ScentsArray = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
    NSString *realScent = [ScentsArray objectAtIndex:newint];
    NSLog(@"THE REAL SCENT : %@", realScent);
    //Should pass realScent instead of scent1
    //Also should set the scent1 default correctly
    
    //set NSuser defualts
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //[prefs setObject:[_SelectedNetworkItems lastObject] forKey:@"networkInfo"];
    [prefs setObject:realScent forKey:@"scent_1"];

    NSString *scent2 = [defaults stringForKey:@"scent_2"];
    
    //Maybe pass it as a dictionary instead!!!!!
    NSArray *LumenObjects = [NSArray arrayWithObjects:tf1,realRoom,timerOp,dateString,time,realScent,scent2, nil];
    
    if ([_Gistdelegate respondsToSelector:@selector(dataFromNewLumenForDZN:)]) {
        [_Gistdelegate dataFromNewLumenForDZN:LumenObjects];
    }
    
    if ([_delegate respondsToSelector:@selector(LumenInfoPassed:)]) {
        [_delegate LumenInfoPassed:LumenObjects];
        
        if ([_delegate respondsToSelector:@selector(LumenCreated:)]) {
            [_delegate LumenCreated:TRUE];
        }
    }
}
@end

