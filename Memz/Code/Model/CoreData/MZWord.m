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

+ (NSOrderedSet<MZWord *> *)existingWordsForLanguage:(MZLanguage)language startingByString:(NSString *)string {
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"(word BEGINSWITH %@) AND language == %d", string, language];
	return [NSOrderedSet orderedSetWithArray:[MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate]];
}

+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage {
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"word == %@ AND language == %d", word, fromLanguage];
	MZWord *existingWord = [MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate].firstObject;

	if (!existingWord) {
		return [[MZWord alloc] initWithWord:word fromLanguage:fromLanguage translations:translations toLanguage:toLanguage];
	} else {
		[existingWord updateTranslations:translations toLanguage:toLanguage];
		return existingWord;
	}
}

- (void)updateTranslations:(NSArray<NSString *> *)translations
								toLanguage:(MZLanguage)toLanguage {
	// (1) Add new translations
	[translations enumerateObjectsUsingBlock:^(NSString *translation, NSUInteger idx, BOOL *stop) {
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word == %@ AND language == %d", translation, toLanguage];
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

@end
