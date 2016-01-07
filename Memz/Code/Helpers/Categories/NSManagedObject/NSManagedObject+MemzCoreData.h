//
//  NSManagedObject+MemzCoreData.h
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (MemzCoreData)

@property (nonatomic, assign, readonly) BOOL hasBeenDeleted;

+ (instancetype)newInstance;
+ (instancetype)newInstanceInContext:(NSManagedObjectContext *)context;

+ (NSString *)entityName;

+ (NSEntityDescription *)entityDescription;
+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countOfAllObjects;
+ (NSUInteger)countOfAllObjectsInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allObjects;
+ (NSArray *)allObjectsInContext:(NSManagedObjectContext *)context;
+ (void)deleteAllObjects;
+ (void)deleteAllObjectsInContext:(NSManagedObjectContext *)context;

+ (NSUInteger)countOfObjectsMatchingPredicate:(NSPredicate *)predicate;
+ (NSUInteger)countOfObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate;
+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors;
+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

+ (NSArray *)objectsMatchingPredicate:(NSPredicate *)predicate offset:(NSInteger)offset limit:(NSInteger)limit sortDescriptors:(NSArray *)sortDescriptors returnAsFaults:(BOOL)returnAsFaults;
+ (NSArray *)objectsMatchingPredicate:(NSPredicate *)predicate offset:(NSInteger)offset limit:(NSInteger)limit sortDescriptors:(NSArray *)sortDescriptors returnAsFaults:(BOOL)returnAsFaults context:(NSManagedObjectContext *)context;

+ (void)deleteAllObjectsMatchingPredicate:(NSPredicate *)predicate;
+ (void)deleteAllObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context;

@end
