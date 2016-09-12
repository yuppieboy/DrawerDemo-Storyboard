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
#import "GateConfigViewController.h"
#import "Gate.h"
#import "LoginViewController.h"
#import "IQUIWindow+Hierarchy.h"

#define FootViewHeight 65

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
    
    [self.gateNum setEnlargeEdge:15];
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



@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,BaseVCDelegate,AutoCellDelegate,GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) NSInteger selectIndex;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *footLabel1;
@property (weak, nonatomic) IBOutlet UILabel *footLabel2;
@property (weak, nonatomic) IBOutlet UILabel *footLabel3;
@property (weak, nonatomic) IBOutlet UISwitch *Switch1;
@property (weak, nonatomic) IBOutlet UISwitch *Switch2;
@property (weak, nonatomic) IBOutlet UITextField *timesTextField;

@property (nonatomic,assign)float currentOffSet;

@property (nonatomic, nonnull,strong) NSTimer *timer;

@end

@implementation AutoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate=self;

    self.title=Localized(@"AUTO");
    self.footLabel1.text=Localized(@"Manual(OFF／ON)");
    self.footLabel2.text=Localized(@"Manual／ChangeColor");
    self.footLabel3.text=Localized(@"Times／Min");


    self.tableView.contentInset=UIEdgeInsetsMake(0, 15, FootViewHeight, -15);
    [self.footView setFrame:CGRectMake(0, TTScreenHeight-FootViewHeight, TTScreenWidth, FootViewHeight)];
    [self.view addSubview:self.footView];
    
    [self Switch2Action:self.Switch2];
    
    if (![SocketManager shareManager].model) {
        [self performSelector:@selector(pushLoginVC) withObject:nil afterDelay:0.1];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:kNotification_Login object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_Login object:nil];
    [self.timer invalidate];
}


#pragma mark - Private Method

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(fetchGatesInfo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)loginSuccess
{
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        Gate *gate = [[Gate alloc]init];
        gate.gateSatus = GateStatus_Close;
        gate.pinStatus = arc4random()%3;
        gate.cylinkerType = CylinkerType_TSC130;
        gate.position = @"0";
        gate.dForce = @"0";
        gate.cTime = @"0";
        gate.oTime = @"0";
        gate.po_Postion = @"0";
        [[SocketManager shareManager].values addObject:gate];
    }

    [SocketManager shareManager].delegate = self;
    [[SocketManager shareManager] openSocket];
    
    [self.timer fire];
}

- (void)pushLoginVC
{
    [self performSegueWithIdentifier:@"login" sender:self];
}


- (void)fetchGatesInfo
{
    [self getGateStatusInfo];
    
    [self getGatePositionInfo];
    
    [self getGatePoPostionInfo];
    
    [self getGateCylinkerTypeInfo];
}

/**
 *  @brief 获取阀针开关状态信息
 */
- (void)getGateStatusInfo
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *command = @"08 00 00 06 00 40 40 60 00 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }


        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:arr];
    [[SocketManager shareManager] sendMessage];

}

/**
 *  @brief 获取阀针位置信息
 */
- (void)getGatePositionInfo
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *command = @"08 00 00 06 00 40 00 33 00 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }
        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:arr];
    [[SocketManager shareManager] sendMessage];
}


/**
 *  @brief 获取位置1
 */
- (void)getGatePoPostionInfo
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *command = @"08 00 00 06 00 40 20 31 01 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }
        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:arr];
    [[SocketManager shareManager] sendMessage];

}


/**
 *  @brief 获取机电类型
 */
- (void)getGateCylinkerTypeInfo
{
    NSMutableArray *arr = [NSMutableArray array];
    NSString *command = @"08 00 00 06 00 40 02 64 00 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }
        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:arr];
    [[SocketManager shareManager] sendMessage];
}


