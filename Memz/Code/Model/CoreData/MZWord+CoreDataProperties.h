//
//  MZWord+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 12/19/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZWord.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZWord (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *word;
@property (nullable, nonatomic, retain) NSNumber *language;
@property (nullable, nonatomic, retain) MZWord *translation;

@end

NS_ASSUME_NONNULL_END
