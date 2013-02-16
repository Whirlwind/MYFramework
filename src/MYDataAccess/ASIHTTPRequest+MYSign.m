//
//  ASIHTTPRequest+MYSign.m
//
//  Created by apple on 12-11-22.
//  Copyright (c) 2012年 BOOHEE. All rights reserved.
//

#import "ASIHTTPRequest+MYSign.h"
#import "URLHelper.h"
#import "NSString+MD5Addition.h"
#import "NSString+URLEncoding.h"
#import "BHAnalysis.h"
#import "ASIFormDataRequest.h"

@implementation ASIHTTPRequest (MYSign)

- (void)buildSecurityParams:(NSString*)appSecret
{
    [self buildSecurityParams:appSecret postData:nil];
}

- (void)buildSecurityParams:(NSString*)appSecret postData:(NSDictionary*)__postData
{
    [self buildSecurityParams:appSecret postData:__postData addIDParams:YES];
}

- (void)buildSecurityParams:(NSString*)appSecret postData:(NSDictionary*)__postData addIDParams:(BOOL)__addIDParams
{
    NSMutableDictionary* resultDict = [[NSMutableDictionary alloc] init];
    
    NSDictionary* dict;
    
    if (__postData)
    {
        dict = __postData;
    }
    else
    {
        dict = [url dictionaryOfQuery];
    }
    
    [resultDict addEntriesFromDictionary:dict];
    
    if (__addIDParams) {
        [self mixAdditionParams:dict];
        [resultDict addEntriesFromDictionary:[self additionParams]];
    }
    
    NSString* apiPath = [self matchAPIPath:[url absoluteString]];
    
    NSString* str = [NSString stringWithFormat:@"%@%@%@%@",
                     appSecret,
                     requestMethod,
                     apiPath,
                     [self queryStringFromDictionary:resultDict]];

    [resultDict release];
    
    if (self.requestHeaders) {
        [self.requestHeaders setValue:[str stringFromMD5] forKey:@"consumer-key"];
    } else {
        self.requestHeaders = [NSMutableDictionary dictionaryWithObject:[str stringFromMD5] forKey:@"consumer-key"];
    }
}

- (NSMutableDictionary*)additionParams
{
    return [BHAnalysis IDToken];
}

// addition app version , build version, mac , etc...
- (void)mixAdditionParams:(NSDictionary*)__postData
{
    NSMutableDictionary* resultDict = [self additionParams];
    
    if ([self.requestMethod isEqualToString:@"GET"]) {
        
        [resultDict addEntriesFromDictionary:__postData];
        
        NSString* urlPath = [self matchURLPath:[url absoluteString]];
        NSString* mixPath = [NSString stringWithFormat:@"%@%@", urlPath, [URLHelper getURL:nil queryParameters:resultDict isSort:YES]];
        
        [self setURL:[NSURL URLWithString:mixPath]];
        
    }else
    {
        
        NSArray * keys = [resultDict allKeys];
        
        for ( NSString * key in keys )
        {
            
            if ([self isKindOfClass:[ASIFormDataRequest class]])
            {
                [(ASIFormDataRequest*)self setPostValue:[resultDict objectForKey:key] forKey:key];
            }
            
        }
        
    }
}

- (NSString*) matchURLPath:(NSString*)string
{
    // http://xxx,xxx/api/action
    return [[string componentsSeparatedByString:@"?"] objectAtIndex:0];
}

- (NSString*) matchAPIPath:(NSString*)string
{
    NSString* apiPath = @"";
    
    NSRange firstDelimiterRange = [string rangeOfString:@"?"];
    
    if (firstDelimiterRange.location != NSNotFound) {
        string = [string substringWithRange:NSMakeRange(0, firstDelimiterRange.location)];
    }
    
    NSString *regexStr = @".*://.+?(\\/.*)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:0 error:nil];
    
    NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (result) {
        NSRange range = [result rangeAtIndex:1];
        apiPath = [string substringWithRange:range];
    }
    
    return apiPath;
}

- (BOOL) validateUrl: (NSString *) candidate {
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

- (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    NSMutableArray * pairs = [NSMutableArray array];
    NSArray *sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(compare:)];
    
	for ( NSString * key in sortedKeys )
	{
        id value = [dict objectForKey:key];
        
		if ( ([value isKindOfClass:[NSNumber class]]) )
		{
			value = [value stringValue];
            
		}else if ([value isKindOfClass:[NSString class]])
        {
            
        }else
        {
            continue;
        }
        
		NSString * urlEncoding = [value encodedURLParameterString];
		[pairs addObject:[NSString stringWithFormat:@"%@%@", key, urlEncoding]];
	}
	
	return [pairs componentsJoinedByString:@""];
}

@end