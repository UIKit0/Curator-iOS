//
//  CHTLoadMoreFooterView.m
//  Curator
//
//  Created by Nelson on 2014/2/15.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTLoadMoreView.h"

@interface CHTLoadMoreView ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation CHTLoadMoreView

#pragma mark - Properties

- (UIActivityIndicatorView *)activityIndicatorView {
  if (!_activityIndicatorView) {
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicatorView.hidesWhenStopped = YES;
    [_activityIndicatorView startAnimating];
  }
  return _activityIndicatorView;
}

- (UILabel *)textLabel {
  if (!_textLabel) {
    _textLabel = [[UILabel alloc] init];
    _textLabel.hidden = YES;
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = [UIColor colorWithRed:115.0 / 255.0 green:111.0 / 255.0 blue:108.0 / 255.0 alpha:0.3];
    _textLabel.font = [UIFont boldSystemFontOfSize:17];
    _textLabel.text = @"- 小海嚴選 -";
    [_textLabel sizeToFit];
  }
  return _textLabel;
}

- (void)setState:(CHTLoadMoreState)state {
  if (_state == state) {
    return;
  }
  _state = state;

  switch (state) {
    case CHTLoadMoreStateLoading:
      self.textLabel.hidden = YES;
      [self.activityIndicatorView startAnimating];
      break;

    case CHTLoadMoreStateEnded:
      self.textLabel.hidden = NO;
      [self.activityIndicatorView stopAnimating];
      break;
  }
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    self.backgroundColor = [UIColor clearColor];

    [self addSubview:self.activityIndicatorView];
    [self addSubview:self.textLabel];

    self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.textLabel.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.state = CHTLoadMoreStateLoading;
  }
  return self;
}

@end
