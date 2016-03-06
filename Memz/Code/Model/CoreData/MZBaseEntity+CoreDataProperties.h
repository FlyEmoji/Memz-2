//
//  MZBaseEntity+CoreDataProperties.h
//  
//
//  Created by Bastien Falcou on 3/6/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MZBaseEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface MZBaseEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) id remoteID;

@end

NS_ASSUME_NONNULL_END
