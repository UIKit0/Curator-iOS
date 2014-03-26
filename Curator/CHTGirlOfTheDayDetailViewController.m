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

@implementation CHTGirlOfTheDayDetailViewController

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  [self.refreshControl removeFromSuperview];

  CHTNavigatonBarTitleView *titleView = [[CHTNavigatonBarTitleView alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
  [titleView setTitle:self.beauty.name subtitle:[NSString dateStringFromString:self.beauty.whichDay]];
  self.navigationItem.titleView = titleView;

  self.shouldShowCellWithName = NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTLargeImageViewController *vc = segue.destinationViewController;
  vc.beauties = self.beauties;
  vc.selectedIndex = indexPath.item;
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDay:self.beauty.whichDay atPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

@end
