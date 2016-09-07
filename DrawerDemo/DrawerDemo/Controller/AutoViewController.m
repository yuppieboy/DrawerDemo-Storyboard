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



@interface AutoViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate,BaseVCDelegate,AutoCellDelegate,GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *values;
@property (nonatomic,assign) NSInteger selectIndex;

@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UILabel *footLabel1;
@property (weak, nonatomic) IBOutlet UILabel *footLabel2;
@property (weak, nonatomic) IBOutlet UILabel *footLabel3;
@property (weak, nonatomic) IBOutlet UISwitch *Switch1;
@property (weak, nonatomic) IBOutlet UISwitch *Switch2;
@property (weak, nonatomic) IBOutlet UITextField *timesTextField;

@property (nonatomic,assign)float currentOffSet;

@property (nonatomic,strong) NSArray *sendArray;
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


    self.tableView.contentInset=UIEdgeInsetsMake(0, 15, footViewHeight, -15);
    [self.footView setFrame:CGRectMake(0, TTScreenHeight-footViewHeight, TTScreenWidth, footViewHeight)];
    [self.view addSubview:self.footView];
    
    [self Switch2Action:self.Switch2];
    
    if (![SocketManager shareManager].model) {
        [self performSelector:@selector(pushLoginVC) withObject:nil afterDelay:0.1];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:kNotification_Login object:nil];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotification_Login object:nil];
    [self.timer invalidate];
}


#pragma mark - Private Method

- (NSMutableArray *)values
{
    if (!_values) {
        _values = [[NSMutableArray alloc]init];
    }
    return _values;
}

- (NSArray *)sendArray
{
    if (!_sendArray) {
        _sendArray = [[NSArray alloc]init];
    }
    return _sendArray;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(fetchGatesInfo) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)sendMessage
{
    
    if ([[SocketManager shareManager].asyncSocket isConnected]) {
        
        for (int i = 0; i< MIN(self.sendArray.count, [SocketManager shareManager].model.linkNum); i++) {
            
            NSArray *temp = self.sendArray[i];
            
            NSMutableString *string = [[NSMutableString alloc]init];
            
            for (int j = 0; j < temp.count; j++) {
                
                if (j < temp.count - 1) {
                    [string appendString:[NSString stringWithFormat:@"%@ ",self.sendArray[i][j]]];
                }else
                {
                    [string appendString:[NSString stringWithFormat:@"%@",self.sendArray[i][j]]];
                }
                
            }
            
            NSData *requestData = [Utils convertHexStrToData:string];
            
            [[SocketManager shareManager].asyncSocket writeData:requestData withTimeout:-1 tag:0];
            [[SocketManager shareManager].asyncSocket readDataWithTimeout:-1 tag:0];
            
        }
        
    }
    
}


- (void)loginSuccess
{
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        Gate *gate = [[Gate alloc]init];
        gate.gateSatus = GateStatus_Close;
        gate.pinStatus = arc4random()%3;
        gate.position = @"0";
        gate.dForce = @"0";
        gate.cTime = @"0";
        gate.oTime = @"0";
        [self.values addObject:gate];
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
}

/**
 *  @brief 获取阀针开关状态信息
 */
- (void)getGateStatusInfo
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *command = @"08 00 00 06 00 40 40 60 00 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        if (i<15) {
            num = [Utils convertHexStrToDecimalism:[NSString stringWithFormat:@"0%i",i+1]];
        }else
        {
            num = [Utils convertHexStrToDecimalism:[NSString stringWithFormat:@"%i",i+1]];
        }

        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    self.sendArray = [NSArray arrayWithArray:arr];
    [self sendMessage];

}

/**
 *  @brief 获取阀针位置信息
 */
- (void)getGatePositionInfo
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    NSString *command = @"08 00 00 06 00 40 00 33 00 00 00 00 00";
    for (int i = 0; i < [SocketManager shareManager].model.linkNum; i++) {
        NSString *num;
        
        if (i<15) {
            num = [Utils convertHexStrToDecimalism:[NSString stringWithFormat:@"0%i",i+1]];
        }else
        {
            num = [Utils convertHexStrToDecimalism:[NSString stringWithFormat:@"%i",i+1]];
        }
        NSString *str = [command stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
        NSArray *temp = [NSArray arrayWithObjects:str, nil];
        [arr addObject:temp];
    }
    self.sendArray = [NSArray arrayWithArray:arr];
    [self sendMessage];
    
}



