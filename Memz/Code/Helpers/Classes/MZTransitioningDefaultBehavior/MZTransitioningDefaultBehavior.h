//
//  MZTransitioningDefaultBehavior.h
//  Memz
//
//  Created by Bastien Falcou on 1/25/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MZPresentableViewController.h"

/* Object implements UIViewControllerTransitioningDelegate and MZPresentableViewControllerTransitioning delegate 
 * methods that will automatically instanciate appropriate objects for custom View Controller transition animations.
 * 
 * (1) Conforms to UIViewControllerTransitioningDelegate for automatic transition behavior upon present/dismiss:
 * Uses MZPresentViewController for custom appearance animation (present).
 * Uses MZPullViewControllerTransition for custom dismissal animation (dismiss).
 *
 * (2) Conforms to MZPresentableViewControllerTransitioning for automatic behavior upon receiving notifications
 * from the presented view controller, for dismissal interactive behavior notably.
 *
 * This object has been created separate for a sake of composition pattern (could not have been used using inheritance
 * only given the number and variety of view controllers that need this transitioning implementation).
 */

@interface MZTransitioningDefaultBehavior : NSObject <UIViewControllerTransitioningDelegate,
MZPresentableViewControllerTransitioning>

@end
