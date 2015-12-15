//
//  MZPageViewController.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIViewController * (^ ETHPageViewControllerFactoryBlock)(void);

@interface MZPageViewController : UIPageViewController

- (UIViewController *)currentViewController;
- (UIViewController *)viewControllerForPage:(NSInteger)page;
- (ETHPageViewControllerFactoryBlock)viewControllerFactoryForPage:(NSInteger)page;

- (NSString *)titleForViewControllerForPage:(NSInteger)page;
- (NSAttributedString *)attributedTitleForViewControllerForPage:(NSInteger)page;

- (NSInteger)numberOfPage;
- (NSInteger)currentPage;
- (void)setCurrentPage:(NSInteger)page;

- (void)willChangeToPage:(NSInteger)page;
- (void)didChangeToPage:(NSInteger)page;

@end
