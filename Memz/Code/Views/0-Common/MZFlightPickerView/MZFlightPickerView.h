//
//  MZFlightPickerView.h
//  Memz
//
//  Created by Bastien Falcou on 5/14/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZNibView.h"
#import "MZLanguageDefinition.h"

typedef void (^ MZFlightPickerCompletionHandler)(NSUInteger selectedIndex);

@interface MZFlightPickerView : MZNibView

@property (nonatomic, strong) NSArray<UIImage *> *pickableData;

+ (MZFlightPickerView *)displayFlightPickerInView:(UIView *)containerView
																startingFromPoint:(CGPoint)topCenterPoint
																				 withData:(NSArray<UIImage *> *)data
																		 fadeDuration:(NSTimeInterval)duration
																 pickAtIndexBlock:(MZFlightPickerCompletionHandler)completionHandler;

- (void)dismissWithDuration:(NSTimeInterval)duration;

@end
