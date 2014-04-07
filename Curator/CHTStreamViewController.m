//
//  CHTStreamViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTStreamViewController.h"
#import "CHTHTTPSessionManager.h"
#import "CHTFullScreenPagingBeautyView.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface CHTStreamViewController () <CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) CHTFullScreenPagingBeautyView *fullScreenView;
@end

@implementation CHTStreamViewController

#pragma mark - Properties

- (CHTFullScreenPagingBeautyView *)fullScreenView {
  if (!_fullScreenView) {
    _fullScreenView = [[CHTFullScreenPagingBeautyView alloc] init];
    _fullScreenView.mode = CHTFullScreenPagingBeautyViewDisplayModeNmae;
  }
  return _fullScreenView;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
  layout.footerHeight = 40;

  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
  self.navigationItem.titleView = titleView;

  [self registerCollectionSectionFooterViewForSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter];

  [self refresh];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  [self setupCollectionViewLayoutForOrientation:orientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  [self setupCollectionViewLayoutForOrientation:toInterfaceOrientation];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.thumbnailWidth, beauty.thumbnailHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  self.fullScreenView.beauties = self.beauties;
  self.fullScreenView.selectedIndex = indexPath.item;
  [self.fullScreenView present];
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchStreamAtPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

#pragma mark - Private Methods

- (void)setupCollectionViewLayoutForOrientation:(UIInterfaceOrientation)orientation {
  CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
  CGFloat spacing;

  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    spacing = 15;
    if (UIInterfaceOrientationIsPortrait(orientation)) {
      layout.columnCount = 3;
    } else {
      layout.columnCount = 4;
    }
  } else {
    spacing = 5;
    layout.columnCount = 2;
  }
  layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
  layout.minimumColumnSpacing = spacing;
  layout.minimumInteritemSpacing = spacing;
}

@end
