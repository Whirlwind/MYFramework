//
//  MYJsonAccess.m
//  foodiet
//
//  Created by Whirlwind James on 11-12-27.
//  Copyright (c) 2011年 BOOHEE. All rights reserved.
//

#import "MYJsonAccess.h"
#import "ASIFormDataRequest.h"
#import "NSJSONSerialization+JSONKit.h"
#import "ASIHTTPRequest+MYSign.h"
#import "URLHelper.h"
#import "BHAnalysis.h"
#import "ASIDownloadCache.h"

@interface MYJsonAccess ()

@property (nonatomic, retain) ASIHTTPRequest *request;

@end

@implementation MYJsonAccess

+ (void)initialize {
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    [super initialize];
}
#pragma mark - init and dealloc
- (void)dealloc{
    [_lastError release], _lastError = nil;
    [_apiVersion release], _apiVersion = nil;
    [_serverDomain release], _serverDomain = nil;
    [_request release], _request = nil;
    [_securityKey release], _securityKey = nil;
    [super dealloc];
}

- (id)init {
    if (self = [super init]) {
        self.cachePolicy = ASIUseDefaultCachePolicy;
    }
    return self;
}
#pragma mark - getter
- (NSString *)serverDomain {
    if (_serverDomain == nil) {
        _serverDomain = [[[self class] serverDomain] retain];
    }
    return _serverDomain;
}

- (NSString *)apiVersion {
    if (_apiVersion == nil) {
        _apiVersion = [[[self class] apiVersion] retain];
    }
    return _apiVersion;
}

#pragma mark - request
- (void)cancelRequest{
    [self.request cancel];
}

- (BOOL)requestIsCancelled{
    return [self.request isCancelled];
}

#pragma mark - request api
- (NSString *)parseAPI:(NSString *)api method:(NSString **)method args:(NSMutableDictionary **)args{
    NSArray *array = [api componentsSeparatedByString:@"@"];
    if ([array count] < 2) {
        *method = @"GET";
        return api;
    } else {
        *method = array[0];
        return array[1];
    }
}

- (void)handleParams:(NSMutableDictionary **)params {
    [*params addEntriesFromDictionary:[BHAnalysis IDToken]];
}

- (id)requestBaseAPIUrl:(NSString *)url postValue:(NSDictionary *)values {
    NSMutableDictionary *newValues = values == nil ? [NSMutableDictionary dictionaryWithCapacity:1] : [NSMutableDictionary dictionaryWithDictionary:values];
    [self handleParams:&newValues];
    NSString *method = nil;
    url = [self parseAPI:url method:&method args:&newValues];
    return [self requestURLString:url postValue:@{@"data" : [newValues universalConvertToJSONString]} method:method requestHeaders:@{@"data-type" : @"json"} security:YES];
}

- (id)requestAPI:(NSString *)api {
    return [self requestAPI:api postValue:nil];
}

- (id)requestAPI:(NSString *)api postValue:(NSDictionary *)values {
    NSString *method = nil;
    NSMutableDictionary *v = values == nil ? nil : [[NSMutableDictionary alloc] initWithDictionary:values];
    NSString *url = [self parseAPI:api method:&method args:&v];
    return [self requestBaseAPIUrl:[NSString stringWithFormat:@"%@@%@", method, [self api:url]]
                         postValue:[v autorelease]];
}

#pragma mark - request url
- (void)buildRequest:(NSString *)url method:(NSString *)requestMethod params:(NSDictionary *)postValue requestHeaders:(NSDictionary *)headers {
    if ([requestMethod isEqualToString:@"POST"]) {
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
        [postValue enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [request addPostValue:obj forKey:key];
        }];
        self.request = request;
    } else {
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[URLHelper _queryStringWithBase:url parameters:postValue]]];
        postValue = nil;
    }
    self.request.requestMethod = requestMethod;
    self.request.cachePolicy = self.cachePolicy;
    if (headers) {
        if (self.request.requestHeaders) {
            [self.request.requestHeaders addEntriesFromDictionary:headers];
        } else {
            self.request.requestHeaders = [NSMutableDictionary dictionaryWithDictionary:headers];
        }
    }
}

- (NSDictionary *)requestURLString:(NSString *)url postValue:(NSDictionary *)values {
    return [self requestURLString:url postValue:values method:@"POST"];
}

- (NSDictionary *)requestURLString:(NSString *)url method:(NSString *)method {
    return [self requestURLString:url postValue:nil method:method];
}

- (NSDictionary *)requestURLString:(NSString *)url postValue:(NSDictionary *)values method:(NSString *)method {
    return [self requestURLString:url postValue:values method:method requestHeaders:nil];
}

