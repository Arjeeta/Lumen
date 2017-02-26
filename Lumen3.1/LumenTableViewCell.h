//
//  LumenTableViewCell.h
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMEmojiableBtn.h"
#import "MKDropdownMenu.h"
#import "EPieChart.h"
#import "UICountingLabel.h"
#import "Chameleon.h"
#import "JTMaterialSwitch.h"
#import "VLAFloatingViewController.h"   

@protocol LumenTableViewCellDelegate <NSObject>
-(void)LoadLumenInfoScreen:(VLAFloatingViewController*)controller;
@end



@interface LumenTableViewCell : UITableViewCell
@property (nonatomic, copy) void (^cellShouldBeRemoved)();
@property (nonatomic, copy) void (^cellDetailActivate)();
@property (nonatomic, retain)id <LumenTableViewCellDelegate> delegate;
@property (nonatomic, copy)VLAFloatingViewController *Floating;
+(CGFloat)defaultCellHeight;
-(void)setTitle:(NSString*)title;
-(void)setLocation:(NSString*)location;
-(void)setTime:(NSString*)setTime;
-(void)setScent1:(NSString*)scent;
//-(void)setScent2:(NSString*)scent;
-(void)changeTime:(NSString*)time;
-(void)setButane:(int)level;
-(void)setCurrent:(int)level;






@end
