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
#import <BDBSplitViewController/BDBSplitViewController.h>

@interface CHTGirlOfTheDayOverviewController () <CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong, readonly) CHTGirlOfTheDayDetailViewController *detailViewController;
@end

@implementation CHTGirlOfTheDayOverviewController

#pragma mark - Properties

- (CHTGirlOfTheDayDetailViewController *)detailViewController {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    return (CHTGirlOfTheDayDetailViewController *)[(UINavigationController *)self.splitViewController.detailViewController topViewController];
  } else {
    return nil;
  }
}

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

  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    // Do nothing
  } else {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
  }

  [self refresh];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTGirlOfTheDayDetailViewController *vc = (CHTGirlOfTheDayDetailViewController *)segue.destinationViewController;
  vc.beauty = (CHTBeauty *)sender;
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
  CHTBeauty *beauty = self.beauties[indexPath.item];

  if (self.detailViewController) {
    self.detailViewController.beauty = beauty;
  } else {
    [self performSegueWithIdentifier:@"Show Detail" sender:beauty];
  }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  CHTBeauty *beauty = self.beauties[indexPath.item];
  return CGSizeMake(beauty.thumbnailWidth, beauty.thumbnailHeight);
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  __weak typeof(self) weakSelf = self;
  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDayOverviewAtPage:self.fetchPage success:^(NSArray *beauties, NSInteger totalCount, id responseObject) {
    __strong typeof(self) strongSelf = weakSelf;
    if (!strongSelf) {
      return;
    }

    if (strongSelf.fetchSuccessfulBlock) {
      strongSelf.fetchSuccessfulBlock(beauties, totalCount, responseObject);
      if (strongSelf.fetchPage == 2) {
        strongSelf.detailViewController.beauty = [strongSelf.beauties firstObject];
      }
    }
  } failure:self.fetchFailedBlock];
}

@end
