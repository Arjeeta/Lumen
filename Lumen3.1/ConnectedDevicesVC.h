//
//  ConnectedDevicesVC.h
//  Lumen3.0
//
//  Created by Preston Perriott on 12/22/16.
//  Copyright © 2016 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyFlameViewController.h"
#import "ViewController.h"


@class EmptyFlameViewController;
@interface ConnectedDevicesVC : UIViewController
@property (strong, nonatomic)NSMutableArray *aryMenu;
@property (nonatomic) EmptyFlameViewController *EVC;
@end
