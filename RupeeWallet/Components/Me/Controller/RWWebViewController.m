//
//  RWWebViewController.m
//  RupeeWallet
//
//  Created by Tim Guo on 2023/9/19.
//

#import "RWWebViewController.h"
#import <WebKit/WebKit.h>


@interface RWWebViewController ()

@end

@implementation RWWebViewController


- (void)setupUI {
    [super setupUI];
    WKWebView *webView = [[WKWebView alloc] init];
    [self.view addSubview:webView];
    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(20);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    
    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.rupeewallet.net/privacy.html"]]];
}

@end
