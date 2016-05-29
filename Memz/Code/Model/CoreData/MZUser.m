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
#import "MZDataManager.h"
#import "NSManagedObject+MemzCoreData.h"

NSString * const MZUserDidAuthenticateNotification = @"MZUserDidAuthenticateNotification";

@implementation MZUser

+ (MZUser *)currentUser {
	NSArray *users = [MZUser allObjects];
	NSAssert(users.count <= 1, @"there can't be several current users at the same time");
	if (users.count == 0) {
		return nil;
	}
	return users.firstObject;
}

+ (MZUser *)signUpUserKnownLanguage:(MZLanguage)knownLanguage
												newLanguage:(MZLanguage)newLanguage {
	MZUser *user = [MZUser newInstance];
	user.knownLanguage = @(knownLanguage);
	user.newLanguage = @(newLanguage);

	[[NSNotificationCenter defaultCenter] postNotificationName:MZUserDidAuthenticateNotification object:user];
	return user;
}

- (MZWord *)addWord:(NSString *)word translations:(NSArray<NSString *> *)translations inContext:(NSManagedObjectContext *)context {
	return [MZWord addWord:word
							inLanguage:self.newLanguage.integerValue
						translations:translations
							toLanguage:self.knownLanguage.integerValue
								 forUser:self
							 inContext:context];
}

- (void)addPendingQuizzesForCreationDates:(NSArray<NSDate *> *)quizzesDates {
	[quizzesDates enumerateObjectsUsingBlock:^(NSDate *creationDate, NSUInteger idx, BOOL *stop) {
		MZQuiz *quiz = [MZQuiz randomQuizForUser:self creationDate:creationDate];
		if (quiz) {
			[self addQuizzesObject:quiz];
		}
	}];
	[[MZDataManager sharedDataManager] saveChangesWithCompletionHandler:nil];
}

#pragma mark - Custom Actions

- (void)addTranslations:(NSSet<MZWord *> *)values {
	for (MZWord *translation in values) {
		[self addTranslationsObject:translation];
	}
}

- (void)addTranslationsObject:(MZWord *)value {
	if (![self.translations containsObject:value]) {
		NSMutableSet<MZWord *> *mutableSet = self.translations.mutableCopy;
		[mutableSet addObject:value];
		self.translations = mutableSet;
	}

	for (MZWord *translation in value.translations) {
		if (![self.translations containsObject:translation]) {
			[translation addUsersObject:self];
			[self addTranslationsObject:translation];
		}
	}
}

- (void)removeTranslations:(NSSet<MZWord *> *)values {
	for (MZWord *translation in values) {
		[self removeTranslationsObject:translation];
	}
}

- (void)removeTranslationsObject:(MZWord *)value {
	NSMutableSet<MZWord *> *mutableSet = self.translations.mutableCopy;
	[mutableSet removeObject:value];
	self.translations = mutableSet;

	for (MZWord *translation in value.translations) {
		if ([self.translations containsObject:translation] && translation.translations.count < 2) {
			[translation removeUsersObject:self];
			[self removeTranslationsObject:translation];
		}
	}
}

@end
