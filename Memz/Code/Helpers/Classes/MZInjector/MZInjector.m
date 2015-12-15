//
//  MZInjector.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZInjector.h"

@interface MZInjector ()

@property (nonatomic, strong) NSMutableDictionary * protocolBuilderBlocks;
@property (nonatomic, strong) NSMutableDictionary * classBuilderBlocks;

@end

@implementation MZInjector

- (id)init {
	self = [super init];
	if(self != nil) {
		self.protocolBuilderBlocks = [[NSMutableDictionary alloc] init];
		self.classBuilderBlocks = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)bindClass:(Class)classToInstanciate toProtocol:(Protocol *)protocolType {
	NSLog(@"Binding class %@ to protocol %@", NSStringFromClass(classToInstanciate), NSStringFromProtocol(protocolType));
	[self bindBlock:classToInstanciate != nil ? ^id{
		return [[classToInstanciate alloc] init];
	} : nil toProtocol:protocolType];
}

- (void)bindClass:(Class)classToInstanciate toClass:(Class)classType {
	NSLog(@"Binding class %@ to class %@", NSStringFromClass(classToInstanciate), NSStringFromClass(classType));
	[self bindBlock:classToInstanciate != nil ? ^id{
		return [[classToInstanciate alloc] init];
	} : nil toClass:classType];
}

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocolType {
	NSLog(@"Binding instance %@ to protocol %@", instance, NSStringFromProtocol(protocolType));
	[self bindBlock:instance != nil ? ^id{
		return instance;
	} : nil toProtocol:protocolType];
}

- (void)bindInstance:(id)instance toClass:(Class)classType {
	NSLog(@"Binding instance %@ to class %@", instance, NSStringFromClass(classType));
	[self bindBlock:instance != nil ? ^id{
		return instance;
	} : nil toClass:classType];
}

- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType {
	NSLog(@"Binding block to protocol %@", NSStringFromProtocol(protocolType));
	NSLog(@"Current protocol builders: %@", [self.protocolBuilderBlocks allKeys]);
	if (builderBlock == nil) {
		NSLog(@"Removing builder block from protocolBuilderBlocks");
		[self.protocolBuilderBlocks removeObjectForKey:NSStringFromProtocol(protocolType)];
	} else {
		NSLog(@"Adding builder block to protocolBuilderBlocks");
		self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)] = [builderBlock copy];
	}
}

- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toClass:(Class)classType {
	NSLog(@"Binding block to class %@", NSStringFromClass(classType));
	NSLog(@"Current class builders: %@", [self.classBuilderBlocks allKeys]);
	if (builderBlock == nil) {
		NSLog(@"Removing builder block from classBuilderBlocks");
		[self.classBuilderBlocks removeObjectForKey:NSStringFromClass(classType)];
	} else {
		NSLog(@"Adding builder block to classBuilderBlocks");
		self.classBuilderBlocks[NSStringFromClass(classType)] = [builderBlock copy];
	}
}

#define _ETHLogInstanceProtocol(flag, formatString, ...) \
do { \
if(((@protocol(ETHLogger) == protocolType && once) || @protocol(ETHLogger) != protocolType) && ([ETHFramework ethanolLogLevel] & (flag)) == (flag)) { \
[((ETHInjectorBuilderBlock)(self.protocolBuilderBlocks[ETH_PROTOCOL_TO_NSSTRING(ETHLogger)]) ?: ^id{ return nil; })() log:(flag) file:[NSString stringWithUTF8String:__FILE__] function:NSStringFromSelector(_cmd) line:__LINE__ format:(formatString), ## __VA_ARGS__]; \
if(@protocol(ETHLogger) == protocolType && ([ETHFramework ethanolLogLevel] & (ETHLogFlagWarning)) == (ETHLogFlagWarning) && !didWarn) { \
[((ETHInjectorBuilderBlock)(self.protocolBuilderBlocks[ETH_PROTOCOL_TO_NSSTRING(ETHLogger)]) ?: ^id{ return nil; })() log:ETHLogFlagWarning file:[NSString stringWithUTF8String:__FILE__] function:NSStringFromSelector(_cmd) line:__LINE__ format:@"The logs related to ETHLogger in the injector will only be displayed once (This warning only shows when the level ETHLogLevelTrace or higher is set)"]; \
didWarn = YES; \
} \
} \
} while(0)
#define ETHLogTraceInstanceProtocol(formatString, ...) _ETHLogInstanceProtocol(ETHLogFlagTrace, formatString, ## __VA_ARGS__)

- (id)instanceForProtocol:(Protocol *)protocolType {
#ifdef ETHANOL_ENABLE_INTERNAL_LOGGING
	static BOOL once = YES;
	static BOOL didWarn = NO;
	NSLog(@"Calling instanceForProtocol: with protocolType: %@", NSStringFromProtocol(protocolType));
#endif
	MZInjectorBuilderBlock builderBlock = self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)];
	if(builderBlock != nil) {
#ifdef ETHANOL_ENABLE_INTERNAL_LOGGING
		NSLog(@"Found builder block for protocol %@", NSStringFromProtocol(protocolType));
		once = NO;
#endif
		return builderBlock();
	}

#ifdef ETHANOL_ENABLE_INTERNAL_LOGGING
	NSLog(@"Builder block for protocol %@. Creating instance via default constructor.", NSStringFromProtocol(protocolType));
	once = NO;
#endif
	return nil;
}

- (id)instanceForClass:(Class)classType {
	NSLog(@"Calling instanceForClass: with classType: %@", NSStringFromClass(classType));
	MZInjectorBuilderBlock builderBlock = self.classBuilderBlocks[NSStringFromClass(classType)];
	if(builderBlock != nil) {
		NSLog(@"Found builder block for class %@", NSStringFromClass(classType));
		return builderBlock() ?: ({ NSLog(@"Builder block for class %@ returned nil. Creating instance via default constructor.", NSStringFromClass(classType)); [[classType alloc] init]; });
	}

	NSLog(@"Builder block for class %@ is nil. Creating instance via default constructor.", NSStringFromClass(classType));
	return [[classType alloc] init];
}

@end