- (void)listenReceivedData:(NSString *)string
{
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i<string.length/26; i++) {
        NSString *temp = [string substringWithRange:NSMakeRange(0+26*i, 26)];
        [arr addObject:temp];
    }
    
    [self listenGateStatus:arr];
    
    [self listenGatePostion:arr];
    
    [self listenGatePoPostion:arr];
    
    [self listenGateCylinkerType:arr];

    [self.tableView reloadData];
    
}


/**
 *  @brief 监听阀针的状态
 *
 *  @param arr 数据源
 */
- (void)listenGateStatus:(NSMutableArray *)arr
{
    //监听是否开启
    NSString *str1 = @"08000005";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str1];
    NSString *str2 = @"4060000f000000";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str2];
    NSMutableArray *temp =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred2]];
    for (int j = 0; j<temp.count; j++) {
        NSString *gateNum = [temp[j] substringWithRange:NSMakeRange(8, 2)];
        
        //Default SDO server-to-client 服务数据对象“答“ 581h to 5FFh(580h +node-ID）
        NSString *decimalismNum = [NSString stringWithFormat:@"%i",[gateNum intValue]-80];
        [temp replaceObjectAtIndex:j withObject:decimalismNum];
    }
    
    
    NSSet *set = [NSSet setWithArray:temp];
    for (int i = 0; i <[set allObjects].count ; i++) {
        NSInteger index = [[set allObjects][i] integerValue]-1;
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = [SocketManager shareManager].values[j];
            if (j == index) {
                gate.gateSatus = GateStatus_Open;
            }
        }
    }
    
    //监听是否关闭
    NSString *str3 = @"40600000000000";
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str3];
    NSMutableArray *temp2 =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred3]];
    for (int j = 0; j<temp2.count; j++) {
        NSString *gateNum = [temp2[j] substringWithRange:NSMakeRange(8, 2)];
        NSString *decimalismNum = [NSString stringWithFormat:@"%i",[gateNum intValue]-80];
        [temp2 replaceObjectAtIndex:j withObject:decimalismNum];
    }
    NSSet *set2 = [NSSet setWithArray:temp2];
    for (int i = 0; i <[set2 allObjects].count ; i++) {
        NSInteger index = [[set2 allObjects][i] integerValue]-1;
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = [SocketManager shareManager].values[j];
            if (j == index) {
                gate.gateSatus = GateStatus_Close;
            }
        }
    }

}

/**
 *  @brief 监听阀针的位置
 *
 *  @param arr 数据源
 */
- (void)listenGatePostion:(NSMutableArray *)arr
{
    //080000058143003300ffffffff, 08000005824300330038000000
   
    NSString *str1 = @"08000005";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str1];
    NSString *str2 = @"003300";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str2];
    NSMutableArray *temp =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred2]];
    for (int i = 0; i<temp.count; i++) {
        NSString *str = temp[i];
        NSString *hexStr = [str substringWithRange:NSMakeRange(18, 8)];
        if ([hexStr isEqualToString:@"ffffffff"]) {
            hexStr = @"00000000";
        }
        NSString *position = [Utils convertHexStrToDecimalism:[Utils exchangeByteString:hexStr]];
            
        NSString *index = [temp[i] substringWithRange:NSMakeRange(8, 2)];
        
        //decimalismNum = gateNum
         NSString *decimalismNum = [NSString stringWithFormat:@"%i",[index intValue]-80];
        
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = [SocketManager shareManager].values[j];
            if (j == [decimalismNum intValue]-1) {
                gate.position = [NSString stringWithFormat:@"%.2f",[position floatValue]/100];
            }
        }

    }
    
    
}

/**
 *  @brief 监听位置1
 *
 *  @param arr 数据源
 */