- (void)listenReceivedData:(NSString *)string
{
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i<string.length/26; i++) {
        NSString *temp = [string substringWithRange:NSMakeRange(0+26*i, 26)];
        [arr addObject:temp];
    }
    
    [self listenGateStatus:arr];
    
    [self listenGatePostion:arr];

    [self.tableView reloadData];

}


/**
 *  @brief 监听阀针的状态
 *
 *  @param arr 数据源
 */
- (void)listenGateStatus:(NSMutableArray *)arr
{
    NSString *str1 = @"08000005";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str1];
    NSString *str2 = @"4060000f000000";
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str2];
    NSMutableArray *temp =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred2]];
    for (int j = 0; j<temp.count; j++) {
        NSString *gateNum = [temp[j] substringWithRange:NSMakeRange(8, 2)];
        
        //Default SDO server-to-client 服务数据对象“答“ 581h to 5FFh(580h +node-ID）
        NSString *decimalismNum = [NSString stringWithFormat:@"%i",[[Utils convertHexStrToDecimalism:gateNum] intValue]-[[Utils convertHexStrToDecimalism:@"80"] intValue]];
        [temp replaceObjectAtIndex:j withObject:decimalismNum];
    }
    
    
    NSSet *set = [NSSet setWithArray:temp];
    for (int i = 0; i <[set allObjects].count ; i++) {
        NSInteger index = [[set allObjects][i] integerValue]-1;
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = self.values[j];
            if (j == index) {
                gate.gateSatus = GateStatus_Open;
            }
        }
    }
    
    NSString *str3 = @"40600000000000";
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",str3];
    NSMutableArray *temp2 =[NSMutableArray arrayWithArray:[[arr filteredArrayUsingPredicate:pred1] filteredArrayUsingPredicate:pred3]];
    for (int j = 0; j<temp2.count; j++) {
        NSString *gateNum = [temp2[j] substringWithRange:NSMakeRange(8, 2)];
        NSString *decimalismNum = [NSString stringWithFormat:@"%i",[[Utils convertHexStrToDecimalism:gateNum] intValue]-[[Utils convertHexStrToDecimalism:@"80"] intValue]];
        [temp2 replaceObjectAtIndex:j withObject:decimalismNum];
    }
    NSSet *set2 = [NSSet setWithArray:temp2];
    for (int i = 0; i <[set2 allObjects].count ; i++) {
        NSInteger index = [[set2 allObjects][i] integerValue]-1;
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = self.values[j];
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
        
        NSString *index = [temp[i] substringWithRange:NSMakeRange(9, 1)];
        for (int j = 0; j < [SocketManager shareManager].model.linkNum; j++) {
            Gate *gate = self.values[j];
            if (j == [index intValue]-1) {
                gate.position = [NSString stringWithFormat:@"%.2f",[position floatValue]/100];
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
    NSString *temp = [NSString stringWithFormat:@"%li",gateNum+1];

    if (gateNum<16) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertHexStrToDecimalism:temp]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertHexStrToDecimalism:temp]];
    }
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command2 = [command2 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    command3 = [command3 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];

    self.sendArray = @[@[command1,command2,command3]];
    [self sendMessage];

}

- (void)closeGate:(NSInteger)gateNum
{
    NSString *command1 = @"08 00 00 06 00 2B 40 60 00 00 00 00 00";
    
    NSString *num;
    NSString *temp = [NSString stringWithFormat:@"%li",gateNum+1];
    if (gateNum<16) {
        num = [NSString stringWithFormat:@"0%@",[Utils convertHexStrToDecimalism:temp]];
    }else
    {
        num = [NSString stringWithFormat:@"%@",[Utils convertHexStrToDecimalism:temp]];
    }
    command1 = [command1 stringByReplacingCharactersInRange:NSMakeRange(12, 2) withString:num];
    
    self.sendArray = @[@[command1]];
    [self sendMessage];
    
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
    [cell configCellWithIndexPath:indexPath Values:self.values];
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
    Gate *gate = self.values[section];
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
        vc.title = [NSString stringWithFormat:@"%@%li",Localized(@"Gate"),(long)self.selectIndex];
    }
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"socket:didConnectToHost:%@ port:%hu", host, port);
    
    //    [SVProgressHUD showSuccessWithStatus:@"已连接" dismissAfterDelay:1];
    
    if (self.sendArray.count) {
        [self sendMessage];
    }
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"socket:didWriteDataWithTag:");
}


- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
    NSLog(@"socket:didReadData:withTag:");
    
    NSLog(@"%@",[Utils convertDataToHexStr:data]);
    
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
