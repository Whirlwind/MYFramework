//
//  MYEntry.m
//  Pods
//
//  Created by Whirlwind on 13-1-16.
//
//

#import "MYEntry.h"
#import "NSDate+Extend.h"
#import "MYDbSchema.h"
#import "MYUserEntryLog.h"

@implementation MYEntry

- (void)dealloc {
    [_index release], _index = nil;
    [_updatedAt release], _updatedAt = nil;
    [_createdAt release], _createdAt = nil;
    [_error release], _error = nil;
    [_db release], _db = nil;
    [self.dataAccessor.dataProperties enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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

- (NSObject<MYEntryDataAccessProtocol> *)dataAccessor {
    if (_dataAccessor == nil) {
        _dataAccessor = [[[self class] dataAccessor] retain];
    }
    return _dataAccessor;
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

#pragma mark - listener
- (NSArray *)listenProperties {
    if ([self.dataAccessor respondsToSelector:@selector(dataProperties)]) {
        return self.dataAccessor.dataProperties;
    }
    return @[];
}
- (void)listenProperty {
    [[self listenProperties] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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


#pragma mark - reverse
- (void)reverseWithProperty:(NSString *)property {
    SEL selector = [[self class] setterFromPropertyString:property];
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

#pragma mark - DAO
- (BOOL)save {
    if (self.index != nil && [self.changes count] <= 0) {
        return YES;
    }
    BOOL status = NO;
    if (self.index == nil) { // C
        status = [self createEntry];
    } else { // U
        status = [self updateEntry];
    }
    if (status) {
        [self postLocalChangeNotification];
        [self.changes removeAllObjects];
    }
    return status;
}

- (BOOL)destroy {
    return [self removeEntry];
}

#pragma mark - Convenient
+ (NSInteger)count {
    return [[self dataAccessor] countEntries];
}
+ (id)entryAt:(NSNumber *)index {
    return [[self dataAccessor] entryAt:index];
}
+ (BOOL)existEntry {
    return [[self dataAccessor] existEntry];
}
+ (MYEntry *)firstEntry {
    NSObject<MYEntryDataAccessProtocol> *accessor = [self dataAccessor];
    if ([accessor respondsToSelector:@selector(firstEntry)]) {
        return [[self dataAccessor] firstEntry];
    }
    LogError(@"[%@ %s] NOT implement!", NSStringFromClass([self class]), _cmd);
    return nil;
}
#pragma mark for override
- (BOOL)createEntry {
    return [self.dataAccessor createEntry];
}

- (BOOL)updateEntry {
    return [self.dataAccessor updateEntry];
}

- (BOOL)removeEntry {
    return [self.dataAccessor removeEntry];
}

+ (NSObject<MYEntryDataAccessProtocol> *)dataAccessor {
    return nil;
}
@end
