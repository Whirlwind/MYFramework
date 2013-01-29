//
//  MYEntry.m
//  Pods
//
//  Created by Whirlwind on 13-1-16.
//
//

#import "MYEntry.h"
#import "NSDate+Extend.h"
#import "MYEntryDbSchema.h"
#import "MYUserEntryLog.h"

@implementation MYEntry

@synthesize dbQueue = _dbQueue;

- (void)dealloc {
    [_index release], _index = nil;
    [_updatedAt release], _updatedAt = nil;
    [_createdAt release], _createdAt = nil;
    [_error release], _error = nil;
    [_db release], _db = nil;
    [_dbQueue release], _dbQueue = nil;
    NSArray *properties = [[MYEntryDbSchema sharedInstance] propertiesForModel:[self class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self removeObserver:self forKeyPath:obj];
    }];
    [_changes release], _changes = nil;
    [_index release], _index = nil;
    [super dealloc];
}

- (void)setCreateDate:(NSDate *)date {
    [self setCreatedAt:[date strftime:kMYDateTimeFormat]];
}

- (NSDate *)createDate {
    return [NSDate dateFromString:self.createdAt];
}

- (void)setUpdateDate:(NSDate *)updateDate {
    [self setUpdatedAt:[updateDate strftime:kMYDateTimeFormat]];
}

- (NSDate *)updateDate {
    return [NSDate dateFromString:self.updatedAt];
}

- (id)init {
    if (self = [super init]) {
        listening = YES;
        self.insertModeUsingReplace = YES;
        self.needPostLocalChangeNotification = YES;
        [self listenProperty];
    }
    return self;
}

- (void)disableListenProperty:(void(^)(void))block {
    listening = NO;
    block();
    listening = YES;
}

#pragma mark - getter

- (FMDatabaseQueue *)dbQueue {
    if (_dbQueue == nil) {
        return [[self class] dbQueue];
    }
    return _dbQueue;
}

+ (FMDatabaseQueue *)dbQueue {
    return nil;
}

- (NSMutableDictionary *)changes {
    if (_changes == nil)
        _changes = [[NSMutableDictionary alloc] initWithCapacity:0];
    return _changes;
}

+ (BOOL)isUserDb {
    return NO;
}

+ (BOOL)needLog {
    return NO;
}

+ (NSString *)modelName {
    return [self description];
}

- (void)postLocalChangeNotification {
    if (self.needPostLocalChangeNotification) {
        [[self class] postLocalChangeNotification];
    }
}

+ (void)postLocalChangeNotification {
    MY_BACKGROUND_BEGIN
    POST_BROADCAST;
    MY_BACKGROUND_COMMIT
}

#pragma mark - table name
- (NSString *)tableName {
    if (_tableName == nil) {
        return [[self class] tableName];
    }
    return _tableName;
}

+ (NSString *)tableName {
    return [self description];
}

#pragma mark - listener
- (void)listenProperty {
    if ([self isKindOfClass:[MYEntryDbSchema class]]) {
        return;
    }
    NSArray *properties = [[MYEntryDbSchema sharedInstance] propertiesForModel:[self class]];
    [properties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self addObserver:self
               forKeyPath:obj
                  options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew
                  context:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!listening) {
        return;
    }
    if ([keyPath isEqualToString:@"index"])
        return;
    id oldValue = [change valueForKey:NSKeyValueChangeOldKey];
    id newValue = [change valueForKey:NSKeyValueChangeNewKey];
    if ([oldValue isEqual:newValue])
        return;
    if (oldValue == nil) {
        oldValue = [NSNull null];
    }
    NSMutableArray *array = [self.changes valueForKey:keyPath];
    if (array == nil) {
        array = [NSMutableArray arrayWithObjects:oldValue, newValue,  nil];
        (self.changes)[keyPath] = array;
    } else {
        if ([array[0] isEqual:newValue]) {
            [self.changes removeObjectForKey:keyPath];
        } else {
            array[1] = newValue;
        }
    }
}

#pragma mark - log

- (BOOL)logChanges:(NSDictionary *)changes usingDb:(FMDatabase *)db {
    NSMutableDictionary *logChanges = [NSMutableDictionary dictionaryWithDictionary:changes];
    [self.ignoreLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[MYEntryDbSchema sharedInstance] dbFieldNameForProperty:property forModel:[self class]];
        [logChanges removeObjectForKey:field];
    }];
    [self.extendLogProperties enumerateObjectsUsingBlock:^(NSString *property, NSUInteger idx, BOOL *stop) {
        NSString *field = [[MYEntryDbSchema sharedInstance] dbFieldNameForProperty:property forModel:[self class]];
        if (field) {
            [logChanges setValue:[self performSelector:NSSelectorFromString(property)] forKey:field];
        }
    }];
    return [[MYUserEntryLog sharedInstance] logChangeForModel:[[self class] modelName]
                                                      localId:self.index
                                                     uniqueId:self.index
                                                      changes:logChanges
                                                    updatedAt:self.updatedAt
                                                      usingDb:db];
}

- (BOOL)logDeleteUsingDb:(FMDatabase *)db {
    return [[MYUserEntryLog sharedInstance] logDeleteForModel:[[self class] modelName]
                                                      localId:self.index
                                                     uniqueId:self.index
                                                    updatedAt:self.updatedAt
                                                      usingDb:db];
}

#pragma mark - reverse
- (void)reverseWithProperty:(NSString *)property {
    SEL selector = [[self class] convertDbFieldNameToSetSelector:property];
    NSArray *change = (NSArray *)[self.changes valueForKey:property];
    if (change == nil)
        return;
    [self performSelector:selector withObject:change[0]];
}

- (void)reverse {
    for (NSString *property in self.changes.allKeys) {
        [self reverseWithProperty:property];
    }
}
@end
