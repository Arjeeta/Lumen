//
//  LumenTableViewCell.m
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//


#import "VLAFloatingViewController.h"
#import "Chameleon.h"

CGFloat const MaxBarHeight = 10;
CGFloat const MinBarHeight = 5;
CGFloat const NumOfBars = 7;


@interface VLAFloatingViewController () <JBBarChartViewDelegate, JBBarChartViewDataSource>

@property (nonatomic,strong)NSArray *ChartData;
@property (nonatomic, strong)NSArray *DailySymbols;
@property (nonatomic, strong)JBChartInformationView *informationView;
@property (nonatomic, strong)UILabel *PowerLabel;
@property (nonatomic, strong)UILabel *ScentLabel;
@property (nonatomic, strong)UILabel *InfoLabel;
@property (nonatomic, strong)UIView *viewDivider;
@property (nonatomic, strong)UIView *viewDivider2;
@property (nonatomic, strong)UIView *viewDivider3;






@end

@implementation VLAFloatingViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray *mutableChartData = [NSMutableArray array];
    for (int i=0; i<NumOfBars; i++)
    {
        NSInteger delta = (NumOfBars - fabs((NumOfBars - i) - i)) + 2;
        
       
        float f = (delta * MinBarHeight);
        float g = (delta * MaxBarHeight);
        
        
        [mutableChartData addObject:[NSNumber numberWithFloat:MAX(f, (arc4random_uniform(g)))]];
        
    }
    _ChartData = [NSArray arrayWithArray:mutableChartData];
    _DailySymbols = [[[NSDateFormatter alloc] init] shortWeekdaySymbols];
    
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    _viewContent = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.view.frame)/2) - 40, CGRectGetWidth(self.view.frame), (CGRectGetHeight(self.view.frame)/2) + 40)];
   
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.viewContent.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)].CGPath;
    _viewContent.layer.mask = maskLayer;
    _viewContent.backgroundColor = [[UIColor clearColor]colorWithMinimumSaturation:.5];
    
    UIImage *BGImage = [UIImage imageNamed:@"GradientPlanner.jpg"];
    // _BGImage = [UIImage imageNamed:@"gradient-blue.png"];
    UIImageView *BGImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    BGImageView.contentMode = UIViewContentModeScaleAspectFill;
    BGImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    BGImageView.layer.masksToBounds = TRUE;
    BGImageView.image = BGImage;
    //[_viewContent addSubview:BGImageView];

    
    _viewContent.layer.shadowColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5].CGColor;
    _viewContent.layer.shadowOpacity = 0.5f;
    

    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.alpha =  1.30;
    [blurEffectView setOpaque:NO];
    
   
    
    [_viewContent addSubview:blurEffectView];
    [_viewContent sendSubviewToBack:blurEffectView];
    
    
    [blurEffectView.centerXAnchor constraintEqualToAnchor:_viewContent.centerXAnchor].active = TRUE;
    [blurEffectView.topAnchor constraintEqualToAnchor:_viewContent.topAnchor].active = TRUE;
    [blurEffectView.widthAnchor constraintEqualToAnchor:_viewContent.widthAnchor].active = TRUE;
    [blurEffectView.heightAnchor constraintEqualToAnchor:_viewContent.heightAnchor].active = TRUE;
   
    [self.view addSubview:_viewContent];
    
    
   
    
    UIVibrancyEffect * effect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
    UIVisualEffectView * selectedBackgroundView = [[UIVisualEffectView alloc] initWithEffect:effect];
    selectedBackgroundView.autoresizingMask =
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    selectedBackgroundView.frame = _viewContent.bounds;
    UIView * view = [[UIView alloc] initWithFrame:selectedBackgroundView.bounds];
    view.backgroundColor = [UIColor colorWithWhite:.8f alpha:0.3f];
    view.autoresizingMask =
    UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [selectedBackgroundView.contentView addSubview:view];
    selectedBackgroundView = selectedBackgroundView;
    
    [_viewContent addSubview:selectedBackgroundView];
    
    
    
    
    UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 44)];
    navBar.barTintColor = [[UIColor flatBlueColor]colorWithAlphaComponent:.45];
    
    _navItem = [[UINavigationItem alloc] init];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(exit)];
    _navItem.leftBarButtonItem = leftButton;
    
    //UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveAndExit)];
    //_navItem.rightBarButtonItem = rightButton;
    navBar.items = @[_navItem];
    
    [_viewContent addSubview:navBar];
    
    //MAybe UIVIew Warpper class for chart, so that we has padding on the side, maybe rounded corners

  /*  UIView *Holder =[[UIView alloc]init];
    Holder.translatesAutoresizingMaskIntoConstraints = false;
    Holder.layer.cornerRadius = 4;
    Holder.backgroundColor = [UIColor whiteColor];
    Holder.alpha = .25;
    [_viewContent addSubview:Holder];
    [_viewContent bringSubviewToFront:Holder];
    
    
    [Holder.topAnchor constraintEqualToAnchor:navBar.bottomAnchor constant:8].active = TRUE;
    [Holder.widthAnchor constraintEqualToAnchor:_viewContent.widthAnchor constant:-18].active = TRUE;
    [Holder.bottomAnchor constraintEqualToAnchor:_viewContent.bottomAnchor constant:-8].active = TRUE;
    [Holder.centerXAnchor constraintEqualToAnchor:_viewContent.centerXAnchor].active = TRUE;
    */
    
    _FuelChart = [[JBBarChartView alloc]init];
    _FuelChart.frame = CGRectMake(17, CGRectGetHeight(navBar.frame)-5, CGRectGetWidth(_viewContent.frame)-45, CGRectGetHeight(_viewContent.frame)*.45);
    _FuelChart.dataSource= self;
    _FuelChart.delegate = self;
    _FuelChart.backgroundColor = [UIColor clearColor];
    _FuelChart.tintColor = [UIColor flatBlueColor];
    _FuelChart.minimumValue = 5;
    _FuelChart.headerPadding = 20.0;
    
    
    
    JBChartHeaderView *headerView = [[JBChartHeaderView alloc] initWithFrame:CGRectMake(0, ceil(self.view.bounds.size.height * 0.5) - ceil(80 * 0.5), self.view.bounds.size.width - (10 * 2), 80)];
    headerView.titleLabel.text = @"Fuel Consumption";
    headerView.subtitleLabel.text = @"Weekly Use";
    headerView.titleLabel.textColor = [UIColor whiteColor];
    headerView.subtitleLabel.textColor = [UIColor whiteColor];

    headerView.separatorColor = [UIColor blackColor];
    _FuelChart.headerView = headerView;
    
    JBBarChartFooterView *footerView = [[JBBarChartFooterView alloc] initWithFrame:CGRectMake(10, ceil(_viewContent.bounds.size.height * 0.5) - ceil(25 * 0.5), self.view.bounds.size.width - (10 * 2), 25)];
    footerView.padding = 5;
    footerView.leftLabel.text = [[_DailySymbols firstObject] uppercaseString];
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = [[_DailySymbols lastObject] uppercaseString];
    footerView.rightLabel.textColor = [UIColor whiteColor];
    _FuelChart.footerView = footerView;

    
    [_viewContent addSubview:_FuelChart];
    [_FuelChart reloadDataAnimated:YES];
    
    _informationView = [[JBChartInformationView alloc] initWithFrame:CGRectMake(_viewContent.bounds.origin.x, CGRectGetMaxY(_FuelChart.frame) - 25, _viewContent.bounds.size.width, _viewContent.bounds.size.height - CGRectGetMaxY(_FuelChart.frame))];
    [_viewContent addSubview:self.informationView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo_circle"]];
    imageView.frame = CGRectMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(navBar.frame)+10, 50, 50);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(DismissLumenInfo)];
    
    [singleTap setNumberOfTapsRequired:1];
    [imageView addGestureRecognizer:singleTap];
    
    //[_viewContent addSubview:imageView];
    
    
    _PowerLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_FuelChart.frame)+40, 60, 50)];
    _PowerLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]+2];
    _PowerLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.65];
    _PowerLabel.text = @"P O W E R";
    [_PowerLabel sizeToFit];
    [_viewContent addSubview:_PowerLabel];
    
    _viewDivider = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_PowerLabel.frame)+1.5, CGRectGetWidth(_viewContent.frame)*.8, 1)];
    _viewDivider.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.45];
    _viewDivider.layer.cornerRadius = 4;
    _viewDivider.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewDivider.layer.shadowOpacity = .42f;
    _viewDivider.layer.shadowOffset =CGSizeZero;
    _viewDivider.layer.shadowRadius = 5.0f;
    [_viewContent addSubview:_viewDivider];
    
    _ScentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_viewContent.frame) - 100, CGRectGetMaxY(_viewDivider.frame)+25, 60, 50)];
    _ScentLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]+2];
    _ScentLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.65];
    _ScentLabel.text = @"S C E N T";
    [_ScentLabel sizeToFit];
    [_viewContent addSubview:_ScentLabel];
    
    _viewDivider2 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_ScentLabel.frame)+1.5, CGRectGetWidth(_viewContent.frame)*.8, 1)];
    _viewDivider2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.45];
    _viewDivider2.layer.cornerRadius = 4;
    _viewDivider2.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewDivider2.layer.shadowOpacity = .42f;
    _viewDivider2.layer.shadowOffset =CGSizeZero;
    _viewDivider2.layer.shadowRadius = 5.0f;
    [_viewContent addSubview:_viewDivider2];
    
    _InfoLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, CGRectGetMaxY(_viewDivider2.frame)+25, 60, 50)];
   _InfoLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]+2];
    _InfoLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:.65];
    _InfoLabel.text = @"D A T A ";
    [_InfoLabel sizeToFit];
    [_viewContent addSubview:_InfoLabel];
    
    _viewDivider3 = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_InfoLabel.frame)+1.5, CGRectGetWidth(_viewContent.frame)*.8, 1)];
    _viewDivider3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.45];
    _viewDivider3.layer.cornerRadius = 4;
    _viewDivider3.layer.shadowColor = [UIColor grayColor].CGColor;
    _viewDivider3.layer.shadowOpacity = .42f;
    _viewDivider3.layer.shadowOffset =CGSizeZero;
    _viewDivider3.layer.shadowRadius = 5.0f;
    [_viewContent addSubview:_viewDivider3];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions
