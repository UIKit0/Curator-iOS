//
//  CHTFullScreenPagingBeautyView.h
//  Curator
//
//  Created by Nelson on 2014/3/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CHTFullScreenPagingBeautyViewDisplayMode) {
  CHTFullScreenPagingBeautyViewDisplayModeNmae,
  CHTFullScreenPagingBeautyViewDisplayModeIndex
};

@interface CHTFullScreenPagingBeautyView : UIView
@property (nonatomic, copy) NSArray *beauties;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CHTFullScreenPagingBeautyViewDisplayMode mode;
- (void)present;
- (void)dismiss;
@end
