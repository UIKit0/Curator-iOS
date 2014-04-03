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
#import <MRCircularProgressView/MRCircularProgressView.h>

@interface CHTLargeImageView ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MRCircularProgressView *indicator;
@end

@implementation CHTLargeImageView

#pragma mark - Properties

- (UIImageView *)imageView {
  if (!_imageView) {
    _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    _imageView.backgroundColor = [UIColor blackColor];
    _imageView.clipsToBounds = YES;
    _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  return _imageView;
}

- (MRCircularProgressView *)indicator {
  if (!_indicator) {
    _indicator = [[MRCircularProgressView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _indicator.center = CGPointMake(CGRectGetMidX(self.imageView.bounds), CGRectGetMidY(self.imageView.bounds));
    _indicator.progressArcWidth = 4;
    _indicator.progressColor = [UIColor whiteColor];
    _indicator.backgroundColor = [UIColor clearColor];
    _indicator.alpha = 0.6;
  }
  return _indicator;
}

#pragma mark - NIPagingScrollViewPage

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
    [self addSubview:self.imageView];
    [self.imageView addSubview:self.indicator];
  }
  return self;
}

- (void)prepareForReuse {
  [self.imageView cancelCurrentImageLoad];
  self.imageView.image = nil;
  [self.indicator setProgress:0 animated:NO];
  [self.indicator setHidden:YES];
}

#pragma mark - Public Methods

- (void)configureWithBeauty:(CHTBeauty *)beauty {
  [self.indicator setHidden:NO];
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [self setNeedsLayout];

  __weak typeof(self) weakSelf = self;

  UIImage *placeholder = nil;
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  if (manager.cacheKeyFilter) {
    NSString *key = manager.cacheKeyFilter(beauty.thumbnailURL);
    placeholder = [manager.imageCache imageFromDiskCacheForKey:key];
  }

  [self.imageView setImageWithURL:beauty.imageURL placeholderImage:placeholder options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    CGFloat progress = (CGFloat)receivedSize/(CGFloat)expectedSize;
    [strongSelf.indicator setProgress:progress animated:YES];
  } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }

    CGSize imageSize = image.size;
    CGSize imageViewSize = strongSelf.imageView.bounds.size;
    if (imageSize.width <= imageViewSize.width &&
        imageSize.height <= imageViewSize.height) {
      strongSelf.imageView.contentMode = UIViewContentModeCenter;
    }

    [strongSelf.indicator setProgress:0 animated:NO];
    [strongSelf.indicator setHidden:YES];
    [strongSelf setNeedsLayout];
  }];
}

@end
