//
//  BWPhotoBrowserView.m
//  BWPhotoBrowser
//
//  Created by 静静静 on 15/10/16.
//  Copyright © 2015年 BossKai. All rights reserved.
//

#import "BWPhotoBrowserView.h"
#import "BWPhotoBrowserCell.h"

@interface BWPhotoBrowserView()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic,strong)NSMutableArray * imageList;
@end
#define BWPhotoBrowserCellID  @"BWPhotoBrowserCellID"
@implementation BWPhotoBrowserView
-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout imageList:(NSMutableArray *)imageList
{
    
    if ([super initWithFrame:frame collectionViewLayout:layout]) {
        self.imageList = imageList;
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout *)layout;
        flowLayout.itemSize = self.bounds.size;
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        self.pagingEnabled = YES;
        self.bounces = false;
        
        [self registerClass:[BWPhotoBrowserCell self] forCellWithReuseIdentifier:BWPhotoBrowserCellID];
        
        self.dataSource = self;
        self.delegate = self;
        return self;
        
    }
    return nil;
}

#pragma mark: UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BWPhotoBrowserCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:BWPhotoBrowserCellID forIndexPath:indexPath];
    cell.imageUrl = self.imageList[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.pageControl.currentPage = [[[collectionView indexPathsForVisibleItems] lastObject] item];
}

#pragma mark: 懒加载
-(NSMutableArray *)imageList
{
    if (_imageList == nil) {
        _imageList = [[NSMutableArray alloc]init];
    }
    return _imageList;
}


@end
