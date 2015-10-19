//
//  BWPhotoBrowserVC.m
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//

#import "BWPhotoBrowserVC.h"
#import "BWPhotoBrowserView.h"
#import "BWPhotoBrowserCell.h"
#import <SVProgressHUD.h>

@interface BWPhotoBrowserVC ()
@property (nonatomic,strong)NSMutableArray * imageList;
@property (nonatomic,strong)UIButton * leftBtn;
@property (nonatomic,strong)UIButton * rightBtn;
@property (nonatomic,strong)BWPhotoBrowserView * collectionView;
@property (nonatomic,strong) UIPageControl * pageControl;
@property (nonatomic,strong)NSIndexPath * indexPath;
@end

@implementation BWPhotoBrowserVC
-(instancetype)init
{
    if ([super init]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setImageListWithNotify:) name:@"imageList" object:nil];
        return self;
    }
    return nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView scrollToItemAtIndexPath:self.indexPath atScrollPosition:nil animated:NO];
}
-(void)setImageListWithNotify:(NSNotification *)notify
{
    NSMutableDictionary * dict = notify.object;
    
    self.imageList = dict[@"imageList"];
    self.indexPath = dict[@"indexPath"];
    
    NSLog(@"%@-%ld",self.indexPath,self.imageList.count);
    
}
-(void)rightBtnClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"dismiss");
    }];
}

-(void)saveImage
{
    NSIndexPath * indexPath = [self.collectionView.indexPathsForVisibleItems lastObject];
    
    BWPhotoBrowserCell * cell = [self.collectionView cellForItemAtIndexPath:indexPath];
    
    UIImage * image = cell.imageView.image;
    
    if (image == nil) {
        [SVProgressHUD showInfoWithStatus:@"没有图像"];
        return;
    }
    
    UIImageWriteToSavedPhotosAlbum(image, self  , @selector(image:didFinishSavingWithError:contextInfo:), nil);
}
//图片保存成功后的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString * message = [NSString string];
    if (error == nil) {
        message = @"保存成功";
    }else{
        message = @"保存失败";
    }
    [SVProgressHUD showInfoWithStatus:message];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//pageControl点击事件
-(void)pageControlChange
{
    NSIndexPath * indexPath = [NSIndexPath indexPathForItem:self.pageControl.currentPage inSection:0];
   
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:(UICollectionViewScrollPositionNone) animated:YES];
}

-(void)setUpUI
{
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.leftBtn];
    [self.view addSubview:self.rightBtn];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = self.imageList.count;
    self.pageControl.currentPage = self.indexPath.item;
    self.collectionView.pageControl = self.pageControl;
    
    [self.pageControl addTarget:self action:@selector(pageControlChange) forControlEvents:(UIControlEventValueChanged)];
    [self.rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:(UIControlEventTouchUpInside)];
    [self.leftBtn addTarget:self action:@selector(saveImage) forControlEvents:(UIControlEventTouchUpInside)];
    
    CGFloat margin = 10;
    
    self.leftBtn.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBtn attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeLeft) multiplier:1 constant:margin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBtn attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeBottom) multiplier:1 constant:-margin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBtn attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:70]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.leftBtn attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30]];

    self.rightBtn.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBtn attribute:(NSLayoutAttributeRight) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeRight) multiplier:1 constant:-margin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBtn attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeBottom) multiplier:1 constant:-margin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBtn attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:70]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBtn attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30]];
    
    self.pageControl.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeCenterX) multiplier:1 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeBottom) multiplier:1 constant:-margin]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.rightBtn attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1 constant:30]];
    
}
#pragma mark 懒加载
-(UIButton *)rightBtn
{
    if (_rightBtn == nil) {
        _rightBtn = [[UIButton alloc]init];
        [_rightBtn setBackgroundColor:[UIColor darkGrayColor]];
        [_rightBtn setTitle:@"返回" forState:(UIControlStateNormal)];
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    }
    return _rightBtn;
}
-(UIButton *)leftBtn
{
    if (_leftBtn == nil) {
        _leftBtn = [[UIButton alloc]init];
        [_leftBtn setBackgroundColor:[UIColor darkGrayColor]];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_leftBtn setTitle:@"保存" forState:(UIControlStateNormal)];
    }
    return _leftBtn;
}
-(UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[BWPhotoBrowserView alloc]initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc]init] imageList:self.imageList];
    }
    return _collectionView;
}
-(NSMutableArray *)imageList
{
    if (_imageList == nil) {
        _imageList = [[NSMutableArray alloc]init];
    }
    return _imageList;
}
-(NSIndexPath *)indexPath
{
    if (_indexPath == nil) {
        _indexPath = [[NSIndexPath alloc]init];
    }
    return _indexPath;
}
-(UIPageControl *)pageControl
{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc]init];
    }
    return _pageControl;
}
@end
