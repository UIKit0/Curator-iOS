//
//  CHTLoadMoreFooterView.h
//  Curator
//
//  Created by Nelson on 2014/2/15.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CHTLoadMoreState) {
  CHTLoadMoreStateLoading,
  CHTLoadMoreStateEnded
};

@interface CHTLoadMoreView : UICollectionReusableView
@property (nonatomic, assign) CHTLoadMoreState state;
@end
