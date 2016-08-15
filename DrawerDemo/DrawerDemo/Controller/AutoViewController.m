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

#define footViewHeight 65
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
    if (self.powerBtnClick!=nil) {
        self.powerBtnClick(bt.tag);
    }
}

@end

@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *values;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *footLabel1;
@property (weak, nonatomic) IBOutlet UILabel *footLabel2;
@property (weak, nonatomic) IBOutlet UILabel *footLabel3;
@property (weak, nonatomic) IBOutlet UISwitch *Switch1;
@property (weak, nonatomic) IBOutlet UISwitch *Switch2;
@property (weak, nonatomic) IBOutlet UITextField *timesTextField;

@property (nonatomic,assign)float currentOffSet;
@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=Localized(@"AUTO");
    self.footLabel1.text=Localized(@"Manual(OFF／ON)");
    self.footLabel2.text=Localized(@"Manual／ChangeColor");
    self.footLabel3.text=Localized(@"ChangeColor");

    self.tableView.contentInset=UIEdgeInsetsMake(0, 0, footViewHeight, 0);
    [self.footView setFrame:CGRectMake(0, TTScreenHeight-footViewHeight, TTScreenWidth, footViewHeight)];
    [self.view addSubview:self.footView];
    
    [self Switch2Action:self.Switch2];
    
    //test data
    NSMutableArray *valueArray1=[NSMutableArray arrayWithArray:@[@"0",@"0",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray2=[NSMutableArray arrayWithArray:@[@"0",@"1",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray3=[NSMutableArray arrayWithArray:@[@"0",@"2",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray4=[NSMutableArray arrayWithArray:@[@"0",@"1",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray5=[NSMutableArray arrayWithArray:@[@"0",@"0",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray6=[NSMutableArray arrayWithArray:@[@"0",@"1",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray7=[NSMutableArray arrayWithArray:@[@"0",@"0",@"18.5",@"200",@"0.5",@"0.5"]];
    NSMutableArray *valueArray8=[NSMutableArray arrayWithArray:@[@"0",@"1",@"18.5",@"200",@"0.5",@"0.5"]];

    _values=[NSMutableArray arrayWithArray:@[valueArray1,valueArray2,valueArray3,valueArray4,valueArray5,valueArray6,valueArray7,valueArray8]];
}

-(void)updateData
{
    self.title=Localized(@"AUTO");
    self.footLabel1.text=Localized(@"Manual(OFF／ON)");
    self.footLabel2.text=Localized(@"Manual／ChangeColor");
    self.footLabel3.text=Localized(@"ChangeColor");
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

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    if (section==0) {
//        UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, TTScreenWidth, 80)];
//        view.backgroundColor=[UIColor whiteColor];
//        return view;
//    }
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        AutoStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoStatusCell class]) forIndexPath:indexPath];
        cell.powerBtn.tag=indexPath.section;
        switch ([_values[indexPath.section][1] intValue]) {
            case 0:
                cell.statusImg.backgroundColor=[UIColor redColor];
                cell.title.text=Localized(@"PIN CLOSE");

                break;
            case 1:
                cell.statusImg.backgroundColor=[UIColor greenColor];
                cell.title.text=Localized(@"PIN OPEN");

                break;
            case 2:
                cell.statusImg.backgroundColor=[UIColor yellowColor];
                cell.title.text=Localized(@"PIN IN THE MIDDLE");

                break;

            default:
                break;
        }
        
        switch ([_values[indexPath.section][0] intValue]) {
            case 0:
                [cell.powerBtn setHighlighted:NO];

                break;
            case 1:
                [cell.powerBtn setHighlighted:YES];

                break;
                
            default:
                break;
        }
        
        __weak typeof(AutoStatusCell) *weakcell=cell;
        cell.powerBtnClick=^(NSInteger tag){
            if ([_values[tag][0] isEqualToString:@"0"]) {
                _values[tag][0]=@"1";
                [weakcell.powerBtn setHighlighted:YES];

            }else
            {
                _values[tag][0]=@"0";
                [weakcell.powerBtn setHighlighted:NO];


            }
            NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:tag];
            [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
        };
        
        return cell;
    }else
    {
        AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class]) forIndexPath:indexPath];
        cell.title.text=self.titleArray[indexPath.row-1];
        cell.textField.text=_values[indexPath.section][indexPath.row-1];
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
    if (dimension!=nil) {
        NSLog(@"[%li][%li] Modified",(long)dimension.one,(long)dimension.two);
        _values[dimension.one][dimension.two]=textField.text;
    }
   
}
- (IBAction)Switch2Action:(UISwitch *)sender {
    if (sender.isOn) {
        self.Switch1.enabled=NO;
        self.timesTextField.enabled=YES;
        self.timesTextField.textColor=[UIColor blackColor];

        [self.footLabel1 setTextColor:[UIColor lightGrayColor]];
        [self.footLabel3 setTextColor:[UIColor blackColor]];

    }else
    {
        self.Switch1.enabled=YES;
        self.timesTextField.enabled=NO;
        self.timesTextField.textColor=[UIColor lightGrayColor];

        [self.footLabel1 setTextColor:[UIColor blackColor]];
        [self.footLabel3 setTextColor:[UIColor lightGrayColor]];
    }
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
