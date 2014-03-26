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

@implementation CHTGirlOfTheDayOverviewController

#pragma mark - UIViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
  self.navigationItem.titleView = titleView;

  UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  self.navigationItem.backBarButtonItem = backItem;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  CHTBeautyCell *cell = (CHTBeautyCell *)sender;
  NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
  CHTGirlOfTheDayDetailViewController *vc = (CHTGirlOfTheDayDetailViewController *)segue.destinationViewController;
  vc.beauty = self.beauties[indexPath.item];
}

#pragma mark - Public Methods

- (void)fetchBeauties {
  [super fetchBeauties];

  [[CHTHTTPSessionManager sharedManager] fetchGirlOfTheDayOverviewAtPage:self.fetchPage success:self.fetchSuccessfulBlock failure:self.fetchFailedBlock];
}

@end
