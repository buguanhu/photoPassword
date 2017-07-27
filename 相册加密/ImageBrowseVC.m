//
//  ImageBrowseVC.m
//  相册加密
//
//  Created by siluo on 2017/7/26.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "ImageBrowseVC.h"
#import "ImageBrowseCell.h"
#import <Photos/Photos.h>

static NSString *imageBrowseCell = @"imageBrowseCell";

@interface ImageBrowseVC () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) NSInteger oldIndex;
@end

@implementation ImageBrowseVC

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewWillDisappear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:NO];
    
}

- (void)viewWillAppear:(BOOL)animated{

    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 0.f, 0.f, 0);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = YES;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.bounces = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    UINib *photosNib = [UINib nibWithNibName:@"ImageBrowseCell" bundle:nil];
    [self.collectionView registerNib:photosNib forCellWithReuseIdentifier:imageBrowseCell];
    
    self.collectionView.contentOffset = CGPointMake(scrW * _imageIndex, scrH);
    
    [self addQimage];

    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageBrowseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageBrowseCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[ImageBrowseCell alloc] init];
    }
  //  cell.imageView.image = self.imageArray[indexPath.row][@"image"];
    
    cell.image = self.imageArray[indexPath.row][@"image"];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(scrW, scrH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    self.imageIndex = scrollView.contentOffset.x / scrW;
    
    NSLog(@"_imageIndex1:%ld",(long)_imageIndex);
    
    [self addQimage];
}

- (void)addQimage{

    PHAsset *asset = (PHAsset *)self.imageArray[_imageIndex][@"asset"];
    
    PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeNone;
    requestOptions.networkAccessAllowed = YES;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.synchronous = NO;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        //判断是不是高清图片
        BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        
        if (downloadFinined && result) {
            
            NSDictionary *dict = @{@"image":result,
                                   @"code":@"1",
                                   @"asset":asset
                                   };
            
            [self.imageArray replaceObjectAtIndex:_imageIndex withObject:dict];
            
                NSIndexPath *index = [NSIndexPath indexPathForRow:_imageIndex inSection:0];
                
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:index, nil]];
            
        }
        
    }];

}


@end
