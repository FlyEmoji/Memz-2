//
//  MZQuiz+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 3/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZQuiz.h"

NS_ASSUME_NONNULL_BEGIN

@class MZResponse;

@interface MZQuiz (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *answerDate;
@property (nullable, nonatomic, retain) NSNumber *isAnswered;
@property (nullable, nonatomic, retain) NSNumber *toLanguage;
@property (nullable, nonatomic, retain) NSDate *creationDate;
@property (nullable, nonatomic, retain) NSSet<MZResponse *> *responses;

@end

@interface MZQuiz (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(MZResponse *)value;
- (void)removeResponsesObject:(MZResponse *)value;
- (void)addResponses:(NSSet<MZResponse *> *)values;
- (void)removeResponses:(NSSet<MZResponse *> *)values;

@end

NS_ASSUME_NONNULL_END
