//
//  LoginViewController.m
//  DrawerDemo
//
//  Created by paul on 16/9/6.
//  Copyright © 2016年 weiwend. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tf_IP;
@property (weak, nonatomic) IBOutlet UITextField *tf_Port;
@property (weak, nonatomic) IBOutlet UITextField *tf_LinkNum;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"登录";
}
- (IBAction)loginTappedAction:(id)sender {
     NSString *ip = [self.tf_IP.text stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSString *port = [self.tf_Port.text stringByReplacingOccurrencesOfString:@" " withString:@""];
     NSString *linkNum = [self.tf_LinkNum.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (ip.length == 0 || port.length == 0 || linkNum.length == 0) {
        return;
    }
    
    SocketModel *model = [[SocketModel alloc]init];
    model.hostName = ip;
    model.port = [port intValue];
    model.linkNum = [linkNum intValue];
    [SocketManager shareManager].model = model;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kNotification_Login object:nil];
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
