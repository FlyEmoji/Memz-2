//
//  NSManagedObject+MemzCoreData.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "NSManagedObject+MemzCoreData.h"
#import "MZDataManager.h"

@implementation NSManagedObject (MemzCoreData)

- (BOOL)hasBeenDeleted {
	NSManagedObjectContext *context;
	NSManagedObjectID *objectID;
	if (self.isDeleted || (context = self.managedObjectContext) == nil || (objectID = self.objectID) == nil) {
		return YES;
	}
	NSManagedObject *me = [context objectRegisteredForID:objectID];
	return me == nil;
}

+ (instancetype)newInstance {
	return [self newInstanceInContext:nil];
}

+ (instancetype)newInstanceInContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	NSManagedObject *object = [[NSManagedObject alloc] initWithEntity:[self entityDescriptionInContext:context]
																		 insertIntoManagedObjectContext:context];
	NSError *error;
	if (![context obtainPermanentIDsForObjects:@[object] error:&error]) {
		NSLog(@"Failed to obtain permanent ID for object: %@ (%@)", error, object);
	}
	return object;
}

+ (NSString *)entityName {
	return [NSStringFromClass([self class]) substringFromIndex:[MZCoreDataEntityPrefix length]];
}

+ (NSEntityDescription *)entityDescription {
	return [self entityDescriptionInContext:nil];
}

+ (NSEntityDescription *)entityDescriptionInContext:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	return [NSEntityDescription entityForName:[self entityName]
										 inManagedObjectContext:context];
}

+ (NSUInteger)countOfAllObjects {
	return [self countOfAllObjectsInContext:nil];
}

+ (NSUInteger)countOfAllObjectsInContext:(NSManagedObjectContext *)context {
	return [self countOfObjectsMatchingPredicate:nil context:context];
}

+ (NSArray *)allObjects {
	return [self allObjectsInContext:nil];
}

+ (NSArray *)allObjectsInContext:(NSManagedObjectContext *)context {
	return [self allObjectsMatchingPredicate:nil context:context];
}

+ (void)deleteAllObjects {
	[self deleteAllObjectsInContext:nil];
}

+ (void)deleteAllObjectsInContext:(NSManagedObjectContext *)context {
	[self deleteAllObjectsMatchingPredicate:nil context:context];
}

+ (NSUInteger)countOfObjectsMatchingPredicate:(NSPredicate *)predicate {
	return [self countOfObjectsMatchingPredicate:predicate context:nil];
}

+ (NSUInteger)countOfObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entityDescriptionInContext:context]];

	if (predicate != nil) {
		[request setPredicate:predicate];
	}

	NSError *error;
	NSUInteger count = [context countForFetchRequest:request error:&error];
	return count;
}

+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate {
	return [self allObjectsMatchingPredicate:predicate context:nil];
}

+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors {
	return [self objectsMatchingPredicate:predicate offset:0 limit:-1 sortDescriptors:sortDescriptors returnAsFaults:YES];
}

+ (NSArray *)allObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context {
	return [self objectsMatchingPredicate:predicate offset:0 limit:-1 sortDescriptors:nil returnAsFaults:YES context:context];
}

+ (NSArray *)objectsMatchingPredicate:(NSPredicate *)predicate offset:(NSInteger)offset limit:(NSInteger)limit sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors returnAsFaults:(BOOL)returnAsFaults {
	return [self objectsMatchingPredicate:predicate offset:offset limit:limit sortDescriptors:sortDescriptors returnAsFaults:returnAsFaults context:nil];
}

+ (NSArray *)objectsMatchingPredicate:(NSPredicate *)predicate offset:(NSInteger)offset limit:(NSInteger)limit sortDescriptors:(NSArray<NSSortDescriptor *> *)sortDescriptors returnAsFaults:(BOOL)returnAsFaults context:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:[self entityDescriptionInContext:context]];

	if (predicate != nil) {
		[request setPredicate:predicate];
	}

	[request setFetchOffset:offset];
	if (limit >= 0) {
		[request setFetchLimit:limit];
	}

	if (sortDescriptors != nil) {
		[request setSortDescriptors:sortDescriptors];
	}

	if (!returnAsFaults) {
		[request setReturnsObjectsAsFaults:returnAsFaults];
	}

	NSError *error;
	NSArray *objects = [context executeFetchRequest:request error:&error];
	return objects;
}

+ (void)deleteAllObjectsMatchingPredicate:(NSPredicate *)predicate {
	return [self deleteAllObjectsMatchingPredicate:predicate context:nil];
}

+ (void)deleteAllObjectsMatchingPredicate:(NSPredicate *)predicate context:(NSManagedObjectContext *)context {
	context = context ?: [MZDataManager sharedDataManager].managedObjectContext;

	for (NSManagedObject * object in [self allObjectsMatchingPredicate:predicate context:context]) {
		[context deleteObject:object];
	}
}

@end
