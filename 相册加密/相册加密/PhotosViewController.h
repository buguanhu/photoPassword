//
//  PhotosViewController.h
//  相册加密
//
//  Created by siluo on 2017/7/24.
//  Copyright © 2017年 TH. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^clickImageBlock)(NSMutableArray *array);
@interface PhotosViewController : UIViewController
@property (nonatomic,strong) clickImageBlock clickImageBlock;
@end
