//
//  MZTableView.h
//  Memz
//
//  Created by Bastien Falcou on 1/17/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/* Custom Table View providing additional progressive background view that follows scroll gesture.
 * If Table View regular background set to transparent and progressive background set to white,
 * background color underneath Table View content will be white (progressive) and background color outside
 * of the Table View content size (when reaching bounce boundaries) will be transparent (regular).
 */

@protocol MZTableViewTransitionDelegate;

@interface MZTableView : UITableView

@property (nonatomic, strong) IBInspectable UIColor *progressiveBackgroundColor;	// Default transparent

@property (nonatomic, strong) IBOutlet id<MZTableViewTransitionDelegate> transitionDelegate;
@property (nonatomic, assign, readonly) CGFloat percentageOutOfBounds;

@end

@protocol MZTableViewTransitionDelegate <NSObject>

@optional

- (void)tableViewDidStartScrollOutOfBounds:(MZTableView *)tableView;
- (void)tableView:(MZTableView *)tableView didScrollOutOfBoundsPercentage:(CGFloat)percentage goingUp:(BOOL)goingUp;
- (void)tableView:(MZTableView *)tableView didEndScrollOutOfBoundsPercentage:(CGFloat)percentage goingUp:(BOOL)goingUp;

@end
