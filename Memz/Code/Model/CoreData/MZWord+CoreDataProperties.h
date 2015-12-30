//
//  MZWord+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZWord.h"
#import "MZResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *language;
@property (nullable, nonatomic, retain) NSString *word;
@property (nullable, nonatomic, retain) NSNumber *learningIndex;
@property (nullable, nonatomic, retain) NSSet<MZWord *> *translation;
@property (nullable, nonatomic, retain) NSSet<MZResponse *> *responses;

@end

@interface MZWord (CoreDataGeneratedAccessors)

- (void)addTranslationObject:(MZWord *)value;
- (void)removeTranslationObject:(MZWord *)value;
- (void)addTranslation:(NSSet<MZWord *> *)values;
- (void)removeTranslation:(NSSet<MZWord *> *)values;

- (void)addResponsesObject:(MZResponse *)value;
- (void)removeResponsesObject:(MZResponse *)value;
- (void)addResponses:(NSSet<MZResponse *> *)values;
- (void)removeResponses:(NSSet<MZResponse *> *)values;

@end

NS_ASSUME_NONNULL_END
