//
//  PhotosViewController.m
//  相册加密
//
//  Created by siluo on 2017/7/24.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "PhotosViewController.h"
#import <Photos/Photos.h>
#import "PhotosCollectionViewCell.h"
#import "ImageBrowseVC.h"

static NSString *photosCell = @"photosCell";
@interface PhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *imageArray;
@property (nonatomic,strong) NSMutableArray *clickArray;
@property (nonatomic,copy) NSString *codeString;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageArray = [NSMutableArray array];
    self.clickArray = [NSMutableArray array];
    
    self.codeString = @"1";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0, 0.f, 0.f, 0);
    layout.sectionHeadersPinToVisibleBounds = YES;
    self.collectionView.collectionViewLayout = layout;
    
    UINib *photosNib = [UINib nibWithNibName:@"PhotosCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:photosNib forCellWithReuseIdentifier:photosCell];
    
    // 获取所有资源的集合，并按资源的创建时间排序
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
    [assetsFetchResults enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
        PHAsset *asset = [[PHAsset alloc] init];
        asset = (PHAsset *)obj;
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode = PHImageRequestOptionsResizeModeNone;
        requestOptions.networkAccessAllowed = YES;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(250, 250) contentMode:PHImageContentModeAspectFill options:requestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            NSLog(@"info:%@",asset);
            
                //判断是不是高清图片
                BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            
            
            
                if (downloadFinined && result) {
                    
                    NSDictionary *dict = @{@"image":result,
                                           @"code":@"1",
                                           @"asset":asset};
                    
                    [self.imageArray addObject:dict];
                    
                }
            
                    [self.collectionView reloadData];
        
        }];
        
    }];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    self.navigationItem.rightBarButtonItem = rightBar;
    
}

- (void)done{

    if (self.clickImageBlock) {
        self.clickImageBlock(self.clickArray);
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
    NSLog(@"---%@",self.clickArray);
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    return 1;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
   return self.imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PhotosCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photosCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhotosCollectionViewCell alloc] init];
    }
      cell.imageView.image = self.imageArray[indexPath.row][@"image"];
    
    self.codeString = [NSString stringWithFormat:@"%@",self.imageArray[indexPath.row][@"code"]];
    
    if ([self.codeString isEqualToString:@"1"]) {
        cell.clickBtn.backgroundColor = [UIColor yellowColor];
    }else{
        cell.clickBtn.backgroundColor = [UIColor redColor];
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(scrW / 4 , scrW /  4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImageBrowseVC *vc = [[ImageBrowseVC alloc] init];
    vc.imageArray = self.imageArray;
    vc.imageIndex = indexPath.row;
    [self.navigationController pushViewController:vc animated:YES];
    
//    self.codeString = [NSString stringWithFormat:@"%@",self.imageArray[indexPath.row][@"code"]];
//    
//    if([self.codeString isEqualToString:@"1"]){
//        
//        [self.clickArray addObject:self.imageArray[indexPath.row][@"image"]];
//        
//        NSDictionary *dict = @{@"image":self.imageArray[indexPath.row][@"image"],
//                               @"code":@"0"};
//        
//        [self.imageArray replaceObjectAtIndex:indexPath.row withObject:dict];
//       
//         }else{
//
//             [self.clickArray removeObject:self.imageArray[indexPath.row][@"image"]];
//             NSDictionary *dict = @{@"image":self.imageArray[indexPath.row][@"image"],
//                               @"code":@"1"};
//    
//        [self.imageArray replaceObjectAtIndex:indexPath.row withObject:dict];
//        
//             
//             
//    }
//    
//    NSIndexPath *index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//    
//    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:index, nil]];
}

@end
