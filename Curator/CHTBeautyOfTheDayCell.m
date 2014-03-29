//
//  CHTBeautyOfTheDayCell.m
//  Curator
//
//  Created by Nelson on 2014/3/27.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTBeautyOfTheDayCell.h"
#import "CHTBeauty.h"
#import "NSString+Date.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CHTBeautyOfTheDayCell ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, strong) IBOutlet UILabel *dayLabel;
@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@end

@implementation CHTBeautyOfTheDayCell

#pragma mark - Properties

- (CAGradientLayer *)gradientLayer {
  if (!_gradientLayer) {
    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.colors = @[(id)[UIColor colorWithWhite:1.000 alpha:0].CGColor,
                              (id)[UIColor colorWithWhite:0.2 alpha:0.300].CGColor];
    _gradientLayer.locations = @[@(0.0), @(0.85)];
    // Un-comment below for horizontal gradient
//    _gradientLayer.startPoint = CGPointMake(0, 0.5);
//    _gradientLayer.endPoint = CGPointMake(1, 0.5);
  }
  return _gradientLayer;
}

#pragma mark - UICollectionViewCell

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self.contentView.layer insertSublayer:self.gradientLayer atIndex:1];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self.contentView.layer insertSublayer:self.gradientLayer atIndex:1];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];

  [self.imageView cancelCurrentImageLoad];
}

- (void)layoutSubviews {
  [super layoutSubviews];
  self.gradientLayer.frame = self.contentView.bounds;
}

#pragma mark - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty {
  self.dayLabel.text = [beauty.whichDay substringFromIndex:8];
  self.nameLabel.text = beauty.name;
  self.dateLabel.text = [NSString dateStringFromString:beauty.whichDay];

  __weak typeof(self) weakSelf = self;
  self.indicator.hidden = NO;
  [self.imageView setImageWithURL:beauty.imageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    strongSelf.indicator.hidden = YES;
  }];
}

@end
