//
//  MZInjector.h
//  Memz
//
//  Created by Bastien Falcou on 12/15/15.
//  Copyright © 2015 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^ MZInjectorBuilderBlock)(void);

@interface MZInjector : NSObject

- (void)bindClass:(Class)classToInstanciate toProtocol:(Protocol *)protocolType;
- (void)bindClass:(Class)classToInstanciate toClass:(Class)classType;

- (void)bindInstance:(id)instance toProtocol:(Protocol *)protocolType;
- (void)bindInstance:(id)instance toClass:(Class)classType;

- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toProtocol:(Protocol *)protocolType;
- (void)bindBlock:(MZInjectorBuilderBlock)builderBlock toClass:(Class)classType;

- (id)instanceForProtocol:(Protocol *)protocolType;
- (id)instanceForClass:(Class)classType;

@end
