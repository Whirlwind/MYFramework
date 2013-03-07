//
//  MYEntry.h
//  MYFramework
//
//  Created by Whirlwind on 13-1-16.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+MYProperty.h"
#import "MYEntryDataAccessProtocol.h"

@interface MYEntry : NSObject{
    BOOL listening;
}

@property (retain, nonatomic) id dataAccessor;

@property (copy, nonatomic) NSString *userKey;

@property (retain, nonatomic) NSNumber *index;
@property (retain, nonatomic) NSNumber *remoteId;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *updatedAt;
@property (assign, nonatomic) NSDate *createDate;
@property (assign, nonatomic) NSDate *updateDate;

@property (retain, nonatomic) NSError *error;

@property (assign, nonatomic) BOOL needPostLocalChangeNotification;
@property (retain, nonatomic) NSMutableDictionary *changes;

- (id)initWithIndex:(NSNumber *)index;

#pragma mark - listen
- (NSArray *)listenProperties;
- (void)disableListenProperty:(void(^)(void))block;
- (void)reverseWithProperty:(NSString *)property;
- (void)reverse;
- (void)postLocalChangeNotification;
+ (void)postLocalChangeNotification;

#pragma mark - DAO
- (BOOL)save;
- (BOOL)destroy;

#pragma mark - Convenient
+ (NSInteger)count;
+ (id)entryAt:(NSNumber *)index;
+ (BOOL)existEntry;

#pragma mark for override
- (BOOL)createEntry;
- (BOOL)updateEntry;
- (BOOL)removeEntry;

+ (NSString *)userKey;
+ (id)dataAccessor;
@end