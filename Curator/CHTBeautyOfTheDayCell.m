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
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@end

@implementation CHTBeautyOfTheDayCell

#pragma mark - Properties

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  return _imageView;
}

- (UIActivityIndicatorView *)indicator {
  if (!_indicator) {
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _indicator.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
    [_indicator startAnimating];
  }
  return _indicator;
}

- (UILabel *)dayLabel {
  if (!_dayLabel) {
    _dayLabel = [[UILabel alloc] init];
    _dayLabel.font = [UIFont boldSystemFontOfSize:20];
    _dayLabel.textColor = [UIColor whiteColor];
    _dayLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _dayLabel;
}

- (UILabel *)nameLabel {
  if (!_nameLabel) {
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _nameLabel;
}

- (UILabel *)dateLabel {
  if (!_dateLabel) {
    _dateLabel = [[UILabel alloc] init];
    _dateLabel.font = [UIFont systemFontOfSize:13];
    _dateLabel.textColor = [UIColor whiteColor];
    _dateLabel.translatesAutoresizingMaskIntoConstraints = NO;
  }
  return _dateLabel;
}

#pragma mark - UICollectionViewCell

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self.contentView addSubview:self.imageView];
    [self.contentView addSubview:self.indicator];
    [self.contentView addSubview:self.dayLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self setupLayoutConstraints];
  }
  return self;
}

- (void)prepareForReuse {
  [super prepareForReuse];

  [self.imageView cancelCurrentImageLoad];
}

#pragma mark - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty {
  self.nameLabel.text = beauty.name;
  self.dateLabel.text = [NSString dateStringFromString:beauty.whichDay];

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

#pragma mark - Private Methods

- (void)setupLayoutConstraints {
  NSString *format;
  NSDictionary *views = @{
    @"day" : self.dayLabel,
    @"name" : self.nameLabel,
    @"date" : self.dateLabel
  };
  NSDictionary *metrics = @{
    @"margin" : @(5)
  };

  format = @"V:[day][name][date]-(margin)-|";
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:metrics views:views]];
  format = @"H:|-(margin)-[day]-(margin)-|";
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:metrics views:views]];
  format = @"H:|-(margin)-[name]-(margin)-|";
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:metrics views:views]];
  format = @"H:|-(margin)-[date]-(margin)-|";
  [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:kNilOptions metrics:metrics views:views]];
}

@end
