//
//  MZNibView.h
//  Memz
//
//  Created by Bastien Falcou on 12/16/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Subclass this class to use
 *  @note
 *  Instructions:
 *  - Subclass this class
 *  - Associate it with a nib via File's Owner (Whose name is defined by [-cellNibName])
 *  - Bind cellContentView to the root view of the nib
 *  - Then you can insert it either in code or in a xib/storyboard, your choice
 */
@interface MZNibView : UIView

@property (strong, nonatomic, readonly) IBOutlet UIView *contentView;

/**
 *  Common initializer method for the subclass. Should not be called directly.
 */
- (void)doInit;

/**
 *  Is called when the nib name associated with the class is going to be loaded.
 *
 *  @return The nib name (Default implementation returns class name)
 */
- (NSString *)nibName;

@end
