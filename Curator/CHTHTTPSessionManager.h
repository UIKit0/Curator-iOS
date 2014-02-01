//
//  CHTHTTPSessionManager.h
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface CHTHTTPSessionManager : AFHTTPSessionManager

+ (CHTHTTPSessionManager *)sharedManager;

- (void)fetchStreamAtPage:(NSInteger)page
                  success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)fetchGirlOfTheDayOverviewAtPage:(NSInteger)page
                                success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

- (void)fetchGirlOfTheDay:(NSString *)date
                   atPage:(NSInteger)page
                  success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock;

@end
