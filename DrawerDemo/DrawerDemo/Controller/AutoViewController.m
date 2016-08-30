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
#import "GateSettingViewController.h"

#define footViewHeight 65
/**
 *  @brief 各项参数Cell
 */
@interface AutoCell()
@property (weak, nonatomic) IBOutlet UIView *triangle;
@property (weak, nonatomic) IBOutlet UIButton *gateNum;

@end

@implementation AutoCell

-(void)awakeFromNib
{
    
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(CGRectGetHeight(self.frame)/2*Ratio,0);
    CGPoint point3 = CGPointMake(0, CGRectGetHeight(self.frame));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    self.triangle.layer.mask = layer;
    
    self.gateNum.layer.cornerRadius = CGRectGetWidth(self.gateNum.frame)/2;
    self.gateNum.layer.borderWidth = 2;
    self.gateNum.layer.borderColor = [UIColor whiteColor].CGColor;
}

- (IBAction)powerBtnClick:(id)sender {
    UIButton *bt=sender;
    NSLog(@"Power[%li] Click",(long)bt.tag);
    if (self.powerBtnClick!=nil) {
        self.powerBtnClick();
    }
}
@end



@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *values;
@property (nonatomic,assign)NSInteger selectIndex;

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

    self.tableView.contentInset=UIEdgeInsetsMake(0, 15, footViewHeight, -15);
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
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _values.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18*Ratio;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _values.count-1) {
        return 18*Ratio;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class]) forIndexPath:indexPath];
    [cell.gateNum setTitle:[NSString stringWithFormat:@"%li",indexPath.section+1] forState:UIControlStateNormal];
    cell.lb_position.text = _values[indexPath.section][2];
    cell.lb_dforce.text = _values[indexPath.section][3];
    cell.lb_ctime.text = _values[indexPath.section][4];
    cell.lb_otime.text = _values[indexPath.section][5];

    
    switch ([_values[indexPath.section][0] intValue]) {
        case 0:
            [cell.gateNum setBackgroundColor:RGBCOLORHEX(0xaaaaaa)];
            
            break;
        case 1:
            [cell.gateNum setBackgroundColor:RGBCOLORHEX(0xff6933)];
            
            break;
            
        default:
            break;
    }
    
    switch ([_values[indexPath.section][1] intValue]) {
        case 0:
            cell.signalImg.backgroundColor=[UIColor redColor];
            
            break;
        case 1:
            cell.signalImg.backgroundColor=[UIColor greenColor];
            
            break;
        case 2:
            cell.signalImg.backgroundColor=[UIColor yellowColor];
            
            break;
            
        default:
            break;
    }


    __weak typeof(AutoCell) *weakcell=cell;
    cell.powerBtnClick=^{
        if ([_values[indexPath.section][0] isEqualToString:@"0"]) {
            _values[indexPath.section][0]=@"1";
            [weakcell.gateNum setBackgroundColor:RGBCOLORHEX(0xff6933)];
            
        }else
        {
            _values[indexPath.section][0]=@"0";
            [weakcell.gateNum setBackgroundColor:RGBCOLORHEX(0xaaaaaa)];
            
        }
        NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
    };

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section = %li,row = %li",(long)indexPath.section,(long)indexPath.row);
    
    self.selectIndex = indexPath.section;
    [self performSegueWithIdentifier:@"GateSetting" sender:self];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"GateSetting"]) {
        GateSettingViewController *vc = segue.destinationViewController;
        vc.title = [NSString stringWithFormat:@"%@%li",Localized(@"Gate"),(long)self.selectIndex];
    }
}


@end
