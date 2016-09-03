//
//  MZWord+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 5/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZWord.h"

#import "MZResponse.h"
#import "MZArticle.h"
#import "MZUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *language;
@property (nullable, nonatomic, retain) NSNumber *learningIndex;
@property (nullable, nonatomic, retain) NSString *word;
@property (nullable, nonatomic, retain) NSSet<MZResponse *> *responses;
@property (nullable, nonatomic, retain) NSSet<MZArticle *> *suggestionArticles;
@property (nullable, nonatomic, retain) NSSet<MZWord *> *translations;
@property (nullable, nonatomic, retain) NSSet<MZUser *> *users;

@end

@interface MZWord (CoreDataGeneratedAccessors)

- (void)addResponsesObject:(MZResponse *)value;
- (void)removeResponsesObject:(MZResponse *)value;
- (void)addResponses:(NSSet<MZResponse *> *)values;
- (void)removeResponses:(NSSet<MZResponse *> *)values;

- (void)addSuggestionArticlesObject:(MZArticle *)value;
- (void)removeSuggestionArticlesObject:(MZArticle *)value;
- (void)addSuggestionArticles:(NSSet<MZArticle *> *)values;
- (void)removeSuggestionArticles:(NSSet<MZArticle *> *)values;

- (void)addTranslationsObject:(MZWord *)value;
- (void)removeTranslationsObject:(MZWord *)value;
- (void)addTranslations:(NSSet<MZWord *> *)values;
- (void)removeTranslations:(NSSet<MZWord *> *)values;

- (void)addUsersObject:(MZUser *)value;
- (void)removeUsersObject:(MZUser *)value;
- (void)addUsers:(NSSet<MZUser *> *)values;
- (void)removeUsers:(NSSet<MZUser *> *)values;

@end

NS_ASSUME_NONNULL_END
