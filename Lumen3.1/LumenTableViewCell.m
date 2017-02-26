//
//  LumenTableViewCell.m
//  Lumen3.0
//
//  Created by Preston Perriott on 1/24/17.
//  Copyright © 2017 Preston Perriott. All rights reserved.
//

#import "LumenTableViewCell.h"

@interface LumenTableViewCell () <EMEmojiableBtnDelegate,UIGestureRecognizerDelegate, MKDropdownMenuDelegate, MKDropdownMenuDataSource,EPieChartDelegate, EPieChartDataSource>{
    UIPanGestureRecognizer *pgrSwipeAction;
    
    UIView *viewRootContent;
    UIImageView *imgViewDrawing;
    UILabel *lblTitle;
    UILabel *lblLocation;
    UILabel *lblSetTime;
    UILabel *scentIndicator;
    UILabel *orientationIndicator;
    UILabel *Orientation;
    UILabel *Scent1;
    UILabel *Scent2;  //Changeable Option
    //UISwitch *swchPower;
    UIButton *btnDetails;
    UIView *viewDivider;
    UIView *viewDividerH;
    EMEmojiableBtn *MainBtn;
    EMEmojiableBtnConfig *Config;
    MKDropdownMenu *DropDown;
    EPieChartDataModel *PieDataModel;
    EPieChart *PieChart;
    JTMaterialSwitch *swchPower;
    
    
    
    CAEmitterLayer *fireEmitter;
    CAEmitterLayer *smokeEmitter;
    
    UIView *viewActionContent;
    UIButton *btnDelete;
    
    BOOL _actionMenuOpen;
    BOOL _panning;
    CGFloat _startingX;
    CGFloat _panningX;
    CGFloat _lastChange;
    }

