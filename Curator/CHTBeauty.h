//
//  CHTBeauty.h
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "Mantle.h"

@interface CHTBeauty : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, assign, readonly) NSUInteger objectID;
@property (nonatomic, copy, readonly) NSURL *thumbnailURL;
@property (nonatomic, assign, readonly) CGFloat thumbnailWidth;
@property (nonatomic, assign, readonly) CGFloat thumbnailHeight;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, copy, readonly) NSString *whichDay;

@end
