//
//  ViewController.h
//  Lumen3.1
//
//  Created by Preston Perriott on 1/23/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "RKDropdownAlert.h"
#import "CNPPopupController.h"
#import "VBFPopFlatButton.h"
#import "M13ProgressViewRing.h"
#import "AppDelegate.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "EmptyFlameViewController.h"
#import "LumenTableViewCell.h"
#import <EHHorizontalSelectionView/EHHorizontalSelectionView.h>
#import "VLAFloatingViewController.h"


@interface ViewController : UIViewController

#pragma MainView
@property (strong, nonatomic)UIImage *BGImage;
@property (strong, nonatomic)UIImageView *BGImageView;
@property (strong, nonatomic)VBFPopFlatButton *VBFButton;
@property (strong, nonatomic)VBFPopFlatButton *MenuVBF;
@property (assign, nonatomic)CGRect ButtonFrameCopy;

#pragma Added Views
@property (strong, nonatomic)VBFPopFlatButton *VBFButton2;
@property (nonatomic, retain)M13ProgressViewRing *progressView;
@property (strong, nonatomic)CNPPopupController *Popup;
@property (strong, nonatomic)UITableView *NetworkTBView;

@property(strong, nonatomic)UIView *LumenDevicesView;
@property (strong, nonatomic)UITableView *LumenDeviceTBView;

@property (nonatomic, strong) EHHorizontalSelectionView * hSelView4;



#pragma Information Objects
@property (strong, nonatomic)NSString *NetINFO;
@property  (strong, nonatomic)NSMutableArray *NetworkObjects;

@property (strong, nonatomic)NSString *SelectedNetwork;
@property (strong, nonatomic)NSString *Password;
@property (assign, nonatomic)BOOL didEnterNetworkInfo;

@property (strong, nonatomic)NSMutableArray *PlacesArray;

@property (strong, nonatomic)NSMutableDictionary *LumenDict;
@property (strong, nonatomic)NSMutableArray *LumenObjects;

@property (strong, nonatomic)NSMutableArray *LumenNames;



@end

