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
#import "MZLanguageDefinition.h"

@implementation MZQuiz

+ (MZQuiz *)randomQuizForUser:(MZUser *)user {
	if (!user) {
		return nil;
	}
	return [MZQuiz randomQuizFromLanguage:user.fromLanguage.integerValue
														 toLanguage:user.toLanguage.integerValue
																forUser:user];
}

+ (MZQuiz *)randomQuizFromLanguage:(MZLanguage)fromLanguage toLanguage:(MZLanguage)toLanguage forUser:(nullable MZUser *)user {
	MZQuiz *newQuiz = [MZQuiz newInstance];
	newQuiz.toLanguage = @(toLanguage);
	newQuiz.creationDate = [NSDate date];
	newQuiz.user = user;

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language = %d AND learningIndex < %d", toLanguage, MZWordIndexLearned];
	if (user) {
	predicate = [NSPredicate predicateWithFormat:@"language = %d AND learningIndex < %d AND %@ in users", toLanguage, MZWordIndexLearned, user.objectID];
	}

	NSMutableArray<MZWord *> *words = [MZWord allObjectsMatchingPredicate:predicate].mutableCopy;
	NSMutableArray<MZWord *> *selectedWords = [[NSMutableArray alloc] init];

	for (NSUInteger i = 0; i < MZQuizNumberTranslations && words.count > 0; i++) {
		MZWord *randomWord = [words objectAtIndex:arc4random() % words.count];
		[selectedWords addObject:randomWord];
		[words removeObject:randomWord];
	}

	for (MZWord *selectedWord in selectedWords) {
		MZResponse *response = [MZResponse newInstance];
		response.word = selectedWord;
		response.quiz = newQuiz;
		response.result = @(MZResponseResultUnanswered);
		[newQuiz addResponsesObject:response];
	}

	return newQuiz.responses.count > 0 ? newQuiz : nil;
}

+ (NSArray<NSNumber *> *)allLanguages {
	return @[@(MZLanguageEnglish),
					 @(MZLanguageFrench),
					 @(MZLanguageSpanish),
					 @(MZLanguageItalian),
					 @(MZLanguagePortuguese)];
}

- (MZLanguage)fromLanguage {
	return self.responses.allObjects.firstObject.word.language.integerValue;
}

@end
