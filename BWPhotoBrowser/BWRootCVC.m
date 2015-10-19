//
//  BWRootCVC.m
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//

#import "BWRootCVC.h"
#import <SDWebImageManager.h>
#import <UIImageView+WebCache.h>
#import "BWPhotoBrowserVC.h"
#import "BWPhotoBrowserAnimator.h"
#import "BWPhotoBrowserCell.h"

@interface BWRootCVC ()
@property (nonatomic,strong) BWPhotoBrowserAnimator * photoBrowserAnimator;
@property (nonatomic,strong) NSMutableArray * iconList;
@property (nonatomic,strong) NSMutableArray * imageList;
@end

@implementation BWRootCVC


static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat margin = 10;
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - margin * 2)/3;
    CGFloat height = width;
    flowLayout.itemSize = CGSizeMake(width, height);
    flowLayout.minimumInteritemSpacing = margin;
    flowLayout.minimumLineSpacing = margin;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.iconList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    UIImageView * iconImage = [[UIImageView alloc]init];
    iconImage.frame = cell.bounds;
    [iconImage sd_setImageWithURL:self.iconList[indexPath.item]];
    [cell addSubview:iconImage];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect fullRect = [self fullScreenRect:indexPath];
    BWPhotoBrowserCell * cell =(BWPhotoBrowserCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //转换坐标
    CGRect rect = [collectionView convertRect:cell.frame toCoordinateSpace:[[UIApplication sharedApplication] keyWindow]];
 
    
    BWPhotoBrowserVC * photoBrowserVC = [[BWPhotoBrowserVC alloc]init];
    //发送通知传递数据
    NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
    [params setObject:self.imageList forKey:@"imageList"];
    [params setObject:indexPath forKey:@"indexPath"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageList" object:params];
    //制定动画的提供者
    photoBrowserVC.transitioningDelegate = self.photoBrowserAnimator;
    [self.photoBrowserAnimator prepareForBrowser:self.iconList[indexPath.item] :rect :fullRect :self];
   // [self.photoBrowserAnimator prepareForBrowser:self.iconList[indexPath.item] :rect :fullRect];
   
    photoBrowserVC.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:photoBrowserVC animated:YES completion:nil];
}
- (CGRect)fullScreenRect:(NSIndexPath *)indexPath
{
    //根据图片来计算目标尺寸
    UIImage * image = [[[SDWebImageManager sharedManager]imageCache]imageFromDiskCacheForKey: self.iconList[indexPath.item]];
    CGFloat scale = image.size.height/image.size.width;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = w * scale;
    
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - h)*0.5;
    if (y < 0) {
        y = 0;
    }
    return CGRectMake(0, y, w, h);
}
#pragma mark 懒加载
-(NSMutableArray *)imageList
{
    if (_imageList == nil) {
        _imageList = [[NSMutableArray alloc]init];
        [_imageList addObject:@"http://ww2.sinaimg.cn/bmiddle/bd8a913agw1ex2m2lgs0bj20jr0jrtaq.jpg"];
        [_imageList addObject:@"http://ww1.sinaimg.cn/bmiddle/bd8a913agw1ex2m2lv3i5j20ki0ki0u3.jpg"];
        [_imageList addObject:@"http://ww2.sinaimg.cn/bmiddle/bd8a913agw1ex2m2n3pt4j20k30k3wgx.jpg"];
        [_imageList addObject:@"http://ww3.sinaimg.cn/bmiddle/bd8a913agw1ex2m2noknjj20ki0kitai.jpg"];
        [_imageList addObject:@"http://ww4.sinaimg.cn/bmiddle/bd8a913agw1ex2m2oha3rj20ki0kijst.jpg"];
        [_imageList addObject:@"http://ww2.sinaimg.cn/bmiddle/bd8a913agw1ex2m2pawodj20qo0qoac3.jpg"];
        [_imageList addObject:@"http://ww2.sinaimg.cn/bmiddle/bd8a913agw1ex2m2pw2vgj20kf0kf75p.jpg"];
        [_imageList addObject:@"http://ww1.sinaimg.cn/bmiddle/bd8a913agw1ex2m2qqg65j20ku0kumyg.jpg"];
        [_imageList addObject:@"http://ww1.sinaimg.cn/bmiddle/bd8a913agw1ex2m2rfjgnj20kl0kl403.jpg"];
    }
    return _imageList;
}
-(NSMutableArray *)iconList
{
    if (_iconList == nil) {
        _iconList = [[NSMutableArray alloc]init];
        [_iconList addObject:@"http://ww2.sinaimg.cn/square/bd8a913agw1ex2m2lgs0bj20jr0jrtaq.jpg"];
        [_iconList addObject:@"http://ww1.sinaimg.cn/square/bd8a913agw1ex2m2lv3i5j20ki0ki0u3.jpg"];
        [_iconList addObject:@"http://ww2.sinaimg.cn/square/bd8a913agw1ex2m2n3pt4j20k30k3wgx.jpg"];
        [_iconList addObject:@"http://ww3.sinaimg.cn/square/bd8a913agw1ex2m2noknjj20ki0kitai.jpg"];
        [_iconList addObject:@"http://ww4.sinaimg.cn/square/bd8a913agw1ex2m2oha3rj20ki0kijst.jpg"];
        [_iconList addObject:@"http://ww2.sinaimg.cn/square/bd8a913agw1ex2m2pawodj20qo0qoac3.jpg"];
        [_iconList addObject:@"http://ww2.sinaimg.cn/square/bd8a913agw1ex2m2pw2vgj20kf0kf75p.jpg"];
        [_iconList addObject:@"http://ww1.sinaimg.cn/square/bd8a913agw1ex2m2qqg65j20ku0kumyg.jpg"];
        [_iconList addObject:@"http://ww1.sinaimg.cn/square/bd8a913agw1ex2m2rfjgnj20kl0kl403.jpg"];
    }
    return _iconList;
}

-(BWPhotoBrowserAnimator *)photoBrowserAnimator
{
    if (_photoBrowserAnimator == nil) {
        _photoBrowserAnimator = [[BWPhotoBrowserAnimator alloc]init];
    }
    return _photoBrowserAnimator;
}

@end
