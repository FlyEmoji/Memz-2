//
//  MZDataManager.m
//  Memz
//
//  Created by Bastien Falcou on 12/18/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <DATAStack/DATAStack.h>
#import "MZDataManager.h"

@interface MZDataManager ()

@property (nonatomic, strong) DATAStack *dataStack;

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

@end
