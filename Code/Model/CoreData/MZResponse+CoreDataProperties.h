//
//  MZResponse+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 3/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZResponse.h"
#import "MZQuiz.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZResponse (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *result;
@property (nullable, nonatomic, retain) MZQuiz *quiz;
@property (nullable, nonatomic, retain) MZWord *word;

@end

NS_ASSUME_NONNULL_END
