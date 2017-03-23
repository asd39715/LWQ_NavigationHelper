//
//  SKNavigationHistoryBar.h
//  SKNavigationControllerProject
//
//  Created by Selçuk Kızılkaya on 4/4/13.
//  Copyright (c) 2013 Selçuk Kızılkaya. All rights reserved.
//  slckkzlky@gmail.com

#import <UIKit/UIKit.h>
#include <QuartzCore/QuartzCore.h>

@interface SKNavigationHistoryBar : UIView 

- (id)initWithFrame:(CGRect)frame nController:(UINavigationController *) nController;
- (void)changeInterfaceOrientation:(CGRect) rect;
- (void)renderUI;
- (void)swapViews:(NSInteger) tag;
- (void)panGestureRecognizer:(UIPanGestureRecognizer *) sender;
- (void)imageTapped:(UITapGestureRecognizer *) sender;
- (void)removeViewControllerWithTag:(NSInteger) tag;
- (UIImageView *)createImageViewForViewController:(UIViewController *) viewController tag:(NSInteger) tag;
- (UIImage *)captureScreenInRect:(UIView *) view;
- (UIPanGestureRecognizer *) panGestureRecognizer;
- (UIImage*)resizeImage:(UIImage*)image size:(CGSize)size;

@end
