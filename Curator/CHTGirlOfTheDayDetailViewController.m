//
//  CHTGirlOfTheDayDetailViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/30.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTGirlOfTheDayDetailViewController.h"
#import "CHTLargeImageViewController.h"
#import "CHTHTTPSessionManager.h"
#import "CHTNavigatonBarTitleView.h"
#import "NSString+Date.h"
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>

@interface CHTGirlOfTheDayDetailViewController () <NHBalancedFlowLayoutDelegate>
@end

@implementation CHTGirlOfTheDayDetailViewController

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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTLargeImageViewController *vc = segue.destinationViewController;
  vc.mode = CHTLargeImageViewDisplayModeIndex;
  vc.beauties = self.beauties;
  vc.selectedIndex = indexPath.item;
}

#pragma mark - NHBalancedFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item < 0 || indexPath.item >= self.beauties.count) {
    return CGSizeZero;
  }

  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.thumbnailWidth, beauty.thumbnailHeight);
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDay:self.beauty.whichDay atPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

@end