- (void)exit{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)saveAndExit {
    
}
-(void)DismissLumenInfo{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma Delegate mEthods for BARCHART
- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView
{
    return [_ChartData count]; // number of bars in chart
}
- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index
{
    return [[_ChartData objectAtIndex:index]floatValue];
}
#pragma DataSource
- (BOOL)shouldExtendSelectionViewIntoHeaderPaddingForChartView:(JBChartView *)chartView
{
    return YES;
}

- (BOOL)shouldExtendSelectionViewIntoFooterPaddingForChartView:(JBChartView *)chartView
{
    return NO;
}
- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    NSNumber *valueNumber = [_ChartData objectAtIndex:index];
    [self.informationView setValueText: [NSString stringWithFormat:@"%d", [valueNumber intValue] ]unitText:nil];
    [self.informationView setTitleText:@"Average"];
    [self.informationView setHidden:NO animated:YES];
    [_PowerLabel setHidden:YES];
    [_viewDivider setHidden:YES];
    [_viewDivider2 setHidden:YES];
    [_ScentLabel setHidden:YES];
    [_InfoLabel setHidden:YES];
   
}

- (void)didDeselectBarChartView:(JBBarChartView *)barChartView
{
    [self.informationView setHidden:YES animated:YES];
    [_PowerLabel setHidden:NO];
    [_viewDivider setHidden:NO];
    [_viewDivider2 setHidden:NO];
    [_ScentLabel setHidden:NO];
    [_InfoLabel setHidden:NO];
    
}
- (UIColor *)barChartView:(JBBarChartView *)barChartView colorForBarViewAtIndex:(NSUInteger)index
{
    return (index % 2 == 0) ? [UIColor flatBlueColor] : [UIColor flatLimeColor];
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor];
}



@end
