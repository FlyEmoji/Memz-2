//
//  MZArticle+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 3/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZArticle.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZArticle (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *additionDate;
@property (nullable, nonatomic, retain) NSString *body;
@property (nullable, nonatomic, retain) NSString *subTitle;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSURL *imageUrl;
@property (nullable, nonatomic, retain) NSSet<MZWord *> *suggestedWords;

@end

@interface MZArticle (CoreDataGeneratedAccessors)

- (void)addSuggestedWordsObject:(MZWord *)value;
- (void)removeSuggestedWordsObject:(MZWord *)value;
- (void)addSuggestedWords:(NSSet<MZWord *> *)values;
- (void)removeSuggestedWords:(NSSet<MZWord *> *)values;

@end

NS_ASSUME_NONNULL_END
