//
//  GateSettingViewController.m
//  DrawerDemo
//
//  Created by paul on 16/8/30.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "GateConfigViewController.h"
#import "CAPSPageMenu.h"
#import "GateParamViewController.h"
#import "GateSettingViewController.h"

@interface GateConfigViewController ()
@property (nonatomic) CAPSPageMenu *pageMenu;
@property (nonatomic,strong)NSArray *controllerArray;

@end

@implementation GateConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initPageMenu];
    
//    UIBarButtonItem *back = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
//    [back setTintColor:[UIColor blackColor]];
//    self.navigationItem.leftBarButtonItem = back;
}

- (NSArray *)controllerArray
{
    if (!_controllerArray) {
        _controllerArray = [[NSArray alloc]init];
    }
    return _controllerArray;
}

- (void)initPageMenu
{
    GateParamViewController *controller1 = (GateParamViewController *)[Utils getVCFromSBName:@"Main" vcClass:[GateParamViewController class]];
    controller1.title = Localized(@"HOME PARAMETER");
    GateSettingViewController *controller2 = (GateSettingViewController *)[Utils getVCFromSBName:@"Main" vcClass:[GateSettingViewController class]];
    controller2.title = Localized(@"GATES SETTING");

    self.controllerArray = @[controller1,controller2];

    
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor clearColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor clearColor],
                                 CAPSPageMenuOptionSelectionIndicatorColor: LightBlack,
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor groupTableViewBackgroundColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont fontWithName:@"HelveticaNeue" size:14.0],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(CGRectGetWidth(self.view.frame)/2),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionSelectionIndicatorHeight: @(1.5),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor: LightBlack,
                                 CAPSPageMenuOptionAddBottomMenuHairline: @(YES),
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor lightGrayColor],
                                 CAPSPageMenuOptionMenuMargin: @(0),
                                 };
    
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:self.controllerArray frame:CGRectMake(0.0, 64, self.view.frame.size.width, self.view.frame.size.height-64) options:parameters];
    [self.view addSubview:_pageMenu.view];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
