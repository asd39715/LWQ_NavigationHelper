//
//  LWQNavigationHelper.h
//  CTAppTest
//
//  Created by liwangqiang on 16/8/2.
//  Copyright © 2016年 liwangqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface LWQNavigationHelper : NSObject

// 单例方法
+ (LWQNavigationHelper *)sharedInstace;

- (void) showHistoryBar:(UIView *)view navController:(UINavigationController *)navContoller;
- (void) closeHistoryBar;

@end
