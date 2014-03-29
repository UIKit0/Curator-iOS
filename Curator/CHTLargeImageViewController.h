//
//  CHTLargeImageViewController.h
//  Curator
//
//  Created by Nelson on 2014/1/31.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, CHTLargeImageViewDisplayMode) {
  CHTLargeImageViewDisplayModeNmae,
  CHTLargeImageViewDisplayModeIndex
};

@interface CHTLargeImageViewController : UIViewController
@property (nonatomic, strong) NSArray *beauties;
@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic, assign) CHTLargeImageViewDisplayMode mode;
@end