@end
@implementation LumenTableViewCell
+(CGFloat)defaultCellHeight{
    return 100;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self sharedInit];
    }
    return self;
}
- (void)sharedInit {
    
    _actionMenuOpen = NO;
    _panning = NO;
    
    //self.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67];
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.userInteractionEnabled = YES;
    
    viewRootContent = [[UIView alloc]initWithFrame:CGRectMake(8, 28, CGRectGetWidth(self.frame)-8, CGRectGetHeight(self.frame) + 85)];
    
    
    viewRootContent.backgroundColor = [UIColor clearColor];
    viewRootContent.layer.cornerRadius = 7.5;
    viewRootContent.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.7].CGColor;
    viewRootContent.layer.shadowOpacity = 0.7;
    viewRootContent.layer.shadowRadius = 8.0;
    viewRootContent.layer.shadowOffset = CGSizeMake(8.0, 8.0);
    viewRootContent.layer.borderColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67].CGColor;
    viewRootContent.layer.borderWidth = .3;
    viewRootContent.layer.masksToBounds = YES;
    viewRootContent.layer.borderColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:.67].CGColor;
    viewRootContent.layer.borderWidth = 2.0;
    

    
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurEffectView.translatesAutoresizingMaskIntoConstraints = false;
    blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    blurEffectView.alpha =  1;
    
    [viewRootContent addSubview:blurEffectView];
    [viewRootContent sendSubviewToBack:blurEffectView];
    
    
    [blurEffectView.centerXAnchor constraintEqualToAnchor:viewRootContent.centerXAnchor].active = TRUE;
    [blurEffectView.topAnchor constraintEqualToAnchor:viewRootContent.topAnchor].active = TRUE;
    [blurEffectView.widthAnchor constraintEqualToAnchor:viewRootContent.widthAnchor].active = TRUE;
    [blurEffectView.heightAnchor constraintEqualToAnchor:viewRootContent.heightAnchor].active = TRUE;
    
    [self.contentView addSubview:viewRootContent];
    
    Config = [[EMEmojiableBtnConfig alloc] init];
    Config.spacing  = 6.0;
    Config.size     = 30.0;
    Config.minSize  = 34.0;
    Config.maxSize  = 45.0;
    //config.s_options_selector = 0.0;
    Config.informationViewBackgroundColor = [UIColor blueColor];
    Config.informationViewDotsColor = [UIColor clearColor];
    Config.informationViewTextColor = [UIColor whiteColor];
    Config.informationViewBorderColor = [UIColor whiteColor];
    Config.optionsViewBackgroundColor = [UIColor greenColor];
    
  
    MainBtn = [[EMEmojiableBtn alloc] initWithFrame:CGRectMake(CGRectGetWidth(viewRootContent.frame)-50, (CGRectGetHeight(viewRootContent.frame) + 60)/2, 30, 30) withConfig:Config];
    MainBtn.delegate = self;
    MainBtn.dataset = @[[[EMEmojiableOption alloc] initWithImage:@"volume-control.png" withName:@"dislike"],
                        [[EMEmojiableOption alloc] initWithImage:@"smartphone-11.png" withName:@"broken"],
                        [[EMEmojiableOption alloc] initWithImage:@"menu.png" withName:@"settings"],
                        [[EMEmojiableOption alloc] initWithImage:@"settings-2.png" withName:@"settingstoo"],
                        [[EMEmojiableOption alloc] initWithImage:@"volume-control-1.png" withName:@"Control"]];
    
  // MainBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
    
    [MainBtn setImage:[UIImage imageNamed:@"logo_circle.png"] forState:UIControlStateNormal];
   // [self.contentView addSubview:MainBtn];
   // [self.contentView bringSubviewToFront:MainBtn];
    
    //[viewRootContent addSubview:MainBtn];
    //[viewRootContent bringSubviewToFront:MainBtn];
    [MainBtn setUserInteractionEnabled:YES];
    MainBtn.layer.masksToBounds = YES;
    
    
    imgViewDrawing = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetHeight(viewRootContent.frame)-20, CGRectGetHeight(viewRootContent.frame)-20)];
    imgViewDrawing.layer.cornerRadius = viewRootContent.layer.cornerRadius;
    imgViewDrawing.backgroundColor = [UIColor colorWithRed:80.0/255.0 green:101.0/255.0 blue:161.0/255.0 alpha:.56];
    imgViewDrawing.layer.borderColor = [UINavigationBar appearance].barTintColor.CGColor;
    imgViewDrawing.layer.borderWidth = 1.0;
    imgViewDrawing.layer.masksToBounds = YES;
    imgViewDrawing.userInteractionEnabled = YES;
    //[viewRootContent addSubview:imgViewDrawing];
    
    
    
    //lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, CGRectGetWidth(viewRootContent.frame)-10-CGRectGetMaxX(imgViewDrawing.frame)-10, 20)];
    lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(25, 10, 50, 20)];
    lblTitle.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]+10];
    //[lblTitle sizeToFit];
    //lblTitle.textColor = [UIColor colorWithCGColor:imgViewDrawing.layer.borderColor];
    lblTitle.textColor = [UIColor whiteColor];
    
    
    [viewRootContent addSubview:lblTitle];
    
