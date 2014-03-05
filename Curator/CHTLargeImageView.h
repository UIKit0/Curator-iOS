//
//  CHTLargeImageView.h
//  Curator
//
//  Created by Nelson on 2014/2/1.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "NIPagingScrollViewPage.h"

@class CHTBeauty;

@interface CHTLargeImageView : NIPagingScrollViewPage
- (void)configureWithBeauty:(CHTBeauty *)beauty;
@end
