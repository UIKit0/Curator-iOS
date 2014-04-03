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
    @"name" : @"name",
    @"objectID" : @"id",
    @"thumbnailURL" : @"thumbnail",
    @"thumbnailWidth" : @"thumbnail_width",
    @"thumbnailHeight" : @"thumbnail_height",
    @"imageURL" : @"image",
    @"width" : @"width",
    @"height" : @"height",
    @"whichDay" : @"date"
  };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)thumbnailURLJSONTransformer {
  return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
