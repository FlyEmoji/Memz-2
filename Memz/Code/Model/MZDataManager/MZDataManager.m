//
//  MZDataManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZDataManager.h"
#import "MZArticle.h"
#import "NSManagedObject+MemzCoreData.h"

@interface MZDataManager ()

@property (nonatomic, strong, readwrite) DATAStack *dataStack;
@property (nonatomic, strong) NSMutableSet<MZDataBackgroundTaskWrapper *> *dataBackgroundTasks;

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

		self.dataBackgroundTasks = [[NSMutableSet alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(objectContextDidSave:)
																								 name:NSManagedObjectContextDidSaveNotification
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

- (void)saveChangesWithCompletionHandler:(void(^)(void))completionHandler {
	[self.dataStack persistWithCompletion:completionHandler];
}

- (void)saveChangesInBackground:(NSManagedObjectContext *)backgroundContext
							completionHandler:(MZDataTaskCompletionBlock)completionHandler {
	// (1) Keep track of background context and its completion handler
	MZDataBackgroundTaskWrapper *backgroundTask = [MZDataBackgroundTaskWrapper dataBackgroundTaskWithContext:backgroundContext
																																													 completionBlock:completionHandler];
	[self.dataBackgroundTasks addObject:backgroundTask];

	// (2) Perform save
	NSError *error;
	[backgroundContext save:&error];

	if (error) {
		[self.dataBackgroundTasks removeObject:backgroundTask];
		if (completionHandler) {
			completionHandler(error);		// TODO: Should send back error if needed
		}
	}
}

- (void)rollBackChanges {
	[self.managedObjectContext undo];
}

#pragma mark - Private Methods

- (void)objectContextDidSave:(NSNotification *)notification {
	// (1) Manage object contexts need to be merged on main thread only
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(objectContextDidSave:) withObject:notification waitUntilDone:YES];
		return;
	}

	// (2) Get back completion handler using background context
	NSManagedObjectContext *context = notification.object;
	MZDataBackgroundTaskWrapper *dataBackgroundTask = [self dataBackgroundTaskForContext:context];

	// (3) Exit if not saving background context
	if (![self.dataBackgroundTasks containsObject:dataBackgroundTask]) {
		return;
	}

	// (3) Merge main and background contexts
	[self.managedObjectContext mergeChangesFromContextDidSaveNotification:notification];

	// (4) Callback application waiting for completion signal
	if (dataBackgroundTask.completionBlock) {
		dataBackgroundTask.completionBlock(nil);
	}
	[self.dataBackgroundTasks removeObject:dataBackgroundTask];
}

- (MZDataBackgroundTaskWrapper *)dataBackgroundTaskForContext:(NSManagedObjectContext *)context {
	for (MZDataBackgroundTaskWrapper *dataBackgroundTask in self.dataBackgroundTasks.allObjects) {
		if (dataBackgroundTask.context == context) {
			return dataBackgroundTask;
		}
	}
	return nil;
}

@end
