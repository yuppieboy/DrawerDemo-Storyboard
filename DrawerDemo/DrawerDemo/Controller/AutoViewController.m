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
#import "Gate.h"

#define footViewHeight 65

@interface AutoCell()
@property (weak, nonatomic) IBOutlet UIView *triangle;
@property (weak, nonatomic) IBOutlet UIButton *gateNum;
- (void)configCellWithIndexPath:(NSIndexPath *)indexPath Values:(NSMutableArray *)values;
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
    if ([self.delegate respondsToSelector:@selector(powerBtnDidTap:inCell:)]) {
        [self.delegate powerBtnDidTap:bt.tag inCell:self];
    }
}

- (void)configCellWithIndexPath:(NSIndexPath *)indexPath Values:(NSMutableArray *)values
{
    [self.gateNum setTitle:[NSString stringWithFormat:@"%li",indexPath.section+1] forState:UIControlStateNormal];
    self.gateNum.tag = indexPath.section;
    
    Gate *gate = values[indexPath.section];
    
    self.lb_position.text = gate.position;
    self.lb_dforce.text = gate.dForce;
    self.lb_ctime.text = gate.cTime;
    self.lb_otime.text = gate.oTime;
    
    switch (gate.gateSatus) {
        case GateStatus_Close:
            [self.gateNum setBackgroundColor:RGBCOLORHEX(0xaaaaaa)];
            
            break;
        case GateStatus_Open:
            [self.gateNum setBackgroundColor:RGBCOLORHEX(0xff6933)];
            
            break;
            
        default:
            break;
    }
    
    switch (gate.pinStatus) {
        case PinStatus_Open:
            self.pinImg.backgroundColor=[UIColor redColor];
            
            break;
        case PinStatus_Close:
            self.pinImg.backgroundColor=[UIColor greenColor];
            
            break;
        case PinStatus_Middle:
            self.pinImg.backgroundColor=[UIColor yellowColor];
            
            break;
            
        default:
            break;
    }
    
}

@end



@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,BaseVCDelegate,AutoCellDelegate>
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
    
    self.delegate=self;
    
    self.title=Localized(@"AUTO");
    self.footLabel1.text=Localized(@"Manual(OFF／ON)");
    self.footLabel2.text=Localized(@"Manual／ChangeColor");
    self.footLabel3.text=Localized(@"Times／Min");


    self.tableView.contentInset=UIEdgeInsetsMake(0, 15, footViewHeight, -15);
    [self.footView setFrame:CGRectMake(0, TTScreenHeight-footViewHeight, TTScreenWidth, footViewHeight)];
    [self.view addSubview:self.footView];
    
    [self Switch2Action:self.Switch2];
    
    for (int i = 0; i < 8; i++) {
        Gate *gate = [[Gate alloc]init];
        gate.gateSatus = GateStatus_Close;
        gate.pinStatus = arc4random()%3;
        gate.position = @"18.5";
        gate.dForce = @"200";
        gate.cTime = @"0.5";
        gate.oTime = @"0.5";
        [self.values addObject:gate];
    }
    
}

- (NSMutableArray *)values
{
    if (!_values) {
        _values = [[NSMutableArray alloc]init];
    }
    return _values;
}

#pragma mark - BaseVCDelegate

-(void)updateData
{
    self.title=Localized(@"AUTO");
    self.footLabel1.text=Localized(@"Manual(OFF／ON)");
    self.footLabel2.text=Localized(@"Manual／ChangeColor");
    self.footLabel3.text=Localized(@"Times／Min");

    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.values.count;
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
    if (section == self.values.count-1) {
        return 18*Ratio;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell configCellWithIndexPath:indexPath Values:self.values];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section = %li,row = %li",(long)indexPath.section,(long)indexPath.row);
    
    self.selectIndex = indexPath.section;
    [self performSegueWithIdentifier:@"GateSetting" sender:self];
}

#pragma mark - Action


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

#pragma mark - AutoCellDelegate

- (void)powerBtnDidTap:(NSInteger)section inCell:(AutoCell *)cell
{
    Gate *gate = self.values[section];
    switch (gate.gateSatus) {
        case GateStatus_Open:
            gate.gateSatus = GateStatus_Close;
            [cell.gateNum setBackgroundColor:RGBCOLORHEX(0xff6933)];
            break;
        case GateStatus_Close:
            gate.gateSatus = GateStatus_Open;
            [cell.gateNum setBackgroundColor:RGBCOLORHEX(0xaaaaaa)];
            break;
            
        default:
            break;
    }
    
    NSIndexPath *index=[NSIndexPath indexPathForRow:0 inSection:section];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationNone];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
