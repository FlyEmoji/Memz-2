//
//  MZUser+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 5/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *knownLanguage;
@property (nullable, nonatomic, retain) NSNumber *newLanguage;
@property (nullable, nonatomic, retain) NSSet<MZWord *> *translations;
@property (nullable, nonatomic, retain) NSSet<MZQuiz *> *quizzes;

@end

@interface MZUser (CoreDataGeneratedAccessors)

- (void)addTranslationsObject:(MZWord *)value;
- (void)removeTranslationsObject:(MZWord *)value;
- (void)addTranslations:(NSSet<MZWord *> *)values;
- (void)removeTranslations:(NSSet<MZWord *> *)values;

- (void)addQuizzesObject:(MZQuiz *)value;
- (void)removeQuizzesObject:(MZQuiz *)value;
- (void)addQuizzes:(NSSet<MZQuiz *> *)values;
- (void)removeQuizzes:(NSSet<MZQuiz *> *)values;

@end

NS_ASSUME_NONNULL_END
