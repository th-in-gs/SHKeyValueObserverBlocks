//
//  SHAppDelegate.m
//  OSX-Example
//
//  Created by Seivan Heidari on 7/9/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHAppDelegate.h"
#import "SHKeyValueObserverBlocks.h"

@interface NSArray (Private)
-(NSSet *)setRepresentation;
@end

@implementation NSArray (Private)
-(NSSet *)setRepresentation; {
  return [NSSet setWithArray:self];
}


@end


@interface SHBackPack : NSObject
@property(nonatomic,strong) NSMutableArray * items;
@end

@implementation SHBackPack
-(instancetype)init; {
  self = [super init];
  if(self) {
    self.items = [@[] mutableCopy];
  }
  return self;
}

@end

@interface SHPocket : NSObject
@property(nonatomic,strong) NSMutableSet * items;
@end

@implementation SHPocket

-(instancetype)init; {
  self = [super init];
  if(self) {
    self.items = [NSMutableSet set];
  }
  return self;
}

@end


@interface SHPlayer : NSObject
@property(nonatomic,strong) SHBackPack * backPack;
@property(nonatomic,strong) SHPocket   * pocket;
@end

@implementation SHPlayer
-(instancetype)init; {
  self = [super init];
  if(self) {
    self.pocket   = SHPocket.new;
    self.backPack = SHBackPack.new;
  }
  return self;
}
@end

@interface SHAppDelegate ()

@property(nonatomic,strong) NSMutableArray * players;
@property(nonatomic,strong) SHPlayer       * player;
-(void)runObservers;
@end

@implementation SHAppDelegate
-(void)runObservers; {
  self.players = [@[] mutableCopy];
  self.player  = SHPlayer.new;
  
  
  NSString * identifier = [self SH_addObserverForKeyPaths:@[@"players"].setRepresentation
                                                    block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    NSLog(@"identifier: %@ - %@",change, keyPath);
  }];
  [self.players addObject:self.player];
  
  
  [self SH_addObserverForKeyPaths:@[@"player.pocket.items",@"player.backPack.items"].setRepresentation
                            block:^(id weakSelf, NSString *keyPath, NSDictionary *change) {
    NSLog(@"identifier2: %@ - %@",change,keyPath);
  }];
  
  double delayInSeconds = 2.0;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    
    [[self mutableArrayValueForKeyPath:@"player.backPack.items"] addObject:@"potion"];
    [[self mutableSetValueForKeyPath:@"player.pocket.items"] addObject:@"lighter"];
    [[self mutableArrayValueForKey:@"players"] addObject:SHPlayer.new];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
      [self SH_removeObserversForKeyPaths:@[@"players"].setRepresentation
                          withIdentifiers:@[identifier].setRepresentation];
      
    });
    
  });
  
  
  
}


-(void)applicationDidFinishLaunching:(NSNotification *)aNotification;{
  [self runObservers];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;  {
  if([self SH_handleObserverForKeyPath:keyPath withChange:change context:context])
    NSLog(@"TAKEN CARE OF BY BLOCK");
  else
    NSLog(@"Take care of here!");
  
}


@end
