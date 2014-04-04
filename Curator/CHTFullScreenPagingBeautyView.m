//
//  CHTFullScreenPagingBeautyView.m
//  Curator
//
//  Created by Nelson on 2014/3/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTFullScreenPagingBeautyView.h"
#import "CHTLargeImageView.h"
#import "CHTBeauty.h"
#import <Nimbus/NIPagingScrollView.h>

@interface CHTFullScreenPagingBeautyView () <
  NIPagingScrollViewDelegate,
  NIPagingScrollViewDataSource
>
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) NIPagingScrollView *pagingScrollView;
@end

@implementation CHTFullScreenPagingBeautyView

#pragma mark - Properties

- (NIPagingScrollView *)pagingScrollView {
  if (!_pagingScrollView) {
    _pagingScrollView = [[NIPagingScrollView alloc] initWithFrame:self.bounds];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  }
  return _pagingScrollView;
}

- (UILabel *)infoLabel {
  if (!_infoLabel) {
    CGFloat height = 24;
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height)];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [UIFont systemFontOfSize:16];
    _infoLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.500];
    _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  }
  return _infoLabel;
}

#pragma mark - UIView

- (void)dealloc {
  _pagingScrollView.delegate = nil;
  _pagingScrollView.dataSource = nil;
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init {
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
    [self commonInit];
  }
  return self;
}

#pragma mark - Init

- (void)commonInit {
  self.backgroundColor = [UIColor blackColor];
  self.alpha = 0;

  self.pagingScrollView.delegate = self;
  self.pagingScrollView.dataSource = self;
  [self addSubview:self.pagingScrollView];
  [self addSubview:self.infoLabel];

  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  [self addGestureRecognizer:tap];

  UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
  swipe.direction = UISwipeGestureRecognizerDirectionDown;
  [self addGestureRecognizer:swipe];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(deviceOrientationDidChange:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
  return [self.beauties count];
}

- (UIView <NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  static NSString *identifier = @"LargeImage";
  CHTLargeImageView *imageView = (CHTLargeImageView *)[pagingScrollView dequeueReusablePageWithIdentifier:identifier];

  if (!imageView) {
    imageView = [[CHTLargeImageView alloc] initWithReuseIdentifier:identifier];
  }

  [imageView configureWithBeauty:self.beauties[pageIndex]];

  return imageView;
}

#pragma mark - NIPagingScrollViewDelegate

- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView {
  [self configureInfoDisplay];
}

#pragma mark - Public Methods

- (void)present {
  [self deviceOrientationDidChange:nil];

  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  [window addSubview:self];

  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    self.alpha = 1;
  } completion:^(BOOL finished) {
    [self.pagingScrollView reloadData];
    self.pagingScrollView.centerPageIndex = self.selectedIndex;
    [self configureInfoDisplay];
  }];
}

- (void)dismiss {
  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.alpha = 0;
  } completion:^(BOOL finished) {
    [self removeFromSuperview];
  }];
}

#pragma mark - Private Methods

- (void)configureInfoDisplay {
  CHTBeauty *beauty = self.beauties[self.pagingScrollView.centerPageIndex];

  if (self.mode == CHTFullScreenPagingBeautyViewDisplayModeNmae) {
    self.infoLabel.text = beauty.name;
  } else {
    self.infoLabel.text = [NSString stringWithFormat:@"%@/%@", @(self.pagingScrollView.centerPageIndex + 1), @([self.beauties count])];
  }
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  CGFloat angle = [self rotationAngleForOrientation:orientation];
  self.transform = CGAffineTransformMakeRotation(angle);
  self.frame = [UIScreen mainScreen].bounds;

  if (self.superview && notification) {
    [self.pagingScrollView reloadData];
  }
}

- (CGFloat)rotationAngleForOrientation:(UIDeviceOrientation)orientation {
  CGFloat angle;

  switch (orientation) {
    case UIDeviceOrientationPortrait:
      angle = 0;
      break;

    case UIDeviceOrientationPortraitUpsideDown:
      angle = M_PI;
      break;

    case UIDeviceOrientationLandscapeLeft:
      angle = M_PI_2;
      break;

    case UIDeviceOrientationLandscapeRight:
      angle = -M_PI_2;
      break;

    default:
      angle = 0;
      break;
  }
  
  return angle;
}

@end