#pragma FIRE & SMOKE
    CGRect ViewBounds = viewRootContent.layer.bounds;
    fireEmitter	= [CAEmitterLayer layer];
    smokeEmitter = [CAEmitterLayer layer];
    
    fireEmitter.emitterPosition = CGPointMake((CGRectGetMaxX(lblTitle.frame)+CGRectGetWidth(lblTitle.frame)), (ViewBounds.size.height / 2.0)*.40);
    
    fireEmitter.emitterSize	= CGSizeMake(ViewBounds.size.width/8.0, 40);
    fireEmitter.emitterMode	= kCAEmitterLayerOutline;
    fireEmitter.emitterShape	= kCAEmitterLayerLine;
    // with additive rendering the dense cell distribution will create "hot" areas
    fireEmitter.renderMode		= kCAEmitterLayerAdditive;
    
    smokeEmitter.emitterPosition = CGPointMake((CGRectGetMaxX(lblTitle.frame)+15), (ViewBounds.size.height / 2.0)*.40);
    smokeEmitter.emitterMode	= kCAEmitterLayerPoints;
    
    // Create the fire emitter cell
    CAEmitterCell* fire = [CAEmitterCell emitterCell];
    [fire setName:@"fire"];
    
    fire.birthRate			= 150; //
    fire.emissionLongitude  = M_PI * .8;
    fire.velocity			= -80;
    fire.velocityRange		= 30;
    fire.emissionRange		= 1.5;
    fire.yAcceleration		= -.05;
    fire.scaleSpeed			= 0.7;
    fire.lifetime			= 60;   //
    fire.lifetimeRange		= (60.0 * 0.35); //
    
    fire.color = [[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1] CGColor];
    fire.contents = (id) [[UIImage imageNamed:@"MsFire"] CGImage];
    
    
    
    // Create the smoke emitter cell
    CAEmitterCell* smoke = [CAEmitterCell emitterCell];
    [smoke setName:@"smoke"];
    
    smoke.birthRate			= 11;
    smoke.emissionLongitude = -M_PI / 4;
    smoke.lifetime			= 10;
    smoke.velocity			= -40;
    smoke.velocityRange		= 20;
    smoke.emissionRange		= M_PI / 4;
    smoke.spin				= 1;
    smoke.spinRange			= 6;
    smoke.yAcceleration		= -160;
    smoke.contents			= (id) [[UIImage imageNamed:@"MsSmoke"] CGImage];
    smoke.scale				= 0.1;
    smoke.alphaSpeed		= -0.12;
    smoke.scaleSpeed		= 0.7;
    
    
    // Add the smoke emitter cell to the smoke emitter layer
    smokeEmitter.emitterCells	= [NSArray arrayWithObject:smoke];
    fireEmitter.emitterCells	= [NSArray arrayWithObject:fire];
    
   // [self setFireAmount:0.45];
   // [viewRootContent.layer addSublayer:smokeEmitter];
   // [viewRootContent.layer addSublayer:fireEmitter];
    
