//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Lewis Cooper on 2/12/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore


- (id) init
{
    self = [super init];
    if (self) {
        //allItems = [[NSMutableArray alloc] init];
        
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        if (!allItems) {
            allItems = [[NSMutableArray alloc] init];
        }
        
    }
    
    return self;
}

- (NSArray *) allItems
{
    return allItems;
}

- (BNRItem *) createItem
{
    //BNRItem *p = [BNRItem randomItem];
    BNRItem *p = [[BNRItem alloc] init];
    
    [allItems addObject:p];
    
    return p;
}

- (void) removeItem:(BNRItem *)p
{
    NSString *key = [p imageKey];
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [allItems removeObjectIdenticalTo:p];
}


- (void) moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    
    BNRItem *p = [allItems objectAtIndex:from];
    
    [allItems removeObjectAtIndex:from];
    
    [allItems insertObject:p atIndex:to];
}


+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (BNRItemStore *) sharedStore
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore) {
        sharedStore = [[super allocWithZone:nil] init];
    }
    return sharedStore;
}

// ARCHIVING METHODS //////////////////////

- (NSString *) itemArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

- (BOOL) saveChanges
{
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems toFile:path];
}



@end
