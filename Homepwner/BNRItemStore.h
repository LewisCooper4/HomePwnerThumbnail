//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Lewis Cooper on 2/12/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
}

+ (BNRItemStore *) sharedStore;


- (NSArray *) allItems;
- (BNRItem *) createItem;
- (void) removeItem:(BNRItem *)p;
- (void) moveItemAtIndex:(int)from toIndex:(int)to;

// archiving methods
- (NSString *) itemArchivePath;
- (BOOL) saveChanges;

@end