#pragma END FIRE SMOKE
    
    
    lblLocation = [[UILabel alloc] initWithFrame:CGRectMake(25, CGRectGetMaxY(lblTitle.frame)+10, CGRectGetWidth(lblTitle.frame), CGRectGetHeight(lblTitle.frame))];
    lblLocation.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    lblLocation.textColor = [lblTitle.textColor colorWithAlphaComponent:0.8];
    //[viewRootContent addSubview:lblLocation];
    
    
   // DropDown = [[MKDropdownMenu alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(lblSetTime.frame), CGRectGetWidth(lblSetTime.frame) + 10, CGRectGetHeight(lblSetTime.frame)+10)];
    DropDown = [[MKDropdownMenu alloc]initWithFrame:CGRectZero];
    DropDown.translatesAutoresizingMaskIntoConstraints = false;
    DropDown.disclosureIndicatorImage = [UIImage imageNamed:@"menu@3x.png"];
    DropDown.rowSeparatorColor = [UIColor colorWithWhite:1.0 alpha:.3];
    DropDown.tintColor = [UIColor blackColor];
    DropDown.rowTextAlignment = NSTextAlignmentCenter;
    DropDown.dropdownRoundedCorners = UIRectCornerAllCorners;
    DropDown.delegate = self;
    DropDown.dataSource = self;
    DropDown.presentingView = viewRootContent;
    DropDown.adjustsContentOffset = YES;
    DropDown.backgroundDimmingOpacity = -.4;
    DropDown.userInteractionEnabled = YES;
    [viewRootContent addSubview:DropDown];
    [viewRootContent bringSubviewToFront:DropDown];
    
    
    
    [DropDown.topAnchor constraintEqualToAnchor:viewRootContent.topAnchor].active = TRUE;
    [DropDown.rightAnchor constraintEqualToAnchor:viewRootContent.rightAnchor].active = TRUE;
    [DropDown.widthAnchor constraintEqualToAnchor:viewRootContent.widthAnchor multiplier:.33].active = TRUE;
    [DropDown.heightAnchor constraintEqualToAnchor:viewRootContent.heightAnchor multiplier:.33].active = TRUE;

    //swchPower = [[JTMaterialSwitch alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewRootContent.frame)-CGRectGetWidth(lblLocation.frame)*1.20, CGRectGetMaxY(lblLocation.frame)+18, CGRectGetWidth(lblLocation.frame), CGRectGetHeight(lblLocation.frame))];
    swchPower = [[JTMaterialSwitch alloc]initWithSize:JTMaterialSwitchSizeSmall style:JTMaterialSwitchStyleDefault state:JTMaterialSwitchStateOff];
    swchPower.frame = CGRectMake(CGRectGetMaxX(viewRootContent.frame)-CGRectGetWidth(lblLocation.frame)*1.20, CGRectGetMaxY(lblLocation.frame)+25, CGRectGetWidth(lblLocation.frame), CGRectGetHeight(lblLocation.frame));
    swchPower.tintColor = [UIColor blackColor];
   
    [swchPower addTarget:self action:@selector(FlameOn:) forControlEvents:UIControlEventTouchUpInside];
    //vertical trasnform
   // swchPower.transform = CGAffineTransformMakeRotation(M_PI_2);

    [viewRootContent addSubview:swchPower];
    
    viewDivider = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(lblTitle.frame)+7, CGRectGetWidth(viewRootContent.frame)*.8, CGRectGetHeight(viewRootContent.frame)*.020)];
    viewDivider.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.45];
    viewDivider.layer.cornerRadius = 1;
    viewDivider.layer.shadowColor = [UIColor blackColor].CGColor;
    viewDivider.layer.shadowOpacity = .42f;
    viewDivider.layer.shadowOffset =CGSizeZero;
    viewDivider.layer.shadowRadius = 5.0f;
    [viewRootContent addSubview:viewDivider];
    
    viewDividerH = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(viewDivider.frame)*.70, CGRectGetMaxY(viewDivider.frame)+2.2, viewDivider.frame.size.height, (viewDivider.frame.size.width)*.30)];
    viewDividerH.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.45];
    viewDividerH.layer.cornerRadius = 1;
    viewDividerH.layer.shadowColor = [UIColor blackColor].CGColor;
    viewDividerH.layer.shadowOpacity = .42f;
    viewDividerH.layer.shadowOffset =CGSizeZero;
    viewDividerH.layer.shadowRadius = 5.0f;
    //[viewRootContent addSubview:viewDividerH];
    
    scentIndicator = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(viewDivider.frame)+2, CGRectGetWidth(lblTitle.frame), CGRectGetHeight(lblLocation.frame))];
    scentIndicator.font =[UIFont systemFontOfSize:[UIFont systemFontSize]];
    scentIndicator.textColor = [UIColor whiteColor];
    scentIndicator.text = @"Scent :";
    scentIndicator.alpha = .65;
    [viewRootContent addSubview:scentIndicator];
    
    Scent1 = [[UILabel alloc]initWithFrame:CGRectMake(35,CGRectGetMaxY(scentIndicator.frame)+.5, CGRectGetWidth(lblTitle.frame)*3, CGRectGetHeight(lblLocation.frame))];
    Scent1.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    Scent1.textColor = [lblLocation.textColor colorWithAlphaComponent:.8];
    [viewRootContent addSubview:Scent1];
    
    orientationIndicator = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(Scent1.frame)+.5, CGRectGetWidth(lblTitle.frame)*2, CGRectGetHeight(lblLocation.frame))];
    orientationIndicator.font =[UIFont systemFontOfSize:[UIFont systemFontSize]];
    orientationIndicator.textColor = [UIColor whiteColor];
    orientationIndicator.text = @"Orientation :";
    orientationIndicator.alpha = .65;
    [viewRootContent addSubview:orientationIndicator];

    Orientation = [[UILabel alloc]initWithFrame:CGRectMake(35,CGRectGetMaxY(orientationIndicator.frame)+.5, CGRectGetWidth(lblTitle.frame)*2, CGRectGetHeight(lblLocation.frame))];
    Orientation.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    Orientation.textColor = [lblLocation.textColor colorWithAlphaComponent:.8];
    Orientation.text = @"180º";
    [viewRootContent addSubview:Orientation];
    
    PieDataModel = [[EPieChartDataModel alloc]initWithBudget:100 current:90 estimate:0];
    PieChart = [[EPieChart alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(viewRootContent.frame)*.25, CGRectGetWidth(viewRootContent.frame)*.25) ePieChartDataModel:PieDataModel];
    PieChart.center = CGPointMake(viewRootContent.center.x, viewRootContent.center.y-((viewRootContent.frame.size.height)*.05));
    PieChart.delegate = self;
    PieChart.dataSource = self;
    //PieChart.layer.masksToBounds = NO;
    PieChart.clipsToBounds = NO;
    PieChart.layer.drawsAsynchronously = YES;
    PieChart.layer.beginTime = 2.0;
    
    [viewRootContent addSubview:PieChart];
    //[viewRootContent sendSubviewToBack:PieChart];
    
    

    
    
   // lblSetTime = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(lblLocation.frame)-30,CGRectGetMaxY(lblLocation.frame)-20 , CGRectGetWidth(lblLocation.frame), CGRectGetHeight(lblLocation.frame))];
    lblSetTime = [[UILabel alloc]initWithFrame:CGRectMake(25, CGRectGetMaxY(Scent1.frame)+5, CGRectGetWidth(Scent1.frame), CGRectGetHeight(Scent1.frame))];
    lblSetTime.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    lblSetTime.textColor = [lblLocation.textColor colorWithAlphaComponent:.8];
    //[viewRootContent addSubview:lblSetTime];
    
    
    
    pgrSwipeAction = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pgrSwipeAction.delegate = self;
    [viewRootContent addGestureRecognizer:pgrSwipeAction];
    
    _Floating = [[VLAFloatingViewController alloc]init];
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)handlePan:(UIPanGestureRecognizer*)gesture{
    NSLog(@"Gesture");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setTitle:(NSString *)title {
    lblTitle.text = title;
    [lblTitle sizeToFit];
}
- (void)setLocation:(NSString *)location {
    lblLocation.text = location;
    [lblLocation sizeToFit];
}
-(void)setTime:(NSString *)setTime{
    lblSetTime.text = setTime;
    [lblSetTime sizeToFit];
}
-(void)setScent1:(NSString *)scent{
    Scent1.text = scent;
    [Scent1 sizeToFit];
    
}
-(void)changeTime:(NSString *)time {
    Scent2.text = time;
    [Scent2 sizeToFit];
    
    
}
-(void)setButane:(int)level{
    //Maybe for setting the Type of Cartridge
    //While one cartridge might be 100%
    //another might be 50%?
    PieDataModel.budget = level;
    [PieChart reloadInputViews];
}
-(void)setCurrent:(int)level{
    PieDataModel.current = level;
    [PieChart reloadInputViews];
}
- (void)EMEmojiableBtn:(EMEmojiableBtn *)button selectedOption:(NSUInteger)index{
    
    
}
#pragma mark MKDROP Data source methdods

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 5;
}

