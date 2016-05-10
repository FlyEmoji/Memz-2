//
//  MZInjector.m
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import "MZInjector.h"

@interface MZInjector ()

@property (nonatomic, strong) NSMutableDictionary *protocolBuilderBlocks;
@property (nonatomic, strong) NSMutableDictionary *classBuilderBlocks;

@end

@implementation MZInjector

- (id)init {
	if (self = [super init]) {
		self.protocolBuilderBlocks = [[NSMutableDictionary alloc] init];
		self.classBuilderBlocks = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)bindClass:(Class)classToInstanciate toProtocol:(Protocol *)protocolType {
	[self bindBlock:classToInstanciate != nil ? ^id{
		return [[classToInstanciate alloc] init];
	} : nil toProtocol:protocolType];
}

- (void)bindClass:(Class)classToInstanciate toClass:(Class)classType {
	[self bindBlock:classToInstanciate != nil ? ^id{
		return [[classToInstanciate alloc] init];
	} : nil toClass:classType];
}

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocolType {
	[self bindBlock:instance != nil ? ^id{
		return instance;
	} : nil toProtocol:protocolType];
}

- (void)bindInstance:(id)instance toClass:(Class)classType {
	[self bindBlock:instance != nil ? ^id{
		return instance;
	} : nil toClass:classType];
}

- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType {
	if (builderBlock == nil) {
		[self.protocolBuilderBlocks removeObjectForKey:NSStringFromProtocol(protocolType)];
	} else {
		self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)] = [builderBlock copy];
	}
}

- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toClass:(Class)classType {
	if (builderBlock == nil) {
		[self.classBuilderBlocks removeObjectForKey:NSStringFromClass(classType)];
	} else {
		self.classBuilderBlocks[NSStringFromClass(classType)] = [builderBlock copy];
	}
}

// TODO: Rename all Ethanols

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
	MZInjectorBuilderBlock builderBlock = self.protocolBuilderBlocks[NSStringFromProtocol(protocolType)];
	if (builderBlock != nil) {
		return builderBlock();
	}
	return nil;
}

- (id)instanceForClass:(Class)classType {
	MZInjectorBuilderBlock builderBlock = self.classBuilderBlocks[NSStringFromClass(classType)];
	if (builderBlock != nil) {
		return builderBlock() ?: ({ NSLog(@"Builder block for class %@ returned nil. Creating instance via default constructor.", NSStringFromClass(classType)); [[classType alloc] init]; });
	}
	return [[classType alloc] init];
}

@end
