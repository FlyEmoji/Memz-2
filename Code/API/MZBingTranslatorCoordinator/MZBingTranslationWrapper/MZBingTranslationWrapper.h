//
//  MZBingTranslationWrapper.h
//  Memz
//
//  Created by Bastien Falcou on 12/21/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ MZBingTranslationCompletionHandler)(NSArray<NSString *> *translations, NSError *error);

@interface MZBingTranslationWrapper : NSObject

@property (nonatomic, strong) NSURLSessionDataTask *dataTask;

@property (nonatomic, copy) MZBingTranslationCompletionHandler translationCompletionHandler;

@property (nonatomic, strong) NSXMLParser *parser;
@property (nonatomic, strong) NSString *XMLElement;
@property (nonatomic, strong) NSMutableString *XMLTranslation;

- (instancetype)initWithDataTask:(NSURLSessionDataTask *)task
							 completionHandler:(MZBingTranslationCompletionHandler)completionHandler;

+ (instancetype)translationWrapperWithDataTask:(NSURLSessionDataTask *)task
														 completionHandler:(MZBingTranslationCompletionHandler)completionHandler;

@end
