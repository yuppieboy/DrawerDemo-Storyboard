//
//  LeftViewController.m
//  DrawerDemo
//
//  Created by WangPeng on 16/3/18.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "LeftViewController.h"
#import "AutoViewController.h"
#import "HPViewController.h"

@interface LeftCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;

@end

@implementation LeftCell

@end


@interface LeftViewController()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *titleList;
@property (nonatomic,assign) NSInteger currnetIndex;
@property (weak, nonatomic) IBOutlet UIButton *switchBtn;
@end

@implementation LeftViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
        
    self.tableView.tableFooterView=[UIView new];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight=60*Ratio;
    
}


-(void)viewWillAppear:(BOOL)animated
{
    self.title=Localized(@"Dashboard") ;
    [self.switchBtn setTitle:Localized(@"Language") forState:UIControlStateNormal];
    [self.tableView reloadData];
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:_currnetIndex inSection:0];
    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

-(NSArray *)titleList
{
    _titleList=[NSArray arrayWithObjects:Localized(@"AUTO"),Localized(@"HOME PARAMETER"),Localized(@"GATES SETTING"),Localized(@"REAL TIME PLOT"),Localized(@"TIMER"),Localized(@"ALARMS"),Localized(@"FILES"), nil];
    return _titleList;
}

- (IBAction)switchLanguageClick:(id)sender {
    
    NSString *language = [[NSUserDefaults standardUserDefaults]objectForKey:@"appLanguage"];
    if ([language isEqualToString: @"en"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"zh-Hans" forKey:@"appLanguage"];
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@"en" forKey:@"appLanguage"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.title=Localized(@"Dashboard") ;
    [self.switchBtn setTitle:Localized(@"Language") forState:UIControlStateNormal];
    [self.tableView reloadData];
    NSIndexPath *index=[NSIndexPath indexPathForRow:_currnetIndex inSection:0];
    [self.tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_updateLanguage object:self];

}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LeftCell class]) forIndexPath:indexPath];
    cell.title.text=[NSString stringWithFormat:@"%@",self.titleList[indexPath.row]];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = DarkBlack;
    cell.logoImg.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon_func_%li",(long)indexPath.row]];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.currnetIndex=indexPath.row;
    [self btnClick:indexPath.row];
}

- (void)btnClick:(NSInteger)row {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    if (row == 0) {
        
//        AutoViewController * centerSideNavController =
//        [storyboard instantiateViewControllerWithIdentifier:
//         @"AutoViewController"];
//        UINavigationController * nav = [[UINavigationController alloc]
//                                        initWithRootViewController:centerSideNavController];
//        
//        [self.mm_drawerController setCenterViewController:nav withCloseAnimation:YES completion:nil];
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        MMNavigationController *nav = (MMNavigationController *)self.mm_drawerController.centerViewController;
        [nav popToRootViewControllerAnimated:NO];



    }
    else if(row == 1)
    {
        HPViewController * vc =
        [storyboard instantiateViewControllerWithIdentifier:
         @"HPViewController"];
        
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
        MMNavigationController *nav = (MMNavigationController *)self.mm_drawerController.centerViewController;
        [nav popToRootViewControllerAnimated:NO];
        [nav pushViewController:vc animated:NO];

    }
    
}

- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
