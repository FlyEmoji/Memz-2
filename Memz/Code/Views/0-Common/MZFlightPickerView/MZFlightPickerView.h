//
//  MZFlightPickerView.h
//  Memz
//
//  Created by Bastien Falcou on 5/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"
#import "MZLanguageDefinition.h"

#define NO_INDEX -1

typedef void (^ MZFlightPickerCompletionHandler)(NSUInteger selectedIndex);  // NO_INDEX if dismissed without picking any cell

@interface MZFlightPickerView : MZNibView

@property (nonatomic, strong) NSArray<UIImage *> *pickableData;

+ (MZFlightPickerView *)displayFlightPickerInView:(UIView *)containerView
																startingFromPoint:(CGPoint)topCenterPoint
																				 withData:(NSArray<UIImage *> *)data
																				 animated:(BOOL)animated
																 pickAtIndexBlock:(MZFlightPickerCompletionHandler)completionHandler;

- (void)dismissAnimated:(BOOL)animated;  // calls completion handler with value NO_INDEX and nullifies it

@end
