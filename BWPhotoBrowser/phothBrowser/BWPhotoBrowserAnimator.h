//
//  BWPhotoBrowserAnimator.h
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BWRootCVC.h"
//提供从控制器到照片浏览器的转场动画

@interface BWPhotoBrowserAnimator : NSObject
//动画播放起始位置
@property (nonatomic,assign) CGRect rect;
//动画播放目标位置
@property (nonatomic,assign) CGRect fullRect;
//视图图像URL
@property (nonatomic,copy)NSString * url;
//动画播放图像视图
@property (nonatomic,strong) UIImageView * imageView;



-(void)prepareForBrowser:(NSString *)url : (CGRect) rect : (CGRect) fullRect :(BWRootCVC *)collectionCVC;

@end
