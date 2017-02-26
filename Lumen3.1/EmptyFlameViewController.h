//
//  EmptyFlameViewController.h
//  Lumen3.0
//
//  Created by Preston Perriott on 12/27/16.
//  Copyright © 2016 Preston Perriott. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bohr.h"
#import "ViewController.h"
#import "ConnectedDevicesVC.h"


@protocol LumenGistDelegate <NSObject>

@optional
-(void)dataFromNewLumenForDZN:(NSArray*)array;

@end

//Add protocol to EmptyVC
@protocol NewLumenDelegate <NSObject>

@optional
-(void)dataFromController:(NSString*)data;
-(void)LumenCreated:(BOOL)finished;
@required
-(void)LumenInfoPassed:(NSArray*)array;
-(void)ProgressViewDismissed:(BOOL)finished;

@end

@interface EmptyFlameViewController : BOTableViewController
@property (strong, nonatomic)UIImage *BGImage;
@property (strong, nonatomic)UIImageView *BGImageView;
@property (strong, nonatomic)UIView *aView;


@property BOOL fin;
@property (nonatomic, retain) NSString *data;
@property (weak, nonatomic)id<NewLumenDelegate> delegate;

@property (strong, nonatomic)id<LumenGistDelegate> Gistdelegate;

@end
