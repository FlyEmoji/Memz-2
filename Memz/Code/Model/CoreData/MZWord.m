//
//  MZWord.m
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//

#import "MZWord.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZDataManager.h"

@implementation MZWord

#pragma mark - Private Initializer

- (instancetype)initWithWord:(NSString *)word
								fromLanguage:(MZLanguage)fromLanguage
								translations:(NSArray<NSString *> *)translations
									toLanguage:(MZLanguage)toLanguage
										 forUser:(MZUser *)user
									 inContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	MZWord *newWord = [MZWord newInstanceInContext:context];
	newWord.word = word;
	newWord.language = @(fromLanguage);
	if (user) {
		[newWord addUsersObject:user];
	}
	[newWord updateTranslations:translations toLanguage:toLanguage forUser:user inContext:context];
	return newWord;
}

#pragma mark - Public Methods

+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage
						forUser:(MZUser *)user
					inContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	MZWord *existingWord = [MZWord existingWordForString:word fromLanguage:fromLanguage inContext:context];

	if (!existingWord) {
		return [[MZWord alloc] initWithWord:word fromLanguage:fromLanguage translations:translations toLanguage:toLanguage forUser:user inContext:context];
	} else {
		[existingWord updateTranslations:translations toLanguage:toLanguage forUser:user inContext:context];
		return existingWord;
	}
}

+ (NSOrderedSet<MZWord *> *)existingWordsForLanguage:(MZLanguage)language
																		startingByString:(NSString *)string
																					 inContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"(word BEGINSWITH[cd] %@) AND language = %d", string, language];
	return [NSOrderedSet orderedSetWithArray:[MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate]];
}

+ (MZWord *)existingWordForString:(NSString *)string
										 fromLanguage:(MZLanguage)fromLanguage
												inContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;
	
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND language = %d", string, fromLanguage];
	return [MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate context:context].firstObject;
}

- (void)updateTranslations:(NSArray<NSString *> *)translations
								toLanguage:(MZLanguage)toLanguage
									 forUser:(MZUser *)user
								 inContext:(NSManagedObjectContext *)context {
	// (1) Initialize context if not specified
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	// (2) Add new translations
	[translations enumerateObjectsUsingBlock:^(NSString *translation, NSUInteger idx, BOOL *stop) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND language = %d", translation, toLanguage];
		MZWord *wordTranslation = [MZWord allObjectsMatchingPredicate:predicate context:context].firstObject;

		if (!wordTranslation) {
			wordTranslation = [MZWord newInstanceInContext:context];
			wordTranslation.word = translation;
			wordTranslation.language = @(toLanguage);
		}

		[self addTranslationsObject:wordTranslation];
	}];

	// (3) Remove no longer needed translations
	[self.translations.mutableCopy enumerateObjectsUsingBlock:^(MZWord *translation, NSUInteger idx, BOOL *stop) {
		if (![translations containsObject:translation.word]) {
			[self removeTranslations:[NSSet setWithObject:translation]];

			if (translation.translations.count == 0) {
				[context deleteObject:translation];
			}
		}
	}];

	// (4) Set translation and reverse relationship user if exists
	if (user && ![user.translations containsObject:self]) {
		[user addTranslationsObject:self];
	}

	// (5) Remove word if no translations anymore
	// TODO: Finish this part
	/*if (self.translations.count == 0) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@", self.objectID];
		[MZWord deleteAllObjectsMatchingPredicate:predicate context:context];
	}*/
}

#pragma mark - Statistics

- (NSUInteger)numberTranslationsToLanguage:(MZLanguage)toLanguage {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, toLanguage];
	return [MZResponse countOfObjectsMatchingPredicate:predicate];
}

- (CGFloat)percentageSuccessTranslationsToLanguage:(MZLanguage)toLanguage {
	NSPredicate *successCountPredicate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND result = true AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, toLanguage];
	NSPredicate *allObjectsCountPredicate = [NSPredicate predicateWithFormat:@"word CONTAINS[cd] %@ AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, toLanguage];

	NSUInteger successCount = [MZResponse countOfObjectsMatchingPredicate:successCountPredicate];
	NSUInteger allObjectsCount = [MZResponse countOfObjectsMatchingPredicate:allObjectsCountPredicate];

	return allObjectsCount > 0 ? successCount * 100.0f / allObjectsCount : 0.0f;
}

@end