#pragma mark - MKDropdownMenuDelegate

- (CGFloat)dropdownMenu:(MKDropdownMenu *)dropdownMenu rowHeightForComponent:(NSInteger)component {
    return 14;
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForComponent:(NSInteger)component {
    return [[NSAttributedString alloc] initWithString:@"Scents"
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: [[UIColor whiteColor]colorWithAlphaComponent:.56]}];
}

- (NSAttributedString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    NSArray *Scents = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
    NSMutableAttributedString *string =
    [[NSMutableAttributedString alloc] initWithString: [NSString stringWithFormat:@"%@: ", [Scents objectAtIndex:row]]
                                           attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14 weight:UIFontWeightLight],
                                                        NSForegroundColorAttributeName: [UIColor blackColor]}];
    
    return string;
}


- (UIColor *)dropdownMenu:(MKDropdownMenu *)dropdownMenu backgroundColorForHighlightedRowsInComponent:(NSInteger)component {
    return [UIColor colorWithWhite:0.0 alpha:0.5];
}


- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSArray *Scents = @[@"Apples", @"Cinnamon",@"Pine",@"Vanilla", @"Citrus"];
    NSString *SelectedScent = [NSString stringWithFormat:@"%@",[Scents objectAtIndex:row]];
    
    
    //[Scent1 setText:SelectedScent];
    [self setScent1:SelectedScent];
    
    NSLog(@"Scent : %@ was selected ", [Scents objectAtIndex:row]);

    
    [dropdownMenu closeAllComponentsAnimated:YES];
    
    
}
#pragma FIRE FUNC
- (void) setFireAmount:(float)zeroToOne
{
    // Update the fire properties
    [fireEmitter setValue:[NSNumber numberWithInt:(zeroToOne * 100)]
                    forKeyPath:@"emitterCells.fire.birthRate"];
    
    [fireEmitter setValue:[NSNumber numberWithFloat:zeroToOne * .35]
                    forKeyPath:@"emitterCells.fire.lifetime"];
    
    [fireEmitter setValue:[NSNumber numberWithFloat:(zeroToOne * 0.0935)]
                    forKeyPath:@"emitterCells.fire.lifetimeRange"];
    fireEmitter.emitterSize = CGSizeMake(.3 * zeroToOne, 0);
    
    [smokeEmitter setValue:[NSNumber numberWithInt:zeroToOne * .4]
                     forKeyPath:@"emitterCells.smoke.lifetime"];
    [smokeEmitter setValue:(id)[[UIColor colorWithRed:1 green:1 blue:1 alpha:zeroToOne * 0.3] CGColor]
                     forKeyPath:@"emitterCells.smoke.color"];
}
-(void)FlameOn:(UISwitch*)sender{
    
    BOOL state = [sender isOn];
    
    if (state) {
        PieChart.frontPie.budgetColor = [UIColor flatYellowColor];
        [PieChart.frontPie reloadContent];
        PieChart.frontPie.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1];

    }else{
        PieChart.frontPie.backgroundColor = [UIColor grayColor];
        PieChart.frontPie.budgetColor = [UIColor grayColor];
        [PieChart.frontPie reloadContent];
        
    }
   /* if (state) {
        [self setFireAmount:.45];
        [viewRootContent layoutSubviews];
        [self reloadInputViews];
        NSLog(@"Switch On");
    }else if(!state){
        [self setFireAmount:0];
        [viewRootContent layoutSubviews];
        [self reloadInputViews];
        NSLog(@"Switch Off");
    }*/
    
}
- (void)ePieChart:(EPieChart *)ePieChart
didTurnToBackViewWithBackView:(UIView *)backView
{
    NSLog(@"TURNED");
    
    [self.delegate LoadLumenInfoScreen:_Floating];
    
   // UIViewController* activeVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    //[activeVC presentViewController:_Floating animated:YES completion:NULL];
    
}

