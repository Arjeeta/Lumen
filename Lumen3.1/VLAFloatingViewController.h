//
//  LumenTableViewCell.m
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBChartView.h"
#import "JBBarChartView.h"
#import "JBChartHeaderView.h"
#import "JBBarChartFooterView.h"
#import "JBChartInformationView.h"

@interface VLAFloatingViewController : UIViewController
@property (nonatomic, retain, readonly) UIView *viewContent;
@property (nonatomic, retain, readonly) UINavigationItem *navItem;
@property (nonatomic, strong) JBBarChartView *FuelChart;
- (void)exit;
- (void)saveAndExit;
@end