- (void)listenGatePoPostion:(NSMutableArray *)arr
{
    
    NSString *str1 = @"08000005";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str1];
    NSString *str2 = @"203101";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str2];
    NSMutableArray *temp =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred2]];
    for (int i = 0; i<temp.count; i++) {
        NSString *str = temp[i];
        NSString *hexStr = [str substringWithRange:NSMakeRange(18, 8)];
        if ([hexStr isEqualToString:@"ffffffff"]) {
            hexStr = @"00000000";
        }
        NSString *po_position = [Utils convertHexStrToDecimalism:[Utils exchangeByteString:hexStr]];
        
        NSString *index = [temp[i] substringWithRange:NSMakeRange(8, 2)];
        
        //decimalismNum = gateNum
         NSString *decimalismNum = [NSString stringWithFormat:@"%i",[index intValue]-80];
        
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = [SocketManager shareManager].values[j];
            if (j == [decimalismNum intValue]-1) {
                gate.po_Postion = [NSString stringWithFormat:@"%.2f",[po_position floatValue]/100];
            }
        }
        
    }
    
}

/**
 *  @brief 机电类型
 *
 *  @param arr 数据源
 */
- (void)listenGateCylinkerType:(NSMutableArray *)arr
{
    
    NSString *str1 = @"08000005";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str1];
    NSString *str2 = @"026400";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str2];
    NSMutableArray *temp =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred2]];
    for (int i = 0; i<temp.count; i++) {
        NSString *str = temp[i];
        NSString *hexStr = [str substringWithRange:NSMakeRange(18, 8)];
        if ([hexStr isEqualToString:@"ffffffff"]) {
            hexStr = @"00000000";
        }
        NSString *cylinkerType = [Utils convertHexStrToDecimalism:[Utils exchangeByteString:hexStr]];
        
        NSString *index = [temp[i] substringWithRange:NSMakeRange(8, 2)];
        
        //decimalismNum = gateNum
        NSString *decimalismNum = [NSString stringWithFormat:@"%i",[index intValue]-80];
        
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = [SocketManager shareManager].values[j];
            if (j == [decimalismNum intValue]-1) {
                switch ([cylinkerType intValue]) {
                    case CylinkerType_TSC80:
                        gate.cylinkerType = CylinkerType_TSC80;
                        break;
                    case CylinkerType_TSC130:
                        gate.cylinkerType = CylinkerType_TSC130;
                        break;
                        
                    default:
                        break;
                }
            }
        }
        
    }
    
}




- (void)openGate:(NSInteger)gateNum
{
    NSString *command1 = @"08 00 00 06 00 2B 40 60 00 06 00 00 00";
    NSString *command2 = @"08 00 00 06 00 2B 40 60 00 07 00 00 00";
    NSString *command3 = @"08 00 00 06 00 2B 40 60 00 0F 00 00 00";
    NSString *num;

    if (gateNum<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)gateNum+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)gateNum+1]];
    }
    
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command3 = [command3 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];

    [SocketManager shareManager].sendArray = @[@[command1,command2,command3]];
    [[SocketManager shareManager] sendMessage];

}

- (void)closeGate:(NSInteger)gateNum
{
    NSString *command1 = @"08 00 00 06 00 2B 40 60 00 00 00 00 00";
    
    NSString *num;
    if (gateNum<15) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:(int)gateNum+1]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:(int)gateNum+1]];
    }
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    [SocketManager shareManager].sendArray = @[@[command1]];
    [[SocketManager shareManager] sendMessage];
    
}

/**
 *  @brief 手动开
 */
- (void)openAllGates
{
    NSMutableArray *subArr = [NSMutableArray array];
    NSMutableArray *sendArray = [NSMutableArray array];


    NSString *command1 = @"08 00 00 06 00 2B 07 30 00 00 00 00 00";
    NSString *command2 = @"08 00 00 06 00 2B 07 30 00 01 00 00 00";

    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        
        NSString *num;
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }
        command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        
        
        [subArr addObject:command1];
        [subArr addObject:command2];
        [sendArray addObject:subArr.copy];
        [subArr removeAllObjects];
    }
    
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:sendArray];
    [[SocketManager shareManager] sendMessage];

}

