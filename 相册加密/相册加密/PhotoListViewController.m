//
//  PhotoListViewController.m
//  相册加密
//
//  Created by siluo on 2017/7/18.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "PhotoListViewController.h"
#import "photoListCollectionViewCell.h"
#import "FMDB.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
static NSString *photoListCell = @"photoListCell";

@interface PhotoListViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) FMDatabase *database;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,copy) NSString *localizedTitle;
@end

@implementation PhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //  layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 -3, 255);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView.collectionViewLayout = layout;

    UINib *nib = [UINib nibWithNibName:@"photoListCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:photoListCell];

    UIButton *addPhotoButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 80, 60, 30)];
    [addPhotoButton setTitle:@"添加照片" forState:UIControlStateNormal];
    addPhotoButton.titleLabel.font = [UIFont systemFontOfSize:12];
    addPhotoButton.backgroundColor = [UIColor blueColor];
    [addPhotoButton addTarget:self action:@selector(addPhoto1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addPhotoButton];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"photo.sqlite"];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    self.database = db;
    
    if ([self.database open])
    {
        NSString *tableName = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, image blob NOT NULL);",self.indexString];
        
        //4.创表
        BOOL result = [self.database executeUpdate:tableName];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }

    self.photoArray = [NSMutableArray array];
    NSString *str = [NSString stringWithFormat:@"select *from %@",self.indexString];
    FMResultSet *set = [self.database executeQuery:str];
    
    while ([set next]) {
        
        NSData *data = [set dataForColumn:@"image"];
        UIImage *image = [UIImage imageWithData:data];
        
        [self.photoArray addObject:image];
    }

    
                      
    // Do any additional setup after loading the view from its nib.
}

- (void)addPhoto1{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //定义图片选择器
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        
        //设置选取的照片是否可编辑
      //  picker.allowsEditing = YES;
        //判断系统是否允许选择 相册
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            //图片选择是相册（图片来源自相册）
            
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            //设置代理
            
            picker.delegate = self;
            
            //模态显示界面
            
            [self presentViewController:picker animated:YES completion:nil];
            
        }
        
    }];
    
    [alert addAction:photoAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//实现图片选择器代理

//参数：图片选择器  字典参数
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSLog(@"---%@",picker.navigationItem.title);
    
    //通过key值获取到图片
    
    UIImage * image =info[UIImagePickerControllerOriginalImage];
    
    NSData *data = UIImagePNGRepresentation(image);
    
    NSLog(@"image=%@  info=%@",image, info);
    
    //判断数据源类型
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        
        NSLog(@"self.indexString:%@",self.indexString);
        
        NSString *tableName = [NSString stringWithFormat:@"INSERT INTO %@ (name,image) VALUES (?,?);",self.indexString];
        
        NSLog(@"tableName:%@",tableName);
        
        [self.database executeUpdate:tableName,@"默认",data];
        
        [self.photoArray addObject:image];
        
        [self.collectionView reloadData];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",info[UIImagePickerControllerReferenceURL]];
        NSRange range1 = [imageUrl rangeOfString:@"id="];
        
        NSString *imageId = [imageUrl substringFromIndex:range1.location + 3];
        
        NSRange range2 = [imageId rangeOfString:@"&ext"];
        NSString *imageID = [imageId substringToIndex:range2.location];
        
        PHFetchResult *collectonResuts = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAny options:[PHFetchOptions new]] ;
        [collectonResuts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PHAssetCollection *assetCollection = obj;
           
            if ([assetCollection.localizedTitle isEqualToString:self.localizedTitle])  {
                PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:[PHFetchOptions new]];
                [assetResult enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    
                    NSString *objString = [NSString stringWithFormat:@"%@",obj];

                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                        //获取相册的最后一张照
                        if ([objString rangeOfString:imageID].location != NSNotFound) {
                         
                            [PHAssetChangeRequest deleteAssets:@[obj]];
                        }
                    
                    } completionHandler:^(BOOL success, NSError *error) {
                      //  NSLog(@"Error: %@", error);
                    }];
                }];
            }
        }];
    
    }
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{

    self.localizedTitle = viewController.title;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.photoArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    photoListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:photoListCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[photoListCollectionViewCell alloc] init];
    }
    
    cell.imageView.image = self.photoArray[indexPath.row];
    
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    photoListCollectionViewCell *cell = (photoListCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0; i<self.photoArray.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = self.photoArray[i]; // 图片路径
        photo.srcImageView = cell.imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
