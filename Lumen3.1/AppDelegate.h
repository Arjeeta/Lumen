//
//  AppDelegate.h
//  Lumen3.1
//
//  Created by Preston Perriott on 1/23/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AFNetworking.h"
#import "NetworkRequestHandler.h"
#import "Networks.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "RESideMenu.h"
#import "CNPPopupController.h"
#import "ViewController.h"
#import "ConnectedDevicesVC.h"
#import "SKSplashView.h"
#import "SKSplashIcon.h"


@protocol NetworkInfoDelegate <NSObject>

@required
-(void)dataFromOnboard:(NSArray*)Networkdata;
-(void)NetworkInfoPassed:(BOOL)Passed;


@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


@property (strong, nonatomic)UITableView *NetworkTBView;

@property (strong, nonatomic)UITextField *Networktf;
@property (strong, nonatomic)SKSplashView *splashView;
@property (strong, nonatomic)CNPPopupController *PopupNet;
@property (strong, nonatomic)NSMutableArray *SelectedNetworkItems;
@property (strong, nonatomic)NSMutableArray *CompiledData;

@property (strong, nonatomic)NSMutableArray *NetworkNames;
@property (retain, nonatomic)id<NetworkInfoDelegate> Netdelegate;



- (void)saveContext;


@end

