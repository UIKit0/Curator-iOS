//
//  CHTGirlOfTheDayDetailViewController+BDBDetailViewController.m
//  Curator
//
//  Created by Nelson on 2014/4/7.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTGirlOfTheDayDetailViewController+BDBDetailViewController.h"

@implementation CHTGirlOfTheDayDetailViewController (BDBDetailViewController)

#pragma mark - UISplitViewControllerDelegate

- (BOOL)splitViewController:(BDBSplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
  switch (svc.masterViewDisplayStyle) {
    case BDBMasterViewDisplayStyleSticky:
      return NO;

    case BDBMasterViewDisplayStyleDrawer:
      return svc.masterViewIsHidden;

    case BDBMasterViewDisplayStyleNormal:
    default:
      if (svc.masterViewIsHidden)
        return UIInterfaceOrientationIsPortrait(orientation);
      else
        return NO;
  }
}

@end
