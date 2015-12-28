//
//  MZQuizz.m
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//

#import "MZQuizz.h"
#import "MZWord.h"
#import "NSManagedObject+MemzCoreData.h"
#import "MZLanguageManager.h"

@implementation MZQuizz

+ (MZQuizz *)generateRandomQuiz {
	MZQuizz *newQuiz = [MZQuizz newInstance];

	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"language == %d AND learningIndex < %d", [MZLanguageManager sharedManager].fromLanguage, MZWordIndexLearned];

	NSMutableArray<MZWord *> *words = [MZWord allObjectsMatchingPredicate:predicate].mutableCopy;
	NSMutableArray<MZWord *> *selectedWords = [[NSMutableArray alloc] init];

	for (NSUInteger i = 0; i < words.count && i < MZQuizNumberTranslations; i++) {
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

	return newQuiz;
}

@end
