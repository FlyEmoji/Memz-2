//
//  MZLoaderView.h
//  Memz
//
//  Created by Bastien Falcou on 4/27/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"

@interface MZLoaderView : MZNibView

+ (instancetype)showInView:(UIView *)view;  // spinning, centered and size reduces if needed

+ (BOOL)hideFromView:(UIView *)view;
+ (BOOL)hideAllLoadersFromView:(UIView *)view;

- (void)hide;  // hide instance only

@end
