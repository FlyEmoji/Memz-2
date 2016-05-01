//
//  MZUser.m
//  
//
//  Created by Bastien Falcou on 5/1/16.
//
//

#import "MZUser.h"
#import "MZQuiz.h"
#import "MZWord.h"
#import "NSManagedObject+MemzCoreData.h"

@implementation MZUser

+ (MZUser *)currentUser {
	NSArray *users = [MZUser allObjects];
	NSAssert(users.count <= 1, @"there can't be several current users at the same time");
	if (users.count == 0) {
		return nil;
	}
	return users.firstObject;
}

@end
