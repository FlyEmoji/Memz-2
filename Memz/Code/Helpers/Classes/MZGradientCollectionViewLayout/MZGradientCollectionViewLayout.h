//
//  MZGradientCollectionViewLayout.h
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCollectionViewLayoutAttributes.h"

/* Subclasses that need to provide custom collection attributes must override class method layoutAttributesClass to
 * provide new attributes class. It must be a subclass of MZCollectionViewLayoutAttributes.
 */

@interface MZGradientCollectionViewLayout : UICollectionViewLayout

/* Appearance and disappearance animation duration on cells (upon inserting/deleting/moving cells dynamically).
 * Default duration is 0.4 seconds.
 */
@property (nonatomic, assign) NSTimeInterval appearanceAnimationDuration;

/* 
 * Optional progressive delay before cells appear/disappear according to their indexPath. For a given cell, the delay
 * before animation will be equal to indexPath.item * indexRelativeDelayCellAnimations.
 * This notably allows a nice global appearance effect if inserting all cells at once (cascade effect with cells appearing
 * or disappearing successively, one by one from left to right). No delay by default (0.0 second).
 */
@property (nonatomic, assign) NSTimeInterval relativeDelayCellAnimations;

@end
