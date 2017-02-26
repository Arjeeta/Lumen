//
//  ConnectedDevicesVC.m
//  Lumen3.0
//
//  Created by Preston Perriott on 12/22/16.
//  Copyright © 2016 Preston Perriott. All rights reserved.
//

#import "ConnectedDevicesVC.h"
#import "UIScrollView+EmptyDataSet.h"


@interface ConnectedDevicesVC () <UITableViewDelegate, UITableViewDataSource, LumenGistDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, readwrite, strong) UITableView *tableView;



@end

@implementation ConnectedDevicesVC


-(instancetype)init{
    self = [super init];
    if (self) {
        _EVC = [[EmptyFlameViewController alloc]init];
        _EVC.Gistdelegate = self;
    }
    return  self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 1.5) / 2.5f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = YES;
        tableView.emptyDataSetSource = self;
        tableView.emptyDataSetDelegate = self;
        tableView;
    });
    
    //self.aryMenu = [[NSMutableArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"NOTIFICATION_3" object:nil];
    
    [self.view addSubview:_tableView];
}
-(void) receivedNotification:(NSNotification*) notification
{
    NSString * name =notification.name;
    //notification userinfo
    NSDictionary * info =notification.userInfo;
    
    NSLog(@"Received Notification with name =%@",name);
    NSLog(@"Information =%@",info);
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.view setNeedsDisplay];
        [self.aryMenu addObject:name];
        [_tableView reloadData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.aryMenu count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* cellIdentifier = @"ripta.cell.menu";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"AvenirNext-Italic" size:30];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    self.aryMenu = [_aryMenu objectAtIndex:0];

    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = self.aryMenu[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSLog(@"Selected %ld", (long)indexPath.row);
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    return 54;
    
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.aryMenu.count > 0) {
        return nil;
    }
    
    NSString *text = @"You do not have any saved devices, please add a Lumen to access your Lumen devices.";
    UIColor *textColor = [UIColor colorWithRed:125/255.0 green:127/255.0 blue:127/255.0 alpha:1.0];
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    paragraph.lineSpacing = 2.0;
    
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    [attributes setObject:paragraph forKey:NSParagraphStyleAttributeName];
    
    return [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
 [self.tableView reloadEmptyDataSet];
}

#pragma Delegate mEthod for Gist
-(void)dataFromNewLumenForDZN:(NSArray*)array{
    
    self.aryMenu = [array mutableCopy];
    [self.tableView reloadData];
    [self.view setNeedsLayout];
    NSLog(@"ARRAY MENU FROM METHOD : %@", self.aryMenu);
    
}

@end
