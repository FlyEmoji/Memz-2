//
//  MZApplicationSessionManager.h
//  Memz
//
//  Created by Bastien Falcou on 5/19/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const MZApplicationSessionDidOpenNotification;  // application launches or becomes active
extern NSString * const MZApplicationSessionDidCloseNotification;  // application moves to background or closes

@interface MZApplicationSessionManager : NSObject

@property (nonatomic, weak, readonly) NSDate *lastOpenedDate;  // last time MZApplicationSessionDidOpenNotification triggered
@property (nonatomic, weak, readonly) NSDate *lastClosedDate;  // last time MZApplicationSessionDidCloseNotification triggered

+ (MZApplicationSessionManager *)sharedManager;

@end
