//
//  MZWord.m
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//

#import "MZWord.h"
#import "NSManagedObject+MemzCoreData.h"

@implementation MZWord

#pragma mark - Private Initializer

- (instancetype)initWithWord:(NSString *)word
								fromLanguage:(MZLanguage)fromLanguage
								translations:(NSArray<NSString *> *)translations
									toLanguage:(MZLanguage)toLanguage {
	MZWord *newWord = [MZWord newInstance];
	newWord.word = word;
	newWord.language = @(fromLanguage);
	[newWord addTranslations:translations toLanguage:toLanguage];
	return newWord;
}

#pragma mark - Public Methods

+ (MZWord *)addWord:(NSString *)word
			 fromLanguage:(MZLanguage)fromLanguage
			 translations:(NSArray<NSString *> *)translations
				 toLanguage:(MZLanguage)toLanguage {
	NSPredicate *alreadyExistsPrecidate = [NSPredicate predicateWithFormat:@"word == %@ AND language == %d", word, fromLanguage];
	MZWord *existingWord = [MZWord allObjectsMatchingPredicate:alreadyExistsPrecidate].firstObject;

	if (!existingWord) {
		return [[MZWord alloc] initWithWord:word fromLanguage:fromLanguage translations:translations toLanguage:toLanguage];
	} else {
		[existingWord addTranslations:translations toLanguage:toLanguage];
		return existingWord;
	}
}

#pragma mark - Private Methods

- (void)addTranslations:(NSArray<NSString *> *)translations
						 toLanguage:(MZLanguage)toLanguage {
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
}

@end
