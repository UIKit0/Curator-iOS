//
//  CHTHTTPSessionManagerSpec.m
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "Kiwi.h"
#import "CHTHTTPSessionManager.h"

const NSUInteger CHTTestDefaultTimeout = 5;

SPEC_BEGIN(CHTHTTPSessionManagerSpec)

describe(@"Fetch Stream", ^{
  it(@"should fetch stream at first page", ^{
    __block NSArray *_beauties;

    [[CHTHTTPSessionManager sharedManager] fetchStreamAtPage:1 success:^(NSArray *beauties, NSInteger totalCount, id responseObject) {
      _beauties = beauties;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
      NSLog(@"error: %@\n", error.userInfo);
    }];

    [[expectFutureValue(_beauties) shouldEventuallyBeforeTimingOutAfter(CHTTestDefaultTimeout)] beNonNil];
  });
});

SPEC_END
