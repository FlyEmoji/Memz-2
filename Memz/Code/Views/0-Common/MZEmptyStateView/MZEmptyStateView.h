//
//  MZEmptyStateView.h
//  Memz
//
//  Created by Bastien Falcou on 5/18/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"

IB_DESIGNABLE

@interface MZEmptyStateView : MZNibView

@property (nonatomic, strong) IBInspectable UIImage *emptyStateImage;
@property (nonatomic, strong) IBInspectable NSString *emptyStateDescription;  

@end
