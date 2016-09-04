//
//  MZErrorCreator.h
//  Memz
//
//  Created by Bastien Falcou on 12/22/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MZErrorType) {
	MZErrorTypeUnknown = 0,
	MZErrorTypeAPIParseResponse,
	MZErrorTypeNoWordToTranslate
};

@interface MZErrorCreator : NSObject

+ (NSError *)errorWithType:(MZErrorType)type;

@end