- (NSDictionary *)requestURLString:(NSString *)url postValue:(NSDictionary *)values method:(NSString *)method requestHeaders:(NSDictionary *)headers {
    return [self requestURLString:url postValue:values method:method requestHeaders:headers security:NO];
}

- (NSDictionary *)requestURLString:(NSString *)url postValue:(NSDictionary *)values method:(NSString *)method requestHeaders:(NSDictionary *)headers security:(BOOL)security {
    self.lastError = nil;
    [self buildRequest:url method:method params:values requestHeaders:headers];
    if (security && self.securityKey) {
        [self.request buildSecurityParams:self.securityKey postData:values addIDParams:NO];
    }
    LogInfo(@"------BEGIN REQUEST %@: %@", method, url);
    [self.request startSynchronous];
    LogInfo(@"------END REQUEST %@: %@", method, url);
    if ([self.request isCancelled]) return nil;
    NSDictionary *dic = [[self.request responseString] universalConvertToJSONObject];
    NSArray *errors = dic[@"errors"];
    NSDictionary *error = dic[@"error"];
    if (errors) {
        error = errors[0];
    }
    int s = [self.request responseStatusCode];
    if (error) {
        if ([error isKindOfClass:[NSNull class]]) {
            [self reportError:url
                       method:method
                       status:s
                         code:nil
                      message:@"未知错误!"
                      request:values
                     response:[self.request responseString]];
        } else {
            [self reportError:url
                       method:method
                       status:s
                         code:[error objectForKey:@"code"]
                      message:[error objectForKey:@"message"]
                      request:values
                     response:[self.request responseString]];
            self.lastError = [NSError errorWithDomain:@"json" code:[error[@"code"] integerValue] userInfo:error];
        }
        return nil;
    }
    if (s >= 200 && s < 300) {
        if (dic == nil) {
            [self reportError:url
                       method:method
                       status:s
                         code:nil
                      message:@"接收到的数据无法解析！"
                      request:values
                     response:[self.request responseString]];
            return nil;
        }
        LogInfo(@"URL: %@ %@ REQUEST: %@ RESPONSE: %@", method, url, values, dic);
        return dic;
    } else {
        if (s == 0) {
            [self reportError:url
                       method:method
                       status:s
                         code:nil
                      message:@"网络连接存在异常"
                      request:values
                     response:nil];
        } else {
            [self reportError:url
                       method:method
                       status:s
                         code:nil
                      message:@"未知错误！"
                      request:values
                     response:[self.request responseString]];
        }
    }
    return nil;
}

#pragma mark - error
- (void)reportError:(NSString *)url
             method:(NSString *)method
             status:(NSInteger)status
               code:(NSString *)code
            message:(NSString *)message
            request:(NSDictionary *)request
           response:(NSString *)response {
    if (status == 0) {
        LogError(@"URL: %@ %@ STATE: %d MESSAGE: %@", method, url, status, @"网络连接存在异常");
    } else if (code == nil) {
        LogError(@"URL: %@ %@ STATE: %d MESSAGE: %@ REQUEST: %@ RESPONSE: %@", method, url, status, message, request, response);
    } else {
        LogError(@"URL: %@ %@ STATE: %d CODE: %@ MESSAGE: %@ REQUEST: %@ RESPONSE: %@", method, url, status, code, message, request, response);
    }
}

#pragma mark - override
- (NSString *)api:(NSString *)api {
    return [NSString stringWithFormat:@"%@%@%@", self.serverDomain, self.apiVersion, api];
}
#pragma mark - public class methods
+ (NSString *)serverDomain {
    return nil;
}
+ (NSString *)apiVersion {
    return @"";
}
+ (id)requestBaseAPIUrl:(NSString *)url postValue:(NSDictionary *)value {
    MYJsonAccess *json = [[[self class] alloc] init];
    NSDictionary *dic = [[json requestBaseAPIUrl:url postValue:value] retain];
    [json release];
    return [dic autorelease];
}

+ (id)requestAPI:(NSString *)api {
    MYJsonAccess *json = [[[self class] alloc] init];
    NSDictionary *dic = [[json requestAPI:api] retain];
    [json release];
    return [dic autorelease];
}

+ (id)requestAPI:(NSString *)api postValue:(NSDictionary *)values {
    MYJsonAccess *json = [[[self class] alloc] init];
    NSDictionary *dic = [[json requestAPI:api
                                postValue:values
                          ] retain];
    [json release];
    return [dic autorelease];
}

+ (id)useSecurityKey:(NSString *)key {
    MYJsonAccess *json = [[[self class] alloc] init];
    [json setSecurityKey:key];
    return [json autorelease];
}
@end
