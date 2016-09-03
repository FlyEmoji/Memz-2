//
//  Response+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 12/27/15.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Response.h"

NS_ASSUME_NONNULL_BEGIN

@interface Response (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *result;
@property (nullable, nonatomic, retain) MZWord *word;
@property (nullable, nonatomic, retain) Response *quiz;

@end

NS_ASSUME_NONNULL_END
