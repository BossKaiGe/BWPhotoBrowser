//
//  BWPhotoBrowserCell.m
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//

#import "BWPhotoBrowserCell.h"
#import <SVProgressHUD.h>
#import <UIImageView+WebCache.h>
@interface BWPhotoBrowserCell()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * scrollView;

@end
@implementation BWPhotoBrowserCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        [self setupUI];
        return self;
    }
    return nil;
}
-(void)setupUI
{
    [self addSubview:self.scrollView];
    self.scrollView.delegate = self;
   
    [self.scrollView addSubview:self.imageView];
    
  
}
-(void)resetImageView
{
    CGSize size = [self displaySize];
    self.imageView.frame = CGRectMake(0, 0, size.width, size.height);
    if (size.height > self.scrollView.bounds.size.height){
        self.scrollView.contentSize = size;
    }else{
        CGFloat y = (self.scrollView.bounds.size.height - size.height)*0.5;
       
        self.scrollView.contentInset = UIEdgeInsetsMake(y, 0, 0, 0);
       
    }
}
-(CGSize)displaySize
{
    [self.imageView sizeToFit];
    CGFloat alpha = self.imageView.bounds.size.height/self.imageView.bounds.size.width;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * alpha;
    return  CGSizeMake(width, height);
}
-(UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]init];
    }
    return _imageView;
}
-(UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = self.bounds;
        _scrollView.minimumZoomScale = 0.5;
        _scrollView.maximumZoomScale = 2;
        
    }
    return _scrollView;
}
-(void)setImageUrl:(NSString *)imageUrl
{
    //重置scrollView
    [self resetScrollView];
    if (_imageUrl == nil) {
        _imageUrl = [NSString string];
    }
    _imageUrl = imageUrl;
    __weak typeof(self) weakself = self;
    [self.imageView sd_setImageWithURL:imageUrl placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error != nil) {
            [SVProgressHUD showErrorWithStatus:@"您的网络不给力"];
        }
        
        [weakself resetImageView];
    }];
}
//重置 scrollView的内容属性，因为缩放会影响到内容属性
-(void)resetScrollView{
    self.scrollView.contentSize = CGSizeZero;
    self.scrollView.contentInset = UIEdgeInsetsZero;
    self.scrollView.contentOffset = CGPointZero;
}
#pragma mark :UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    //缩放完成后调整图片位置使其居中
    
    CGFloat offsetY = (scrollView.bounds.size.height - view.frame.size.height) * 0.5;
    CGFloat offsetX = (scrollView.bounds.size.width - view.frame.size.width) * 0.5;
    offsetY = (offsetY < 0) ? 0 : offsetY;
    offsetX = (offsetX < 0) ? 0 : offsetX;
    scrollView.contentSize = view.frame.size;
    scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
}


@end










