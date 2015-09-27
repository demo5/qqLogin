//
//  ViewController.m
//  qqLogin
//
//  Created by YoKing on 15/9/26.
//  Copyright © 2015年 YK. All rights reserved.
//

#import "ViewController.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ViewController ()<TencentSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) TencentOAuth* tencentOAuth;
@property (weak, nonatomic) IBOutlet UILabel *labelAccessToken;
@property (weak, nonatomic) IBOutlet UIWebView *userPhoto;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)qqLogin:(id)sender {
    
//    TencentOAuth *tencentOAuth = [[TencentOAuth alloc] init];
    _tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"1104809077" andDelegate:self]; //注册
    
    NSArray *_permissions = [NSArray arrayWithObjects:kOPEN_PERMISSION_GET_INFO, kOPEN_PERMISSION_GET_USER_INFO, kOPEN_PERMISSION_GET_SIMPLE_USER_INFO, nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];//授权
}

- (void)tencentDidLogin
{
    _labelTitle.text = @"登录完成";
    [_tencentOAuth getUserInfo];
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length]){
        //  记录登录用户的OpenID、Token以及过期时间
        _labelAccessToken.text = _tencentOAuth.accessToken;
        
    }else{
        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
}

-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        _labelTitle.text = @"用户取消登录";
    }else{
        _labelTitle.text = @"登录失败";
    }
}

-(void)tencentDidNotNetWork
{
    _labelTitle.text=@"无网络连接，请设置网络";
}

-(void)getUserInfoResponse:(APIResponse *)response
{
//       NSLog(@"respons:%@",response.jsonResponse);
    
    NSURL *url = [NSURL URLWithString:[response.jsonResponse objectForKey:@"figureurl_qq_2"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_userPhoto loadRequest:request];
    
    NSString *string = [[response.jsonResponse objectForKey:@"province"] stringByAppendingString:[response.jsonResponse objectForKey:@"city"]];
    
    self.labelTitle.text = [response.jsonResponse objectForKey:@"nickname"];
    self.labelAccessToken.text = string;
}

@end
