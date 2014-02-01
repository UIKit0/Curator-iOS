//
//  CHTCollectionViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/29.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTGirlOfTheDayOverviewController.h"
#import "CHTGirlOfTheDayDetailViewController.h"
#import "CHTHTTPSessionManager.h"
#import "CHTBeauty.h"
#import "CHTBeautyCell.h"
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>
#import <SVProgressHUD/SVProgressHUD.h>

@interface CHTGirlOfTheDayOverviewController () <NHBalancedFlowLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *beauties;
@property (nonatomic, assign) BOOL isFetching;
@property (nonatomic, assign) NSInteger fetchPage;
@end

@implementation CHTGirlOfTheDayOverviewController

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

  NHBalancedFlowLayout *layout = (NHBalancedFlowLayout *)self.collectionViewLayout;
  CGFloat spacing;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    spacing = 15;
  } else {
    spacing = 5;
  }
  layout.minimumLineSpacing = spacing;
  layout.minimumInteritemSpacing = spacing;
  layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);

  self.isFetching = NO;
  self.fetchPage = 1;
  [self fetchBeauties];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTGirlOfTheDayDetailViewController *vc = (CHTGirlOfTheDayDetailViewController *)segue.destinationViewController;
  vc.beauty = self.beauties[indexPath.item];
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

#pragma mark - NHBalancedFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item < 0 || indexPath.item >= self.beauties.count) {
    return CGSizeZero;
  }

  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.width, beauty.height);
}

#pragma mark - Private Methods

- (void)fetchBeauties {
  if (self.isFetching) {
    return;
  }

  self.isFetching = YES;
  [SVProgressHUD showWithStatus:@"Loading..."];

  __weak typeof(self) weakSelf = self;
  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDayOverviewAtPage:self.fetchPage success:^(NSArray *beauties, NSInteger totalCount, id responseObject) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }
    [strongSelf.beauties addObjectsFromArray:beauties];
    [strongSelf.collectionView reloadData];
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

@end
