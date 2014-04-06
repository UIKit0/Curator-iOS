//
//  CHTFetchingBaseViewController.m
//  Curator
//
//  Created by Nelson Tai on 2014/2/8.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTFetchingBaseViewController.h"
#import "CHTLoadMoreView.h"

static NSString *footerIdentifier = @"footerIdentifier";

@interface CHTFetchingBaseViewController ()
@property (nonatomic, strong, readwrite) UIRefreshControl *refreshControl;
@property (nonatomic, strong, readwrite) NSMutableArray *beauties;
@property (nonatomic, copy, readwrite) void (^fetchSuccessfulBlock)(NSArray *beauties, NSInteger totalCount, id responseObject);
@property (nonatomic, copy, readwrite) void (^fetchFailedBlock)(NSURLSessionDataTask *task, NSError *error);
@property (nonatomic, assign, readwrite) NSInteger fetchPage;
@property (nonatomic, assign, readwrite) BOOL canLoadMore;
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

  self.navigationController.navigationBar.tintColor = [UIColor redColor];
  self.tabBarController.tabBar.tintColor = [UIColor redColor];
  self.collectionView.backgroundColor = [UIColor colorWithRed:0.117 green:0.112 blue:0.106 alpha:1.000];
  [self.collectionView registerNib:[UINib nibWithNibName:@"CHTBeautyCell" bundle:nil] forCellWithReuseIdentifier:@"BeautyCell"];


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

- (void)registerCollectionSectionFooterViewForSupplementaryViewOfKind:(NSString *)kind {
  [self.collectionView registerClass:[CHTLoadMoreView class] forSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier];
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
  CHTBeautyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  CHTBeauty *beauty = self.beauties[indexPath.item];

  [cell configureWithBeauty:beauty showName:self.shouldShowCellWithName];

  return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
  CHTLoadMoreView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];

  view.state = (self.canLoadMore) ? CHTLoadMoreStateLoading : CHTLoadMoreStateEnded;

  return view;
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
  self.canLoadMore = YES;
  self.isFetching = NO;
  self.fetchPage = 1;
  [self fetchBeauties];
}

@end
