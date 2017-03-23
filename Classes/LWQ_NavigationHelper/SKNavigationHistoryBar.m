//
//  SKNavigationHistoryBar.m
//  SKNavigationControllerProject
//
//  Created by Selçuk Kızılkaya on 4/4/13.
//  Copyright (c) 2013 Selçuk Kızılkaya. All rights reserved.
//  slckkzlky@gmail.com

#import "SKNavigationHistoryBar.h"
#import "UIView+SKAnimate.h"
#import "LWQNavigationHelper.h"

#define kCTFontColor [UIColor colorWithRed:51/255.f green:51/255.f blue:51/255.f alpha:1.f]

@interface SKNavigationHistoryBar ()<UIGestureRecognizerDelegate>
{
    UINavigationController * _navigationController;
    UIScrollView * _scrollView;
    CGFloat _contentSize;
    CGFloat _X;
    CGFloat _Y;
}
@property (nonatomic, strong)UILabel * titleLab;
@end

@implementation SKNavigationHistoryBar

#pragma mark - dealloc
- (void) dealloc {
    _navigationController = nil;
    _scrollView = nil;
}

-(UILabel *)titleLab{
    if (_titleLab == nil) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, -23, CGRectGetWidth(self.frame), 23)];
        _titleLab.text = @"请选择您要返回的界面";
        _titleLab.textColor = kCTFontColor;
        _titleLab.textAlignment = NSTextAlignmentCenter;
        _titleLab.font = [UIFont systemFontOfSize:12];
        
        _titleLab.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
        _titleLab.layer.shadowOffset = CGSizeMake(0, -10);//偏移距离
        _titleLab.layer.shadowOpacity = 0.5;//不透明度
        _titleLab.layer.shadowRadius = 5.0;//半径
        
//        _titleLab.backgroundColor = RGB(255, 245, 238);
        
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:_titleLab.bounds];
        toolbar.barStyle = UIBarStyleDefault;
        [_titleLab addSubview:toolbar];
    }
    return _titleLab;
}

#pragma mark - init
- (id)initWithFrame:(CGRect)frame nController:(UINavigationController *) nController {
    self = [super initWithFrame:frame];
    if (self) {
        UIToolbar * toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.barStyle = UIBarStyleDefault;
        [self addSubview:toolbar];
        
        _navigationController = nController;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_scrollView setScrollEnabled:YES];
        _scrollView.scrollsToTop = NO;
        _scrollView.delaysContentTouches = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.autoresizesSubviews = NO;
        _contentSize = 0;
        [self addSubview:_scrollView];
        
        //标题
        [self addSubview:self.titleLab];
        [self renderUI];
    }
    return self;
}

#pragma mark - UI
- (void) renderUI {
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < [_navigationController.viewControllers count] - 1; i++) {
        UIViewController * viewController = [_navigationController.viewControllers objectAtIndex:i];
            UIImageView * imageView = [self createImageViewForViewController:viewController tag:i];
            [_scrollView addSubview:imageView];
    }
    [_scrollView setContentSize:CGSizeMake(_contentSize, self.frame.size.height)];
}

- (void) changeInterfaceOrientation:(CGRect) rect {
    _scrollView.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    self.frame = rect;
}

- (void) swapViews:(NSInteger) tag {
    UIView * view = [_scrollView viewWithTag:(tag + 1)];
    if (!view) {
        return;
    }
    UIView * removedView = [_scrollView viewWithTag:tag];
    UIView * nextView = [_scrollView viewWithTag:(tag + 1)];
    NSInteger diff = nextView.frame.origin.x - removedView.frame.origin.x;
    NSInteger count = [_scrollView.subviews count];
    for (NSInteger i = (tag+1); i<=count; i++) {
        UIView * next = [_scrollView viewWithTag:i];
        CGRect f = next.frame;
        [next animateWithRect:CGRectMake(f.origin.x - diff, f.origin.y, f.size.width, f.size.height)];
    }
    _contentSize -= diff;
    for (NSInteger i = tag ; i <= count; i++) {
        UIView * next = [_scrollView viewWithTag:i];
        next.tag -= 1;
    }
}

