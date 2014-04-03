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
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation CHTBeautyCell

#pragma mark - UICollectionViewCell

- (void)prepareForReuse {
  [super prepareForReuse];

  [self.imageView cancelCurrentImageLoad];
}

#pragma mark - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty showName:(BOOL)showName {
  if (showName) {
    self.nameLabel.hidden = NO;
    self.nameLabel.text = beauty.name;
  } else {
    self.nameLabel.hidden = YES;
  }

  __weak typeof(self) weakSelf = self;
  self.indicator.hidden = NO;
  [self.imageView setImageWithURL:beauty.thumbnailURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    strongSelf.indicator.hidden = YES;
  }];
}

@end
