//
//  MZGradientCollectionViewLayout.h
//  Memz
//
//  Created by Bastien Falcou on 1/28/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MZCollectionViewLayoutAttributes.h"

/* If subclassing this collection view layout and need to provide a custom collection attributes class (subclassing
 * class method layoutAttributesClass), the returned class must be a subclass of MZCollectionViewLayoutAttributes.
 */

@interface MZGradientCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, assign) BOOL positionRelativeDelayCellAnimations;		// Default NO

@end
