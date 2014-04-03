//
//  CHTNavigatonBarTitleView.m
//  Curator
//
//  Created by Nelson on 2014/3/26.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTNavigatonBarTitleView.h"

@interface CHTNavigatonBarTitleView ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@end

@implementation CHTNavigatonBarTitleView

#pragma mark - Properties

- (UILabel *)titleLabel {
  if (!_titleLabel) {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)/2)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:16];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _titleLabel;
}

- (UILabel *)subtitleLabel {
  if (!_subtitleLabel) {
    CGFloat height = CGRectGetHeight(self.bounds)/2;
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, height, CGRectGetWidth(self.bounds), height)];
    _subtitleLabel.font = [UIFont systemFontOfSize:13];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.textAlignment = NSTextAlignmentCenter;
  }
  return _subtitleLabel;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self addSubview:self.titleLabel];
    [self addSubview:self.subtitleLabel];
  }
  return self;
}

#pragma mark - Public Methods

- (void)setTitle:(NSString *)title subtitle:(NSString *)subtitle {
  self.titleLabel.text = title;
  self.subtitleLabel.text = subtitle;
}

@end
