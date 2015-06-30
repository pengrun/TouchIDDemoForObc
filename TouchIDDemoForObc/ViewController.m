//
//  ViewController.m
//  TouchIDDemoForObc
//
//  Created by MH-Pengrun on 15/6/27.
//  Copyright (c) 2015年 MH. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
@interface ViewController ()
@property (nonatomic, strong) UIViewController *loginVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)ClickButton:(UIButton *)sender {
    LAContext *locationAuth = [[LAContext alloc] init];
    NSError *error = nil;
    
    //1、检查指纹识别是否可用
    BOOL isAviailable = [locationAuth canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    NSLog(@"错误信息:%@",error);
    
    if (isAviailable) {
        NSLog(@"指纹识别可用");
        //2、获取指纹验证结果
        [locationAuth evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"指纹验证成功");
                //后续操作
            } else {
                //验证错误3次则锁定，错误5此输入密码
                NSLog(@"指纹验证失败:%@,code:%d",error.localizedDescription,error.code);
                
                switch (error.code) {
                    case -1:
                        NSLog(@"超过重试次数 Application retry limit exceeded");
                        break;
                    case -2:
                        NSLog(@"用户取消 Canceled by user");
                        break;
                    case -3:
                        NSLog(@"选择密码验证 Fallback authentication mechanism selected");
                        break;
                    case -4:
                        NSLog(@"kLAErrorSystemCancel");
                        break;
                    case -5:
                        NSLog(@"kLAErrorPasscodeNotSet");
                        break;
                    case -6:
                        NSLog(@"kLAErrorTouchIDNotAvailable");
                        break;
                    case -7:
                        NSLog(@"kLAErrorTouchIDNotEnrolled");
                        break;
                        
                    default:
                        break;
                }
            }
        }];
    } else {
        NSLog(@"无法开启指纹识别");
    }
}

- (void)login {
    UIViewController *loginVC = [[UIViewController alloc] init];
    loginVC.view.backgroundColor = [UIColor yellowColor];
    loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close)];
    self.loginVC = loginVC;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)close
{
    [self.loginVC dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
