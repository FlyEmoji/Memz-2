//
//  MZResponse.m
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import "MZResponse.h"
#import "MZWord.h"

@implementation MZResponse

- (MZResponseResult)checkTranslations:(NSArray<NSString *> *)translations delegate:(id<MZResponseComparatorDelegate>)delegate {
	MZResponseComparator *responseComparator = [MZResponseComparator responseComparatorWithResponse:self];
	responseComparator.delegate = delegate;
	return [responseComparator checkTranslations:translations];
}

@end
