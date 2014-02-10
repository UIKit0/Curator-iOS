//
//  CHTFetchingBaseViewController.m
//  Curator
//
//  Created by Nelson Tai on 2014/2/8.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTFetchingBaseViewController.h"

@interface CHTFetchingBaseViewController ()
@property (nonatomic, strong, readwrite) UIRefreshControl *refreshControl;
@property (nonatomic, strong, readwrite) NSMutableArray *beauties;
@property (nonatomic, copy, readwrite) void (^fetchSuccessfulBlock)(NSArray *beauties, NSInteger totalCount, id responseObject);
@property (nonatomic, copy, readwrite) void (^fetchFailedBlock)(NSURLSessionDataTask *task, NSError *error);
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) BOOL isFetching;
@end

@implementation CHTFetchingBaseViewController

#pragma mark - Properties

- (UIRefreshControl *)refreshControl {
  if (!_refreshControl) {
    _refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
  }
  return _refreshControl;
}

- (NSMutableArray *)beauties {
  if (!_beauties) {
    _beauties = [NSMutableArray array];
  }
  return _beauties;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  __weak typeof(self) weakSelf = self;

  self.fetchSuccessfulBlock = ^(NSArray *beauties, NSInteger totalCount, id responseObject) {
    __strong typeof(self) strongSelf = weakSelf;

    if (!strongSelf) {
      return;
    }

    if (strongSelf.fetchPage == 1) {
      [strongSelf.beauties removeAllObjects];
      [strongSelf.beauties addObjectsFromArray:beauties];
      [strongSelf.collectionView reloadData];
    } else {
      NSMutableArray *indexPaths = [NSMutableArray array];
      NSInteger offset = strongSelf.beauties.count;
      [strongSelf.beauties addObjectsFromArray:beauties];
      for (NSInteger i = offset; i < strongSelf.beauties.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [indexPaths addObject:indexPath];
      }
      [strongSelf.collectionView insertItemsAtIndexPaths:indexPaths];
    }
    [strongSelf.refreshControl endRefreshing];
    strongSelf.canLoadMore = (beauties.count > 0 && strongSelf.beauties.count < totalCount);
    strongSelf.fetchPage++;
    strongSelf.isFetching = NO;
  };

  self.fetchFailedBlock = ^(NSURLSessionDataTask *task, NSError *error) {
    __strong typeof(self) strongSelf = weakSelf;

    if (!strongSelf) {
      return;
    }

    strongSelf.isFetching = NO;
    [strongSelf.refreshControl endRefreshing];
    NSLog(@"Error:\n%@", error);
  };

  self.shouldShowCellWithName = YES;
  [self.collectionView addSubview:self.refreshControl];
  [self refresh];
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  if (self.isFetching) {
    return;
  }
  self.isFetching = YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return self.beauties.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"BeautyCell";
  CHTBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                  forIndexPath:indexPath];
  CHTBeauty *beauty = self.beauties[indexPath.item];

  [cell configureWithBeauty:beauty showName:self.shouldShowCellWithName];

  return cell;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if (self.isFetching) {
    return;
  }
  if (!self.canLoadMore) {
    return;
  }
  if (scrollView.contentOffset.y < scrollView.contentSize.height - scrollView.frame.size.height) {
    return;
  }
  [self fetchBeauties];
}

#pragma mark - Private Methods

- (void)refresh {
  self.canLoadMore = NO;
  self.isFetching = NO;
  self.fetchPage = 1;
  [self fetchBeauties];
}

@end