- (void)              ePieChart:(EPieChart *)ePieChart
didTurnToFrontViewWithFrontView:(UIView *)frontView
{
    
}

#pragma -mark- EPieChartDataSource
- (UIView *)backViewForEPieChart:(EPieChart *)ePieChart
{
    UIView *customizedView = [[UIView alloc] initWithFrame:ePieChart.backPie.bounds];
    customizedView.layer.cornerRadius = CGRectGetWidth(customizedView.bounds) / 2;
    
    customizedView.backgroundColor = [[UIColor redColor]colorWithAlphaComponent:.26];
    
    UIImage *Logo = [UIImage imageNamed:@"logo_circle.png"];
    UIImageView *LogoView = [[UIImageView alloc]initWithImage:Logo];
    LogoView.frame = customizedView.bounds;
    [customizedView addSubview:LogoView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:customizedView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 3;
    label.font = [UIFont fontWithName:@"Menlo" size:15];
    label.text = @"We Talkin Fuego";
   // [customizedView addSubview:label];
    
    return customizedView;
}
- (UIView *) frontViewForEPieChart:(EPieChart *) ePieChart{
    
    
    UIView *contentView  = [[UIView alloc] initWithFrame:ePieChart.frontPie.bounds];
    contentView.layer.cornerRadius = CGRectGetWidth(contentView.bounds) / 2;
    contentView.backgroundColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:250/255.0 alpha:1];
    [contentView superview];

   // contentView.backgroundColor = [UIColor flatYellowColor];
   // ePieChart.frontPie.budgetColor = [UIColor whiteColor];
    
    
    UILabel *title = [[UILabel alloc] initWithFrame:contentView.frame];
    title.text = @"Fuel";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont fontWithName:@"Menlo-Bold" size:9];
    title.textColor = [UIColor whiteColor];
    title.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds) * 0.6);
    [contentView addSubview:title];
    
    
    UIView *line = [[UIView alloc] initWithFrame:contentView.bounds];
    line.backgroundColor = [UIColor whiteColor];
    line.bounds = CGRectMake(0, 0, CGRectGetWidth(contentView.bounds) * 0.6, 1);
    line.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds) * 0.8);
    [contentView addSubview:line];
    
    
    UICountingLabel *budgetLabel = [[UICountingLabel alloc] initWithFrame:contentView.frame];
    budgetLabel.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds) * 1);
    budgetLabel.textAlignment = NSTextAlignmentCenter;
    budgetLabel.method = UILabelCountingMethodEaseInOut;
    budgetLabel.font = [UIFont fontWithName:@"Menlo" size:7];
    budgetLabel.textColor = [UIColor whiteColor];
    budgetLabel.format = @"B:%.1f";
    [contentView addSubview:budgetLabel];
    [budgetLabel countFrom:0 to:PieDataModel.budget withDuration:2.0f];
    
    UICountingLabel *currentLabel = [[UICountingLabel alloc] initWithFrame:contentView.frame];
    currentLabel.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds) * 1.4);
    currentLabel.textAlignment = NSTextAlignmentCenter;
    currentLabel.method = UILabelCountingMethodEaseInOut;
    currentLabel.font = [UIFont fontWithName:@"Menlo" size:7];
    currentLabel.textColor = [UIColor whiteColor];
    currentLabel.format = @"C:%.1f";
    [contentView addSubview:currentLabel];
    [currentLabel countFrom:0 to:PieDataModel.current withDuration:2.0f];
    
    UICountingLabel *estimateLabel = [[UICountingLabel alloc] initWithFrame:contentView.frame];
    estimateLabel.center = CGPointMake(CGRectGetMidX(contentView.bounds), CGRectGetMidY(contentView.bounds) * 1.4);
    estimateLabel.textAlignment = NSTextAlignmentCenter;
    estimateLabel.method = UILabelCountingMethodEaseInOut;
    estimateLabel.font = [UIFont fontWithName:@"Menlo" size:13];
    estimateLabel.textColor = [UIColor whiteColor];
    estimateLabel.format = @"E:%.1f";
  //  [contentView addSubview:estimateLabel];
   // [estimateLabel countFrom:0 to:PieDataModel.estimate withDuration:2.0f];
    
    
    return contentView;
}

#pragma -mark- Actions
- (void)animationButtonPressed:(id)sender
{
    [PieChart.frontPie reloadContent];
}

- (void)turnPageButtonPressed:(id)sender
{
    [PieChart turnPie];

}





@end
