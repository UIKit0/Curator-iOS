//
//  NSString+Date.m
//  Curator
//
//  Created by Nelson on 2014/3/26.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)

+ (NSString *)dateStringFromString:(NSString *)inputString {
  static dispatch_once_t once;
  static NSLocale *locale = nil;
  static NSDateFormatter *stringToDateFormatter = nil;
  static NSDateFormatter *dateToStringFormatter = nil;

  dispatch_once(&once, ^{
    stringToDateFormatter = [[NSDateFormatter alloc] init];
    [stringToDateFormatter setDateFormat:@"yyyy-MM-dd"];

    locale = [NSLocale currentLocale];
    dateToStringFormatter = [[NSDateFormatter alloc] init];
    [dateToStringFormatter setLocale:locale];
    [dateToStringFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateToStringFormatter setTimeStyle:NSDateFormatterNoStyle];
  });

  NSDate *date = [stringToDateFormatter dateFromString:inputString];
  return [dateToStringFormatter stringFromDate:date];
}

@end
