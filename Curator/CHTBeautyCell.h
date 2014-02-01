//
//  CHTBeautyCell.h
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTBeauty;

@interface CHTBeautyCell : UICollectionViewCell
- (void)configureWithBeauty:(CHTBeauty *)beauty showName:(BOOL)showName;
@end