#pragma mark - Events
- (void) panGestureRecognizer:(UIPanGestureRecognizer *) sender {
    [_scrollView bringSubviewToFront:[(UIPanGestureRecognizer*)sender view]];
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:_scrollView];
    
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _X = [[sender view] frame].origin.x;
        _Y = [[sender view] frame].origin.y;
    }
    if (_Y + translatedPoint.y > 0) {
        [sender.view animateWithRect:CGRectMake(_X, _Y, sender.view.frame.size.width, sender.view.frame.size.height)];
        return;
    }
    sender.view.frame = CGRectMake(_X, _Y + translatedPoint.y, sender.view.frame.size.width, sender.view.frame.size.height);
    if ([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        [sender.view animateWithRect:CGRectMake(_X, _Y, sender.view.frame.size.width, sender.view.frame.size.height)];
        if ((_Y + translatedPoint.y) < -(_scrollView.frame.size.height/2-20)) {
            //保证根视图不移除
            if (sender.view.tag-1 != 0) {
                [self removeViewControllerWithTag:sender.view.tag-1];
                [self swapViews:sender.view.tag];
                [sender.view removeFromSuperview];
                [sender.view removeGestureRecognizer:sender];
                [_scrollView setContentSize:CGSizeMake(_contentSize, self.frame.size.height)];
            }
        }
    }
}

- (void) imageTapped:(UITapGestureRecognizer *) sender {
    NSInteger tag = sender.view.tag-1;
    NSMutableArray * vController = [NSMutableArray array];

    for (NSInteger i = 0; i <= tag ; i++) {
        [vController addObject:[_navigationController.viewControllers objectAtIndex:i]];
    }
    [vController addObject:[_navigationController.viewControllers lastObject]];
    [_navigationController setViewControllers:vController];
//    [_navigationController closeHistoryBar];
    [_navigationController.topViewController.navigationController popViewControllerAnimated:YES];
    [[LWQNavigationHelper sharedInstace] closeHistoryBar];
    
}

#pragma mark - Util
- (void) removeViewControllerWithTag:(NSInteger) tag {
    NSMutableArray * vController = [NSMutableArray arrayWithArray:_navigationController.viewControllers];
    [vController removeObjectAtIndex:tag];
    [_navigationController setViewControllers:vController];
    if ([vController  count] == 1) {
        _navigationController.topViewController.navigationItem.leftBarButtonItem = nil;
//        [_navigationController closeHistoryBar];
        [[LWQNavigationHelper sharedInstace] closeHistoryBar];
    }
}

- (UIPanGestureRecognizer *) panGestureRecognizer {
    UIPanGestureRecognizer *recognizer = nil;
    recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    recognizer.delegate = self;
    return recognizer;
}

- (UIImageView *) createImageViewForViewController:(UIViewController *) viewController tag:(NSInteger) tag {
    CGFloat height = self.frame.size.height;
    CGFloat w = 0;
    
    CGFloat padding = 10;
    height -= padding;
    
    _contentSize += padding;
    UIImage * image = [self captureScreenInRect:viewController.view];
    CGFloat ratio = image.size.width/image.size.height;
    
    image = [self resizeImage:image size:CGSizeMake(height*ratio, height)];
    
    w = (height + 5) * ratio;
    
    UIImageView * imageView = [[UIImageView alloc] init];
    imageView.autoresizingMask = UIViewAutoresizingNone;

    imageView.tag = tag + 1;
    imageView.image = image;
    [imageView setUserInteractionEnabled:YES];
    
    imageView.frame = CGRectMake( _contentSize, padding/2, height*ratio, height);
    _contentSize +=  w;
    [imageView addGestureRecognizer:[self panGestureRecognizer]];
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)]];
    
    if ([viewController respondsToSelector:@selector(title)] && viewController.title && ![viewController.title isEqualToString:@""]) {
        UILabel * lbl = [[UILabel alloc] init];
        lbl.frame = CGRectMake(0, imageView.frame.size.height - 20, imageView.frame.size.width, 20);
        lbl.backgroundColor = [UIColor blackColor];
        lbl.textColor = [UIColor whiteColor];
        lbl.font = [UIFont fontWithName:@"Helvetica" size:12];
        [lbl setTextAlignment:NSTextAlignmentCenter];
        lbl.text = viewController.title;
        [imageView addSubview:lbl];
    }
    
    return imageView;
}

- (UIImage *) captureScreenInRect:(UIView *) view {
    CALayer *layer;
    layer = view.layer;
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextClipToRect (UIGraphicsGetCurrentContext(),view.frame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

- (UIImage*) resizeImage:(UIImage*)image size:(CGSize)size {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        size = CGSizeMake(size.width*2, size.height*2);
    } 
    
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
