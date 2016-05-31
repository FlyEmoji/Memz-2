//
//  MZQuiz.m
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import "MZQuiz.h"
#import "MZWord.h"
#import "NSManagedObject+MemzCoreData.h"

@implementation MZQuiz

+ (MZQuiz *)randomQuizForUser:(MZUser *)user creationDate:(nullable NSDate *)creationDate {
	if (!user) {
		return nil;
	}
	return [MZQuiz randomQuizKnownLanguage:user.knownLanguage.integerValue
														 newLanguage:user.newLanguage.integerValue
																 forUser:user
														creationDate:creationDate];
}

+ (MZQuiz *)randomQuizKnownLanguage:(MZLanguage)knownLanguage
												newLanguage:(MZLanguage)newLanguage
														forUser:(nullable MZUser *)user
											 creationDate:(nullable NSDate *)creationDate {
	// (1) Fetch all not yet learned words in targeted language
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %d AND learningIndex < %d", newLanguage, MZWordIndexLearned];
	if (user) {
	predicate = [NSPredicate predicateWithFormat:@"language = %d AND learningIndex < %d AND %@ in users", newLanguage, MZWordIndexLearned, user.objectID];
	}

	// (2) Pick words to translate randomly
	NSMutableArray<MZWord *> *words = [MZWord allObjectsMatchingPredicate:predicate].mutableCopy;
	NSMutableArray<MZWord *> *selectedWords = [[NSMutableArray alloc] init];

	for (NSUInteger i = 0; i < MZQuizNumberTranslations && words.count > 0; i++) {
		MZWord *randomWord = [words objectAtIndex:arc4random() % words.count];
		[selectedWords addObject:randomWord];
		[words removeObject:randomWord];
	}

	// (3) If no word to translate returns nil
	if (selectedWords.count < 1) {
		return nil;
	}

	// (4) Create new quiz and populate properties
	MZQuiz *newQuiz = [MZQuiz newInstance];
	newQuiz.knownLanguage = @(knownLanguage);
	newQuiz.newLanguage = @(newLanguage);
	newQuiz.creationDate = [NSDate date];
	newQuiz.user = user;

	// (5) Populate new quiz with randomly selected words to translate
	for (MZWord *selectedWord in selectedWords) {
		MZResponse *response = [MZResponse newInstance];
		response.word = selectedWord;
		response.quiz = newQuiz;
		response.result = @(MZResponseResultUnanswered);
		[newQuiz addResponsesObject:response];
	}

	return newQuiz;
}

+ (NSArray<NSNumber *> *)allLanguages {
	return @[@(MZLanguageEnglish),
					 @(MZLanguageFrench),
					 @(MZLanguageSpanish),
					 @(MZLanguageItalian),
					 @(MZLanguagePortuguese)];
}

@end
