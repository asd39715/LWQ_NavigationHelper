//
//  LWQNavigationHelper.m
//  CTAppTest
//
//  Created by liwangqiang on 16/8/2.
//  Copyright © 2016年 liwangqiang. All rights reserved.
//

#import "LWQNavigationHelper.h"
#import "SKNavigationHistoryBar.h"
#import "UIView+SKAnimate.h"

//动态获取设备高度
#define IPHONE_HEIGHT [UIScreen mainScreen].bounds.size.height
//动态获取设备宽度
#define IPHONE_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LWQNavigationHelper ()
{
    SKNavigationHistoryBar * _historyBar;
    int _height;
}

@property (nonatomic, strong)UIButton * backgroundButton;

@end

@implementation LWQNavigationHelper

// 单例
static LWQNavigationHelper * manager = nil;
+ (LWQNavigationHelper *)sharedInstace{
    //线程安全，防止使用多个线程或者队列时不同步的问题
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager == nil) {
            manager = [[LWQNavigationHelper alloc] init];
        }
    });
    return manager;
}

-(UIButton *)backgroundButton{
    if (_backgroundButton == nil) {
        _backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backgroundButton.frame = CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT);
        _backgroundButton.backgroundColor = [UIColor colorWithRed:60/255.0 green:60/255.0 blue:60/255.0 alpha:0.2];
        _backgroundButton.hidden = NO;
        [_backgroundButton addTarget:self action:@selector(backgroundAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

-(void)backgroundAction:(UIButton *)button{
    if (button.selected) {
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundButton.hidden = YES;
        } completion:^(BOOL finished) {}];
    }else{
        
        [UIView animateWithDuration:0.2 animations:^{
            _historyBar.frame = CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, 0);
        } completion:^(BOOL finished) {
            [self closeHistoryBar];
            [self.backgroundButton removeFromSuperview];
            self.backgroundButton = nil;
        }];
    }
}

- (void) showHistoryBar:(UIView *)view
          navController:(UINavigationController *)navContoller{
    
    if (navContoller.viewControllers.count == 1) {
    }else{
        [self closeHistoryBar];
        _height = 150;
        if (!_historyBar) {
            _historyBar = [[SKNavigationHistoryBar alloc] initWithFrame:CGRectMake(0, IPHONE_HEIGHT, IPHONE_WIDTH, _height)
                                                            nController:navContoller];
            [_historyBar setUserInteractionEnabled:YES];
            [self.backgroundButton addSubview:_historyBar];
            [view addSubview:self.backgroundButton];
            [_historyBar animateWithRect:CGRectMake(0, IPHONE_HEIGHT-_height, IPHONE_WIDTH, _height)];
            
        } else {
            [self closeHistoryBar];
        }
    }
}

- (void) closeHistoryBar{
    if (_historyBar) {
        [_historyBar removeFromSuperview];
        _historyBar = nil;
    }
}

@end
