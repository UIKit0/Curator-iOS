//
//  CHTLargeImageViewController.m
//  Curator
//
//  Created by Nelson on 2014/1/31.
//  Copyright (c) 2014年 Nelson. All rights reserved.
//

#import "CHTLargeImageViewController.h"
#import "CHTLargeImageView.h"
#import "CHTBeauty.h"
#import <Nimbus/NIPagingScrollView.h>

@interface CHTLargeImageViewController () <
  NIPagingScrollViewDelegate,
  NIPagingScrollViewDataSource
>
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet NIPagingScrollView *pagingScrollView;
@end

@implementation CHTLargeImageViewController

#pragma mark - UIViewController

- (void)dealloc {
  _pagingScrollView.delegate = nil;
  _pagingScrollView.dataSource = nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.pagingScrollView.delegate = self;
  self.pagingScrollView.dataSource = self;

  // Trick to make pagingScrollView rotate correctly
  [self performSelector:@selector(triggerPagingScrollView) withObject:nil afterDelay:0.2];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
  }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
  [self.pagingScrollView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
  [self.pagingScrollView willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

#pragma mark - NIPagingScrollViewDataSource

- (NSInteger)numberOfPagesInPagingScrollView:(NIPagingScrollView *)pagingScrollView {
  return self.beauties.count;
}

- (UIView <NIPagingScrollViewPage> *)pagingScrollView:(NIPagingScrollView *)pagingScrollView pageViewForIndex:(NSInteger)pageIndex {
  static NSString *identifier = @"LargeImage";
  CHTLargeImageView *imageView = (CHTLargeImageView *)[pagingScrollView dequeueReusablePageWithIdentifier:identifier];

  if (!imageView) {
    imageView = [[CHTLargeImageView alloc] initWithReuseIdentifier:identifier];
  }

  [imageView configureWithBeauty:self.beauties[pageIndex]];

  return imageView;
}

#pragma mark - NIPagingScrollViewDelegate

- (void)pagingScrollViewDidChangePages:(NIPagingScrollView *)pagingScrollView {
  [self configureInfoDisplay];
}

- (IBAction)dismiss:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private

- (void)triggerPagingScrollView {
  [self.pagingScrollView reloadData];
  self.pagingScrollView.centerPageIndex = self.selectedIndex;
  [self configureInfoDisplay];
}

- (void)configureInfoDisplay {
  CHTBeauty *beauty = self.beauties[self.pagingScrollView.centerPageIndex];
  self.title = beauty.name;

  if (self.mode == CHTLargeImageViewDisplayModeNmae) {
    self.infoLabel.text = beauty.name;
  } else {
    self.infoLabel.text = [NSString stringWithFormat:@"%ld/%lu", (long)(self.pagingScrollView.centerPageIndex + 1), (unsigned long)[self.beauties count]];
  }
}

@end
