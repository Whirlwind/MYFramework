//
//  MYJsonAccess.h
//  foodiet
//
//  Created by Whirlwind James on 11-12-27.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

@class ASIHTTPRequest;

@interface MYJsonAccess : NSObject

@property (nonatomic, retain) ASIHTTPRequest *request;
@property (copy, nonatomic) NSString *securityKey;

- (NSDictionary *)requestAPI:(NSString *)api;
- (NSDictionary *)requestAPI:(NSString *)api
                   postValue:(NSDictionary *)values;
- (NSDictionary *)requestURLString:(NSString *)url
             postValue:(NSDictionary *)values;
- (NSDictionary *)requestURLString:(NSString *)url
                            method:(NSString *)method;
- (NSDictionary *)requestURLString:(NSString *)url
                         postValue:(NSDictionary *)value
                            method:(NSString *)method;
- (void)cancelRequest;
- (BOOL)requestIsCancelled;

+ (NSString *)api:(NSString *)api;
+ (id)requestBaseAPIUrl:(NSString *)url postValue:(NSDictionary *)value;
+ (id)requestAPI:(NSString *)api;
+ (id)requestAPI:(NSString *)api postValue:(NSDictionary *)values;

+ (id)useSecurityKey:(NSString *)key;
@end
