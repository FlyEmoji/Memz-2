//
//  MZDataManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZDataManager.h"
#import "NSManagedObject+MemzCoreData.h"

@interface MZDataManager ()

@property (nonatomic, strong, readwrite) DATAStack *dataStack;

@end

@implementation MZDataManager

+ (instancetype)sharedDataManager {
	static MZDataManager *manager;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		manager = [[MZDataManager alloc] init];
	});
	return manager;
}

- (instancetype)init {
	if (self = [super init]) {
		_dataStack = [[DATAStack alloc] initWithModelName:@"Memz"];

		[[NSNotificationCenter defaultCenter] addObserver:(id)[self class]
																						 selector:@selector(objectContextWillSave:)
																								 name:NSManagedObjectContextWillSaveNotification
																							 object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Calculated Properties

- (NSManagedObjectContext *)managedObjectContext {
	return self.dataStack.mainContext;
}

#pragma mark - Public Methods

- (void)saveChangesWithCompletionHandler:(void (^ __nullable)(void))completionHandler {
	[self.dataStack persistWithCompletion:completionHandler];
}

- (void)rollBackChanges {
}

#pragma mark - Private Methods

+ (void)objectContextWillSave:(NSNotification *)notification {
	NSManagedObjectContext *context = [notification object];
	NSSet *allModified = [context.insertedObjects setByAddingObjectsFromSet:context.updatedObjects];
	for (NSManagedObject *object in allModified) {
		if (object.hasBeenDeleted) {
			[context deleteObject:object];
		}
	}
}

@end
