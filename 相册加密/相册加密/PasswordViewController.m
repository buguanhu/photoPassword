//
//  PasswordViewController.m
//  相册加密
//
//  Created by siluo on 2017/7/17.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "PasswordViewController.h"
#import "PhotoViewController.h"

@interface PasswordViewController ()<UITextFieldDelegate>

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.passwordTextField becomeFirstResponder];
    
    self.informationLabel.text = @"请设置四位密码";
    
    // Do any additional setup after loading the view from its nib.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField.text.length < 4) {
        return YES;
    }else{
        return NO;
    }
    
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//
//    if (textField.text.length == 4) {
//        
//        PhotoViewController *vc = [[PhotoViewController alloc] init];
//       
//        [UIApplication sharedApplication].keyWindow.rootViewController = vc;
//        
//    }
//    
//}

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
