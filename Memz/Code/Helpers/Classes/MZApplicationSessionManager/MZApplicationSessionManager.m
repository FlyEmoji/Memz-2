//
//  MZApplicationSessionManager.m
//  Memz
//
//  Created by Bastien Falcou on 5/19/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import "MZApplicationSessionManager.h"

NSString * const MZApplicationSessionDidOpenNotification = @"MZApplicationSessionDidOpenNotification";
NSString * const MZApplicationSessionDidCloseNotification = @"MZApplicationSessionDidCloseNotification";

NSString * const kLastOpenedDateStorageKey = @"MZLastOpenedDateStorageKey";
NSString * const kLastClosedDateStorageKey = @"MZLastClosedDateStorageKey";

@interface MZApplicationSessionManager ()

@property (nonatomic, weak, readwrite) NSDate *lastOpenedDate;
@property (nonatomic, weak, readwrite) NSDate *lastClosedDate;

@end

@implementation MZApplicationSessionManager

+ (MZApplicationSessionManager *)sharedManager {
	static MZApplicationSessionManager *_sharedManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedManager = [[self alloc] init];
	});
	return _sharedManager;
}

- (instancetype)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(didReceiveOpenNotification:)
																								 name:UIApplicationDidFinishLaunchingNotification
																							 object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(didReceiveOpenNotification:)
																								 name:UIApplicationDidBecomeActiveNotification
																							 object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(didReceiveCloseNotification:)
																								 name:UIApplicationWillResignActiveNotification
																							 object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
																						 selector:@selector(didReceiveCloseNotification:)
																								 name:UIApplicationWillTerminateNotification
																							 object:nil];
	}
	return self;
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveOpenNotification:(NSNotification *)notification {
	self.lastOpenedDate = [NSDate date];
	[[NSNotificationCenter defaultCenter] postNotificationName:MZApplicationSessionDidOpenNotification
																											object:self];
}

- (void)didReceiveCloseNotification:(NSNotification *)notification {
	self.lastOpenedDate = [NSDate date];
	[[NSNotificationCenter defaultCenter] postNotificationName:MZApplicationSessionDidCloseNotification
																											object:self];
}

#pragma mark - Custom Getters & Setters

- (void)setLastOpenedDate:(NSDate *)lastOpenedDate {
	[[NSUserDefaults standardUserDefaults] setObject:lastOpenedDate forKey:kLastOpenedDateStorageKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)lastOpenedDate {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kLastOpenedDateStorageKey];
}

- (void)setLastClosedDate:(NSDate *)lastClosedDate {
	[[NSUserDefaults standardUserDefaults] setObject:lastClosedDate forKey:kLastClosedDateStorageKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)lastClosedDate {
	return [[NSUserDefaults standardUserDefaults] objectForKey:kLastClosedDateStorageKey];
}

@end
