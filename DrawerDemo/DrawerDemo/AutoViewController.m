//
//  AutoViewController.m
//  DrawerDemo
//
//  Created by paul on 16/8/9.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "AutoViewController.h"
#import "UITextField+Add.h"
#import "Dimension.h"

/**
 *  @brief 各项参数Cell
 */
@interface AutoCell()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation AutoCell
- (IBAction)returnClick:(id)sender {
    [self.textField resignFirstResponder];
}

@end

/**
 *  @brief 开关状态Cell
 */

@interface  AutoStatusCell()
@property (weak, nonatomic) IBOutlet UIImageView *statusImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *powerBtn;

@end

@implementation AutoStatusCell
- (IBAction)powerClick:(id)sender {
    UIButton *bt=sender;
    NSLog(@"Power[%li] Click",(long)bt.tag);
}

@end

@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *values;



@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=Localized(@"AUTO");
    
    
    //test data
    NSMutableArray *valueArray1=[NSMutableArray arrayWithArray:@[@"aa",@"bb",@"cc",@"dd",@"ee"]];
    NSMutableArray *valueArray2=[NSMutableArray arrayWithArray:@[@"ff",@"gg",@"hh",@"ii",@"jj"]];
    NSMutableArray *valueArray3=[NSMutableArray arrayWithArray:@[@"kk",@"mm",@"nn",@"oo",@"pp"]];
    NSMutableArray *valueArray4=[NSMutableArray arrayWithArray:@[@"qq",@"rr",@"ss",@"tt",@"uu"]];
    NSMutableArray *valueArray5=[NSMutableArray arrayWithArray:@[@"vv",@"ww",@"xx",@"yy",@"zz"]];
    NSMutableArray *valueArray6=[NSMutableArray arrayWithArray:@[@"aa",@"bb",@"cc",@"dd",@"ee"]];
    NSMutableArray *valueArray7=[NSMutableArray arrayWithArray:@[@"ff",@"gg",@"hh",@"ii",@"jj"]];
    NSMutableArray *valueArray8=[NSMutableArray arrayWithArray:@[@"kk",@"mm",@"nn",@"oo",@"pp"]];

    _values=[NSMutableArray arrayWithArray:@[valueArray1,valueArray2,valueArray3,valueArray4,valueArray5,valueArray6,valueArray7,valueArray8]];
}

-(void)updateData
{
    self.title=Localized(@"AUTO");
    [self.tableView reloadData];
}

-(NSMutableArray *)titleArray
{
    _titleArray=[NSMutableArray arrayWithObjects:Localized(@"POSITION"),
                 Localized(@"DRIVING FORCE"),
                 Localized(@"CLOSING TIME"),
                 Localized(@"OPENING TIME"),
                 nil];
    return _titleArray;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title=[NSString stringWithFormat:@"%@%li",Localized(@"Gate"),(long)section+1];
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AutoStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoStatusCell class]) forIndexPath:indexPath];
        cell.title.text=Localized(@"STATUS");
        cell.powerBtn.tag=indexPath.section;
        return cell;
    }else
    {
        AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class]) forIndexPath:indexPath];
        cell.title.text=self.titleArray[indexPath.row-1];
        cell.textField.text=_values[indexPath.section][indexPath.row];
        Dimension *dimension=[[Dimension alloc]init];
        dimension.one=indexPath.section;
        dimension.two=indexPath.row;
        [cell.textField setDimension:dimension];
        return cell;

    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section = %li,row = %li",(long)indexPath.section,(long)indexPath.row);
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    Dimension *dimension=textField.dimension;
    NSLog(@"[%li][%li] Modified",(long)dimension.one,(long)dimension.two);
    _values[dimension.one][dimension.two]=textField.text;
    
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
