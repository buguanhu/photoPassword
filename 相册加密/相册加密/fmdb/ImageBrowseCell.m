//
//  ImageBrowseCell.m
//  相册加密
//
//  Created by siluo on 2017/7/26.
//  Copyright © 2017年 TH. All rights reserved.
//

#import "ImageBrowseCell.h"

@implementation ImageBrowseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImage:(UIImage *)image{

    _image = image;
        
        self.imageView.image = image;
    
//    self.imageView.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
//    tap.numberOfTapsRequired = 2;
//    [tap addTarget:self action:@selector(trans)];
  //  [self.imageView addGestureRecognizer:tap];
}

- (void)trans{
    
    

}

@end
