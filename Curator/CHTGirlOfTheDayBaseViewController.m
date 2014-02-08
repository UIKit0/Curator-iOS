//
//  CHTGirlOfTheDayBaseViewController.m
//  Curator
//
//  Created by Nelson Tai on 2014/2/8.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTGirlOfTheDayBaseViewController.h"
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>

@interface CHTGirlOfTheDayBaseViewController () <NHBalancedFlowLayoutDelegate>
@end

@implementation CHTGirlOfTheDayBaseViewController

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
}

#pragma mark - NHBalancedFlowLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(NHBalancedFlowLayout *)collectionViewLayout preferredSizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.item < 0 || indexPath.item >= self.beauties.count) {
    return CGSizeZero;
  }

  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.thumbnailWidth, beauty.thumbnailHeight);
}

@end
