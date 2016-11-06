//
//  Location.h
//  CoffeeKit
//
//  Created by Scott McAlister on 1/21/14.
//  Copyright (c) 2014 4 Arrows Media, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *isin;
@property (nonatomic, strong) NSString *nav;
@property (nonatomic, strong) NSString *schemeCode;
@property (nonatomic, strong) NSString *schemeName;
@property (nonatomic, strong) NSString *customSchemeName;
@property (nonatomic, strong) NSString *amountInvested;
@property (nonatomic, strong) NSString *currentAmount;
@property (nonatomic, strong) NSString *totalInvestedAmount;
@property (nonatomic, strong) NSString *totalCurrentAmount;
@property (nonatomic, strong) NSString *profitLossPercentage;

+ (UIColor *)r:(int)r g:(int)g b:(int)b;
+ (UIColor *)r:(int)r g:(int)g b:(int)b a:(int)a;
+ (NSUInteger)hexToInt:(NSString *)hexCode;
+ (UIColor *)colorFromHex:(NSString *)hexCode;



@end
