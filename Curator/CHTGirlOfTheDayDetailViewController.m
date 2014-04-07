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
#import "CHTGirlOfTheDayDetailViewController+BDBDetailViewController.h"
#import "NSString+Date.h"
#import <NHBalancedFlowLayout/NHBalancedFlowLayout.h>

@interface CHTGirlOfTheDayDetailViewController () <NHBalancedFlowLayoutDelegate>
@property (nonatomic, strong) CHTNavigatonBarTitleView *titleView;
@property (nonatomic, strong) CHTFullScreenPagingBeautyView *fullScreenView;
@end

@implementation CHTGirlOfTheDayDetailViewController

#pragma mark - Properties

- (CHTNavigatonBarTitleView *)titleView {
  if (!_titleView) {
    _titleView = [[CHTNavigatonBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 230, 44)];
  }
  return _titleView;
}

- (CHTFullScreenPagingBeautyView *)fullScreenView {
  if (!_fullScreenView) {
    _fullScreenView = [[CHTFullScreenPagingBeautyView alloc] init];
    _fullScreenView.mode = CHTFullScreenPagingBeautyViewDisplayModeIndex;
  }
  return _fullScreenView;
}

- (void)setBeauty:(CHTBeauty *)beauty {
  if ([_beauty isEqual:beauty]) {
    return;
  }

  _beauty = beauty;
  [self.titleView setTitle:_beauty.name subtitle:[NSString dateStringFromString:_beauty.whichDay]];
  [self fetchBeauties];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.refreshControl removeFromSuperview];

  self.navigationItem.titleView = self.titleView;

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

  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    self.splitViewController.delegate = self;
    [self.splitViewController setMasterViewDisplayStyle:BDBMasterViewDisplayStyleSticky animated:NO];
    [self.splitViewController showMasterViewControllerAnimated:NO completion:nil];
  } else {
    // Swipe right to go back
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
    recognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:recognizer];
  }
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
  if (!self.beauty) {
    return;
  }

  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDay:self.beauty.whichDay atPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

#pragma mark - Private Methods

- (void)pop {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
