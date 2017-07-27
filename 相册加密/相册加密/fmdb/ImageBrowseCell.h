//
//  ImageBrowseCell.h
//  相册加密
//
//  Created by siluo on 2017/7/26.
//  Copyright © 2017年 TH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageBrowseCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeight;
@property (nonatomic,strong) UIImage  *image;
@end
