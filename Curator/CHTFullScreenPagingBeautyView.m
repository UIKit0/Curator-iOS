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
    CGFloat height = 36;
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - height, CGRectGetWidth(self.bounds), height)];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    _infoLabel.font = [UIFont systemFontOfSize:18];
    _infoLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  }
  return _infoLabel;
}

#pragma mark - UIView

- (void)dealloc {
  _pagingScrollView.delegate = nil;
  _pagingScrollView.dataSource = nil;
}

- (id)init {
  CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  CGRect newFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
  if (self = [super initWithFrame:newFrame]) {
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
  [self.pagingScrollView reloadData];
  self.pagingScrollView.centerPageIndex = self.selectedIndex;
  [self configureInfoDisplay];

  UIWindow *window = [UIApplication sharedApplication].keyWindow;
  CGRect frame = self.frame;
  frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds);
  self.frame = frame;
  [window addSubview:self];

  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    CGRect frame = self.frame;
    frame.origin.y = 0;
    self.frame = frame;
    self.alpha = 1;
  } completion:nil];
}

- (void)dismiss {
  [UIView animateWithDuration:0.3 animations:^{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    CGRect frame = self.frame;
    frame.origin.y = CGRectGetHeight([UIScreen mainScreen].bounds);
    self.frame = frame;
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
    self.infoLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)(self.pagingScrollView.centerPageIndex + 1), (unsigned long)[self.beauties count]];
  }
}

@end
