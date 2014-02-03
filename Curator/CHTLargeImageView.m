//
//  CHTLargeImageView.m
//  Curator
//
//  Created by Nelson on 2014/2/1.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTLargeImageView.h"
#import "CHTBeauty.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CHTLargeImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CHTLargeImageView

#pragma mark - Properties

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  return _imageView;
}

#pragma mark - NIPageView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
    [self addSubview:self.imageView];
  }
  return self;
}

- (void)prepareForReuse {
  self.imageView.image = nil;
}

#pragma mark - UIView

- (void)layoutSubviews {
  [super layoutSubviews];

  if (!self.imageView.image) {
    return;
  }

  CGSize imageSize = self.imageView.image.size;
  CGSize imageViewSize = self.imageView.bounds.size;
  if (imageSize.width < imageViewSize.width &&
      imageSize.height < imageViewSize.height) {
    self.imageView.contentMode = UIViewContentModeCenter;
  } else {
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  }
}

#pragma mark - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty {
  __weak typeof(self) weakSelf = self;

  [self.imageView setImageWithURL:beauty.imageURL placeholderImage:nil options:0 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    strongSelf.imageView.image = image;
    [strongSelf setNeedsLayout];
  }];
}

@end
