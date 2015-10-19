//
//  BWPhotoBrowserAnimator.m
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "BWPhotoBrowserAnimator.h"
#import <UIImageView+WebCache.h>
@interface BWPhotoBrowserAnimator()<UIViewControllerTransitioningDelegate,UIViewControllerContextTransitioning>
@property (nonatomic,assign)BOOL isPresented;
@end
@implementation BWPhotoBrowserAnimator
bool isPresent = false;
-(instancetype)init
{
    if ([super init]) {
        self.isPresented = false;
        return self;
    }
    return nil;
}
//dismiss时候调用
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresented = true;
    return (id<UIViewControllerAnimatedTransitioning>)self;
}
//present时候调用
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresented = false;
    return (id<UIViewControllerAnimatedTransitioning>)self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    
    return 1;
}
/// 专门实现转场动画效果 - 一旦实现了此方法，程序员必须完成动画效果
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{

    
    !self.isPresented ? [self presentAnima:transitionContext]:[self dismissAnima:transitionContext] ;
}
-(void)dismissAnima:(id <UIViewControllerContextTransitioning>)transitionContext{
    UIView * fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        [fromView removeFromSuperview];
        [transitionContext completeTransition:YES];
    }];
    
}
-(void)presentAnima:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    //1、将imageView添加到 容器视图
    [[transitionContext containerView] addSubview:self.imageView];
    self.imageView.frame = self.rect;
    [self.imageView sd_setImageWithURL:self.url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            NSLog(@"%@",error);
            [transitionContext completeTransition:YES];
            return ;
        }
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.imageView.frame = self.fullRect;
        } completion:^(BOOL finished) {
            UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
            [[transitionContext containerView] addSubview:toView];
            [self.imageView removeFromSuperview];
            [transitionContext completeTransition:YES];
        }];
    }];
    
    //2、 用SDWebImage异步下载图像
//    UIView * toView = [transitionContext viewForKey:UITransitionContextToViewKey];
//    toView.alpha = 0;
//    
//    UIView * containerView = [transitionContext containerView];
//    [containerView addSubview:toView];
//    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
//        toView.alpha = 1;
//    } completion:^(BOOL finished) {
//        [transitionContext completeTransition:YES];
//    }];
}

-(void)prepareForBrowser:(NSString *)url : (CGRect) rect : (CGRect) fullRect
{
    self.url = url;
    self.rect = rect;
    self.fullRect = fullRect;
    
    self.imageView.frame = rect;
    [self.imageView sd_setImageWithURL:url];
    
}
-(NSString *)url
{
    if (_url == nil) {
        _url = [NSString string];
    }
    return  _url;
}

-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
@end















