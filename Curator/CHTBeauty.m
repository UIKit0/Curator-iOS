//
//  CHTBeauty.m
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTBeauty.h"

@implementation CHTBeauty

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
  return @{
    @"name": @"name",
    @"objectID": @"id",
    @"urlString": @"image",
    @"width": @"width",
    @"height": @"height",
    @"whichDay": @"date"
  };
}

@end
