//
//  PhotosCollectionViewCell.m
//  相册加密
//
//  Created by siluo on 2017/7/24.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "PhotosCollectionViewCell.h"

@implementation PhotosCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.clickBtn.layer.cornerRadius = 10;
    self.clickBtn.layer.masksToBounds = YES;
    
    // Initialization code
}

@end
