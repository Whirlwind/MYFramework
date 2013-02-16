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

@implementation MYJsonAccess

#pragma mark - init and dealloc
- (void)dealloc{
    [_request release], _request = nil;
    [_securityKey release], _securityKey = nil;
    [super dealloc];
}

#pragma mark - request
- (void)cancelRequest{
    [self.request cancel];
}

- (BOOL)requestIsCancelled{
    return [self.request isCancelled];
}

#pragma mark - request api
- (NSString *)parseAPI:(NSString *)api method:(NSString **)method {
    NSArray *array = [api componentsSeparatedByString:@"@"];
    if ([array count] < 2) {
        *method = @"POST";
        return api;
    } else {
        *method = array[0];
        return array[1];
    }
}

- (id)requestBaseAPIUrl:(NSString *)url postValue:(NSDictionary *)values {
    NSMutableDictionary *newValues = values == nil ? [NSMutableDictionary dictionaryWithCapacity:1] : [NSMutableDictionary dictionaryWithDictionary:values];
    [newValues addEntriesFromDictionary:[BHAnalysis IDToken]];
    NSString *method = nil;
    url = [self parseAPI:url method:&method];
    return [self requestURLString:url postValue:@{@"data" : [newValues universalConvertToJSONString]} method:method requestHeaders:@{@"data-type" : @"json"} security:YES];
}

- (id)requestAPI:(NSString *)api {
    return [self requestAPI:api postValue:nil];
}

- (id)requestAPI:(NSString *)api postValue:(NSDictionary *)values {
    NSString *method = nil;
    NSString *url = [self parseAPI:api method:&method];
    return [self requestBaseAPIUrl:[NSString stringWithFormat:@"%@@%@", method, [[self class] api:url]]
                                      postValue:values];
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
    [self buildRequest:url method:method params:values requestHeaders:headers];
    if (security && self.securityKey) {
        [self.request buildSecurityParams:self.securityKey postData:values addIDParams:NO];
    }
    LogInfo(@"------BEGIN REQUEST %@: %@", method, url);
    [self.request startSynchronous];
    LogInfo(@"------END REQUEST %@: %@", method, url);
    if ([self.request isCancelled]) return nil;
    NSDictionary *dic = [[self.request responseString] universalConvertToJSONObject];
    NSArray *errors = [dic objectForKey:@"errors"];
    int s = [self.request responseStatusCode];
    if (errors) {
        if ([errors isKindOfClass:[NSNull class]]) {
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
                         code:[[errors objectAtIndex:0] objectForKey:@"code"]
                      message:[[errors objectAtIndex:0] objectForKey:@"message"]
                      request:values
                     response:[self.request responseString]];
        }
        return nil;
    }
    if (s == 200) {
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
                     response:nil];
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
        LogError(@"URL: %@ %@ STATE: %d MESSAGE: %@ REQUEST: %@ RESPONSE: %@", method, url, s, message, request, response);
    } else {
        LogError(@"URL: %@ %@ STATE: %d CODE: %@ MESSAGE: %@ REQUEST: %@ RESPONSE: %@", method, url, s, code, message, request, response);
    }
}

#pragma mark - public class methods
+ (NSString *)api:(NSString *)api {
    return nil;
//    return [NSString stringWithFormat:@"%@%@%@", kONEBaseAPIDomain, kONEBaseAPIVersion, _apiType];
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
