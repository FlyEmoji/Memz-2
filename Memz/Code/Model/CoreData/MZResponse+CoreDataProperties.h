//
//  MZResponse+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZResponse.h"
#import "MZQuizz.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZResponse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *result;
@property (nullable, nonatomic, retain) MZWord *word;
@property (nullable, nonatomic, retain) MZQuizz *quiz;

@end

NS_ASSUME_NONNULL_END
