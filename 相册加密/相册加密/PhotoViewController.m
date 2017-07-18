//
//  PhotoViewController.m
//  相册加密
//
//  Created by siluo on 2017/7/17.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "PhotoViewController.h"
#import "PhotoCollectionViewCell.h"
#import "FMDB.h"
#import "PhotoListViewController.h"

static NSString *PhotoCell = @"PhotoCell";

@interface PhotoViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *photoArray;
@property (nonatomic,strong) FMDatabase *database;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.photoArray = [NSMutableArray array];
    
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 100, [UIScreen mainScreen].bounds.size.height - 80, 60, 30)];
    [addButton setTitle:@"添加相册" forState:UIControlStateNormal];
    addButton.titleLabel.font = [UIFont systemFontOfSize:12];
    addButton.backgroundColor = [UIColor redColor];
    [addButton addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addButton];
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"photo.sqlite"];
    //2.获得数据库
    FMDatabase *db = [FMDatabase databaseWithPath:fileName];
    self.database = db;
    
    if ([self.database open])
    {
        //4.创表
        BOOL result = [self.database executeUpdate:@"CREATE TABLE IF NOT EXISTS photo (id integer PRIMARY KEY AUTOINCREMENT, name text NOT NULL, title text NOT NULL);"];
        if (result)
        {
            NSLog(@"创建表成功");
        }
    }
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //  layout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 -3, 255);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 1; //上下的间距 可以设置0看下效果
    layout.sectionInset = UIEdgeInsetsMake(0.f, 0, 0.f, 0);
    layout.sectionHeadersPinToVisibleBounds = YES;
    
    self.collectionView.collectionViewLayout = layout;

    UINib *nib = [UINib nibWithNibName:@"PhotoCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:PhotoCell];
    
    NSString *str = [NSString stringWithFormat:@"select *from photo"];
    FMResultSet *set = [self.database executeQuery:str];
    
    while ([set next]) {
        
        NSString *name = [set stringForColumn:@"name"];
        NSString *title = [set stringForColumn:@"title"];
        
        NSString *titleList = [NSString stringWithFormat:@"%@%@",name,title];
        
        [self.photoArray addObject:titleList];
    }

    
    // Do any additional setup after loading the view from its nib.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
 //   NSUInteger count = [self.database intForQuery:@"select count(*) from photo"];
    
        return self.photoArray.count ;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCell forIndexPath:indexPath];
    if (!cell) {
        cell = [[PhotoCollectionViewCell alloc] init];
    }
    cell.titleLabel.text = self.photoArray[indexPath.row];
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.width / 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"相册密码" message:@"默认密码为1" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"密码";
        textField.secureTextEntry = YES;
    }];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UITextField *login = alertController.textFields.firstObject;
       
        if ([login.text isEqualToString:@"1"]) {
            
            PhotoListViewController *vc = [[PhotoListViewController alloc] init];
            vc.indexString = [NSString stringWithFormat:@"table%ld",(long)indexPath.row];
            NSLog(@"---%@",vc.indexString);
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
        
            UIAlertController *popView = [UIAlertController alertControllerWithTitle:@"密码错误！" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [popView addAction:leftAction];
            [self presentViewController:popView animated:YES completion:nil];
            
        }
        
    }];
    
    [alertController addAction:leftAction];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addPhoto{

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"创建新的相册" message:@"默认密码1" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *leftAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction *rightAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //1.executeUpdate:不确定的参数用？来占位（后面参数必须是oc对象，；代表语句结束）
        
        NSString *countStr = [NSString stringWithFormat:@"%lu",self.photoArray.count];
        
        NSLog(@"%d",[self.database executeUpdate:@"INSERT INTO photo (name, title) VALUES (?,?);",@"默认相册",countStr]);
        
        NSString *str = [NSString stringWithFormat:@"默认相册%lu",(unsigned long)self.photoArray.count];
        
        [self.photoArray addObject:str];
        
        [self.collectionView reloadData];
        
    }];
    
    [alertController addAction:leftAction];
    [alertController addAction:rightAction];
    
    [self presentViewController:alertController animated:YES completion:nil];

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