/**
 *  @brief 手动关
 */
- (void)closeAllGates
{
    NSMutableArray *subArr = [NSMutableArray array];
    NSMutableArray *sendArray = [NSMutableArray array];
    
    
    NSString *command1 = @"08 00 00 06 00 2B 07 30 00 00 00 00 00";
    NSString *command2 = @"08 00 00 06 00 2B 07 30 00 02 00 00 00";
    
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        
        NSString *num;
        if (i<15) {
            num = [NSString stringWithFormat:@"0%@",[Utils convertDecimalismToHexStr:i+1]];
        }else
        {
            num = [NSString stringWithFormat:@"%@",[Utils convertDecimalismToHexStr:i+1]];
        }
        command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        
        
        [subArr addObject:command1];
        [subArr addObject:command2];
        [sendArray addObject:subArr.copy];
        [subArr removeAllObjects];
    }
    
    [SocketManager shareManager].sendArray = [NSArray arrayWithArray:sendArray];
    [[SocketManager shareManager] sendMessage];

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
    return [SocketManager shareManager].model.linkNum;
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
    if (section == [SocketManager shareManager].model.linkNum-1) {
        return 18*Ratio;
    }
    return CGFLOAT_MIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AutoCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AutoCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell configCellWithIndexPath:indexPath Values:[SocketManager shareManager].values];
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"select section = %li,row = %li",(long)indexPath.section,(long)indexPath.row);
    
    self.selectIndex = indexPath.section;
    [self performSegueWithIdentifier:@"GateConfig" sender:self];
}


#pragma mark - AutoCellDelegate

- (void)powerBtnDidTap:(NSInteger)section inCell:(AutoCell *)cell
{
    Gate *gate = [SocketManager shareManager].values[section];
    switch (gate.gateSatus) {
        case GateStatus_Open:
//            gate.gateSatus = GateStatus_Close;
            [self closeGate:section];

            break;
        case GateStatus_Close:
//            gate.gateSatus = GateStatus_Open;
            [self openGate:section];

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
    if ([segue.identifier isEqualToString:@"GateConfig"]) {
        GateConfigViewController *vc = segue.destinationViewController;
        vc.selectIndex = _selectIndex;
        vc.title = [NSString stringWithFormat:@"%@%li",Localized(@"Gate"),(long)self.selectIndex+1];
    }
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:didConnectToHost:%@ port:%hu", host, port);
    
    //    [SVProgressHUD showSuccessWithStatus:@"已连接" dismissAfterDelay:1];
    
    if ([SocketManager shareManager].sendArray.count) {
        [[SocketManager shareManager] sendMessage];
    }
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
//    NSLog(@"socket:didWriteDataWithTag:");
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
//    NSLog(@"socket:didReadData:withTag:");
//    
//    NSLog(@"%@",[Utils convertDataToHexStr:data]);
    
    [self listenReceivedData:[Utils convertDataToHexStr:data]];
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    // Since we requested HTTP/1.0, we expect the server to close the connection as soon as it has sent the response.
    
    NSLog(@"socketDidDisconnect:withError: \"%@\"", err);
    //    [SVProgressHUD showErrorWithStatus:@"已断开连接" dismissAfterDelay:1];
    
    [[SocketManager shareManager] openSocket];
    
    
}

- (void)socket:(GCDAsyncSocket *)sock didWritePartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    NSLog(@"Received bytes: %lu",(unsigned long)partialLength);
}


#pragma mark - Actions

/**
 *  @brief 手动（开／关）
 *
 *  @param sender self
 */
- (IBAction)Switch1Action:(id)sender {
    if (self.Switch2.on == NO && self.Switch1.on == YES) {
        [self openAllGates];
    }
    else if(self.Switch2.on == NO && self.Switch1.on == NO)
    {
        [self closeAllGates];
    }
}

/**
 *  @brief 手动／换色
 *
 *  @param sender self
 */
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


@end
