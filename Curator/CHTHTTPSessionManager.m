//
//  CHTHTTPSessionManager.m
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTHTTPSessionManager.h"
#import "CHTAtlas.h"
#import "CHTBeauty.h"

NSString *const CHTErrorDomain = @"CHTErrorDomain";

@interface CHTHTTPSessionManager (Addons)
+ (NSError *)errorWithResponseObject:(id)responseObject differentFromExpectedClass:(Class)class;
@end

@implementation CHTHTTPSessionManager

#pragma mark - Public Methods

+ (CHTHTTPSessionManager *)sharedManager {
  static dispatch_once_t once;
  static CHTHTTPSessionManager *_sharedManager;
  dispatch_once(&once, ^{
    _sharedManager = [[CHTHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:CHTBaseURL]];
  });
  return _sharedManager;
}

- (void)fetchStreamAtPage:(NSInteger)page
                  success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
  NSString *path = @"stream";
  NSDictionary *parameters =
  @{
    @"page": @(page),
    @"token": CHTAccessToken
  };
  [self fetchPath:path parameters:parameters success:successBlock failure:failureBlock];
}

- (void)fetchGirlOfTheDayOverviewAtPage:(NSInteger)page
                                success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                                failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
  NSString *path = @"girl_of_the_day";
  NSDictionary *parameters =
  @{
    @"token": CHTAccessToken
  };
  [self fetchPath:path parameters:parameters success:successBlock failure:failureBlock];
}

- (void)fetchGirlOfTheDay:(NSString *)date
                   atPage:(NSInteger)page
                  success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
                  failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
  NSString *path = [NSString stringWithFormat:@"girl_of_the_day/%@", date];
  NSDictionary *parameters =
  @{
    @"token": CHTAccessToken
  };

  [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([responseObject isKindOfClass:[NSArray class]]) {
      if (successBlock) {
        NSArray *results = responseObject;
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *obj in results) {
          CHTBeauty *beauty = [MTLJSONAdapter modelOfClass:[CHTBeauty class] fromJSONDictionary:obj error:nil];
          [images addObject:beauty];
        }
        successBlock(images, 0, responseObject);
      }
    } else if (failureBlock) {
      NSError *error = [CHTHTTPSessionManager errorWithResponseObject:responseObject
                                           differentFromExpectedClass:[NSArray class]];
      failureBlock(task, error);
    }
  } failure:failureBlock];
}

#pragma mark - Private Methods

- (void)fetchPath:(NSString *)path
       parameters:(NSDictionary *)parameters
          success:(void (^)(NSArray *beauties, NSInteger totalCount, id responseObject))successBlock
          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failureBlock {
  [self GET:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
      if (successBlock) {
        NSInteger count = [responseObject[@"count"] integerValue];
        NSArray *results = responseObject[@"results"];
        NSMutableArray *images = [NSMutableArray array];
        for (NSDictionary *obj in results) {
          CHTBeauty *beauty = [MTLJSONAdapter modelOfClass:[CHTBeauty class] fromJSONDictionary:obj error:nil];
          [images addObject:beauty];
        }
        successBlock(images, count, responseObject);
      }
    } else if (failureBlock) {
      NSError *error = [CHTHTTPSessionManager errorWithResponseObject:responseObject
                                           differentFromExpectedClass:[NSDictionary class]];
      failureBlock(task, error);
    }
  } failure:failureBlock];
}

@end

#pragma mark - Private Category

@implementation CHTHTTPSessionManager (Addons)

+ (NSError *)errorWithResponseObject:(id)responseObject differentFromExpectedClass:(Class)class {
  NSDictionary *userInfo = @{
    NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Expected %@, got %@", class, [responseObject class]]
  };
  NSError *error = [NSError errorWithDomain:CHTErrorDomain code:NSURLErrorCannotParseResponse userInfo:userInfo];
  return error;
}

@end
