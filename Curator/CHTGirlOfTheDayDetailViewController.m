//
//  CHTGirlOfTheDayDetailViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTGirlOfTheDayDetailViewController.h"
#import "CHTHTTPSessionManager.h"
#import "CHTFullScreenPagingBeautyView.h"
#import "CHTNavigatonBarTitleView.h"
#import "NSString+Date.h"
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>

@interface CHTGirlOfTheDayDetailViewController () <NHBalancedFlowLayoutDelegate>
@property (nonatomic, strong) CHTFullScreenPagingBeautyView *fullScreenView;
@end

@implementation CHTGirlOfTheDayDetailViewController

#pragma mark - Properties

- (CHTFullScreenPagingBeautyView *)fullScreenView {
  if (!_fullScreenView) {
    _fullScreenView = [[CHTFullScreenPagingBeautyView alloc] init];
    _fullScreenView.mode = CHTFullScreenPagingBeautyViewDisplayModeIndex;
  }
  return _fullScreenView;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.refreshControl removeFromSuperview];

  CHTNavigatonBarTitleView *titleView = [[CHTNavigatonBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
  [titleView setTitle:self.beauty.name subtitle:[NSString dateStringFromString:self.beauty.whichDay]];
  self.navigationItem.titleView = titleView;

  self.shouldShowCellWithName = NO;

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
  layout.footerReferenceSize = CGSizeMake(40, 40);

  [self registerCollectionSectionFooterViewForSupplementaryViewOfKind:UICollectionElementKindSectionFooter];
}

#pragma mark - NHBalancedFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item < 0 || indexPath.item >= self.beauties.count) {
    return CGSizeZero;
  }

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

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDay:self.beauty.whichDay atPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

@end
