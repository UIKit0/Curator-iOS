//
//  CHTStreamViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTStreamViewController.h"
#import "CHTLargeImageViewController.h"
#import "CHTHTTPSessionManager.h"
#import "CHTBeauty.h"
#import "CHTBeautyCell.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CHTStreamViewController () <CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) NSMutableArray *beauties;
@property (nonatomic, assign) BOOL canLoadMore;
@property (nonatomic, assign) BOOL isFetching;
@property (nonatomic, assign) NSInteger fetchPage;
@end

@implementation CHTStreamViewController

#pragma mark - Properties

- (NSMutableArray *)beauties {
  if (!_beauties) {
    _beauties = [NSMutableArray array];
  }
  return _beauties;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  [self setupCollectionViewLayoutForOrientation:orientation];

  self.canLoadMore = NO;
  self.isFetching = NO;
  self.fetchPage = 1;
  [self fetchBeauties];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  [self setupCollectionViewLayoutForOrientation:toInterfaceOrientation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTLargeImageViewController *vc = segue.destinationViewController;
  vc.beauties = self.beauties;
  vc.selectedIndex = indexPath.item;
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
  [cell configureWithBeauty:beauty showName:YES];

  return cell;
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTBeauty *beauty = self.beauties[indexPath.item];
  return beauty.height * 236 / beauty.width;
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

- (void)fetchBeauties {
  if (self.isFetching) {
    return;
  }

  self.isFetching = YES;
  [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];

  __weak typeof(self) weakSelf = self;
  [[CHTHTTPSessionManager sharedManager] fetchStreamAtPage:self.fetchPage success:^(NSArray *beauties, NSInteger totalCount, id responseObject) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }

//    if (strongSelf.fetchPage == 1) {
//      [strongSelf.beauties removeAllObjects];
      [strongSelf.beauties addObjectsFromArray:beauties];
      [strongSelf.collectionView reloadData];
//    } else {
//      NSMutableArray *indexPaths = [NSMutableArray array];
//      NSInteger offset = strongSelf.beauties.count;
//      [strongSelf.beauties addObjectsFromArray:beauties];
//      for (NSInteger i = offset; i < strongSelf.beauties.count; i++) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        [indexPaths addObject:indexPath];
//      }
//      [strongSelf.collectionView insertItemsAtIndexPaths:indexPaths];
//    }
    strongSelf.canLoadMore = (beauties.count > 0 && strongSelf.beauties.count < totalCount);
    strongSelf.fetchPage++;
    strongSelf.isFetching = NO;
    [SVProgressHUD dismiss];
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    strongSelf.isFetching = NO;
    [SVProgressHUD dismiss];
    NSLog(@"Error:\n%@", error);
  }];
}

- (void)setupCollectionViewLayoutForOrientation:(UIInterfaceOrientation)orientation {
  CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
  layout.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15);
  layout.itemWidth = 236;

  if (UIInterfaceOrientationIsPortrait(orientation)) {
    layout.columnCount = 3;
  } else {
    layout.columnCount = 4;
  }
}

@end
