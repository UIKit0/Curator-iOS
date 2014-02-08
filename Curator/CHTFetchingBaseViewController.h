//
//  CHTFetchingBaseViewController.h
//  Curator
//
//  Created by Nelson Tai on 2014/2/8.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHTBeauty.h"
#import "CHTBeautyCell.h"

@protocol CHTFetchingBaseViewControllerDelegate;

/**
 *  This is the base collection view controller for fetching beauties.
 *
 *  It adds a pulldown-to-refresh control to the collection view and handle the
 *  fetching action for you.
 *
 *  It also defines a success block and a failure block, you need to call them
 *  when fetching is complete or failed, respectively.
 *
 *  Subclasses should setup their collection view's layout and/or
 *  remove the refresh controll (if they don't need this) in `viewDidLoad`.
 *  @note Subclasses should call `[super viewDidLoad] first.
 */
@interface CHTFetchingBaseViewController : UICollectionViewController

/// A pulldown-to-refresh control
@property (nonatomic, strong, readonly) UIRefreshControl *refreshControl;

/// An array of CHTBeauty objects
@property (nonatomic, strong, readonly) NSMutableArray *beauties;

/// Current fetch page
@property (nonatomic, assign) NSInteger fetchPage;

/// Call this block when succeed to fetch data
@property (nonatomic, copy, readonly) void (^fetchSuccessfulBlock)(NSArray *beauties, NSInteger totalCount, id responseObject);

/// Call this block when fail to fetch data
@property (nonatomic, copy, readonly) void (^fetchFailedBlock)(NSURLSessionDataTask *task, NSError *error);

/// Delegate for customizing behaviours
@property (nonatomic, weak) id<CHTFetchingBaseViewControllerDelegate> delegate;

/**
 *  Common work before fetching beauties.
 *  Subclasses must call `[super fetchBeauties]` first.
 */
- (void)fetchBeauties;
@end

@protocol CHTFetchingBaseViewControllerDelegate <NSObject>

@optional
- (BOOL) fetchingBaseViewControllerShouldShowBeautyName: (CHTFetchingBaseViewController *) fetchingBaseViewController;

@end

