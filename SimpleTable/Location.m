//
//  Location.m
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import "Location.h"

@implementation Location


+ (UIColor *)r:(int)r g:(int)g b:(int)b
{
    return [Location r:r g:g b:b a:255];
}

+ (UIColor *)r:(int)r g:(int)g b:(int)b a:(int)a
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a/255.0];
}

+ (UIColor *)colorFromHex:(NSString *)hexCode
{
    assert(hexCode != nil);
    NSUInteger hexVal = [Location hexToInt:hexCode];
    return [Location r:((hexVal & 0xFF0000) >> 16)
                      g:((hexVal & 0x00FF00) >> 8)
                      b:((hexVal & 0x0000FF) >> 0)];
}

+ (NSUInteger)hexToInt:(NSString *)hexCode
{
    assert(hexCode != nil);
    unsigned int result = 0;
    
    NSScanner *scanner = [NSScanner scannerWithString:hexCode];
    if([hexCode characterAtIndex:0] == '#')
    {
        [scanner setScanLocation:1];
    }
    [scanner scanHexInt:&result];
    return result;
}
@end
