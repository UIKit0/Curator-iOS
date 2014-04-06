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
#import "CHTBeautyOfTheDayCell.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>

@interface CHTGirlOfTheDayOverviewController () <CHTCollectionViewDelegateWaterfallLayout>
@end

@implementation CHTGirlOfTheDayOverviewController

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.collectionView registerNib:[UINib nibWithNibName:@"CHTBeautyOfTheDayCell" bundle:nil] forCellWithReuseIdentifier:@"BeautyCell"];

  CHTCollectionViewWaterfallLayout *layout = (CHTCollectionViewWaterfallLayout *)self.collectionViewLayout;
  layout.footerHeight = 40;
  layout.columnCount = 1;

  CGFloat spacing;
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    spacing = 15;
  } else {
    spacing = 5;
  }

  layout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
  layout.minimumColumnSpacing = spacing;
  layout.minimumInteritemSpacing = spacing;

  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
  self.navigationItem.titleView = titleView;

  [self registerCollectionSectionFooterViewForSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter];

  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  self.navigationItem.backBarButtonItem = backItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  NSIndexPath *indexPath = (NSIndexPath *)sender;
  CHTGirlOfTheDayDetailViewController *vc = (CHTGirlOfTheDayDetailViewController *)segue.destinationViewController;
  vc.beauty = self.beauties[indexPath.item];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"BeautyCell";
  CHTBeautyOfTheDayCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
  CHTBeauty *beauty = self.beauties[indexPath.item];

  [cell configureWithBeauty:beauty];

  return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  [self performSegueWithIdentifier:@"Show Detail" sender:indexPath];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.thumbnailWidth, beauty.thumbnailHeight);
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDayOverviewAtPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

@end
