//
//  BNRItem.h
//  RandomPossesions
//
//  Created by Lewis Cooper on 1/22/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject <NSCoding> {
    
    NSString *itemName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
    
}

- (id) initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

// n
+ (id) randomItem;

- (NSString *) itemName;
- (void) setItemName:(NSString *)str;
- (NSString *)serialNumber;
- (void) setSerialNumber:(NSString *)str;
- (int) valueInDollars;
- (void) setValueInDollars:(int)val;
- (NSDate *)dateCreated;
- (void) setDate:(NSDate *)date;




@property (nonatomic, copy) NSString *imageKey;

@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSData *thumbnailData;

- (void) setThumbnailDataFromImage:(UIImage *)image;

@end
