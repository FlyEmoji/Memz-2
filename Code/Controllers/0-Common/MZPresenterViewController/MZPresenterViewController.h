//
//  MZPresenterViewController.h
//  Memz
//
//  Created by Bastien Falcou on 1/25/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZTransitioningDefaultBehavior.h"

/* Presenter View Controller implements reusable code and behavior to present other View Controllers with custom 
 * transitions. It can be seen as a main View Controller that will always be responsible for initiating new flows /
 * controllers. Its shared transitionBehavior can notably be used every time a MZPresentableViewController is
 * presented in order to enjoy its already implemented transitioning behavior.
 */

@interface MZPresenterViewController : UIViewController

@property (nonatomic, strong) MZTransitioningDefaultBehavior *transitioningBehavior;

@end
