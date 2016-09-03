//
//  MZBingTranslatorToken.h
//  Memz
//
//  Created by Bastien Falcou on 12/22/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MZBingTranslatorToken : NSObject

@property (nonatomic, strong, readonly) NSString *token;
@property (nonatomic, strong, readonly) NSDate *expiry;
@property (nonatomic, assign, readonly) BOOL isValid;

- (id)initWithToken:(NSString *)token expiry:(NSDate *)expiry;

@end
