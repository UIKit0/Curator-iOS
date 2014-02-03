//
//  CHTBeautyCell.m
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTBeautyCell.h"
#import "CHTBeauty.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CHTBeautyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation CHTBeautyCell

#pragma - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty showName:(BOOL)showName {
  if (showName) {
    self.nameLabel.hidden = NO;
    self.nameLabel.text = beauty.name;
  } else {
    self.nameLabel.hidden = YES;
  }
  [self.imageView setImageWithURL:beauty.imageURL
                 placeholderImage:nil
                          options:0];
}

@end
