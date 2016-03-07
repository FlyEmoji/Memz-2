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
									toLanguage:(MZLanguage)toLanguage {
	MZWord *newWord = [MZWord newInstance];
	newWord.word = word;
	newWord.language = @(fromLanguage);
	[newWord updateTranslations:translations toLanguage:toLanguage];
	return newWord;
}

#pragma mark - Public Methods

+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage {
	MZWord *existingWord = [MZWord existingWordForString:word fromLanguage:fromLanguage];

	if (!existingWord) {
		return [[MZWord alloc] initWithWord:word fromLanguage:fromLanguage translations:translations toLanguage:toLanguage];
	} else {
		[existingWord updateTranslations:translations toLanguage:toLanguage];
		return existingWord;
	}
}

+ (NSOrderedSet<MZWord *> *)existingWordsForLanguage:(MZLanguage)language startingByString:(NSString *)string {
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"(word BEGINSWITH %@) AND language = %d", string, language];
	return [NSOrderedSet orderedSetWithArray:[MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate]];
}

+ (MZWord *)existingWordForString:(NSString *)string fromLanguage:(MZLanguage)fromLanguage {
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"word = %@ AND language = %d", string, fromLanguage];
	return [MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate].firstObject;
}

- (void)updateTranslations:(NSArray<NSString *> *)translations
								toLanguage:(MZLanguage)toLanguage {
	// (1) Add new translations
	[translations enumerateObjectsUsingBlock:^(NSString *translation, NSUInteger idx, BOOL *stop) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@ AND language = %d", translation, toLanguage];
		MZWord *wordTranslation = [MZWord allObjectsMatchingPredicate:predicate].firstObject;

		if (!wordTranslation) {
			wordTranslation = [MZWord newInstance];
			wordTranslation.word = translation;
			wordTranslation.language = @(toLanguage);
		}

		[self addTranslationObject:wordTranslation];
	}];

	// (2) Remove no longer needed translations
	[self.translation.mutableCopy enumerateObjectsUsingBlock:^(MZWord *translation, NSUInteger idx, BOOL *stop) {
		if (![translations containsObject:translation.word]) {
			[self removeTranslation:[NSSet setWithObject:translation]];

			if (translation.translation.count == 0) {
				[[MZDataManager sharedDataManager].managedObjectContext deleteObject:translation];
			}
		}
	}];
}

#pragma mark - Statistics

- (NSUInteger)numberTranslationsToLanguage:(MZLanguage)toLanguage {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@ AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, [MZLanguageManager sharedManager].toLanguage];
	return [MZResponse countOfObjectsMatchingPredicate:predicate];
}

- (CGFloat)percentageSuccessTranslationsToLanguage:(MZLanguage)toLanguage {
	NSPredicate *successCountPredicate = [NSPredicate predicateWithFormat:@"word = %@ AND result = true AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, [MZLanguageManager sharedManager].toLanguage];
	NSPredicate *allObjectsCountPredicate = [NSPredicate predicateWithFormat:@"word = %@ AND quiz.toLanguage = %ld AND quiz.isAnswered = true", self, [MZLanguageManager sharedManager].toLanguage];

	NSUInteger successCount = [MZResponse countOfObjectsMatchingPredicate:successCountPredicate];
	NSUInteger allObjectsCount = [MZResponse countOfObjectsMatchingPredicate:allObjectsCountPredicate];

	return allObjectsCount > 0 ? successCount * 100.0f / allObjectsCount : 0.0f;
}

@end
