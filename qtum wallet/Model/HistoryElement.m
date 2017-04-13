//
//  HistoryElement.m
//  qtum wallet
//
//  Created by Sharaev Vladimir on 21.11.16.
//  Copyright © 2016 Designsters. All rights reserved.
//

#import "HistoryElement.h"
#import "BlockchainInfoManager.h"

@implementation HistoryElement


- (void)calcAmountAndAdresses:(NSDictionary *)dictionary{
    NSDictionary* hashTableAdresses = [self getHashTableOfKeys];
    CGFloat outMoney = 0;
    CGFloat inMoney = 0;
    
    //if hashTable of adresses constain object, add this value to inValue
    for (NSDictionary* inObject in dictionary[@"vin"]) {
        
        [self.fromAddreses addObject:inObject[@"address"]];
        NSString* address = [hashTableAdresses objectForKey:inObject[@"address"]];
        if (address) {
            inMoney += [inObject[@"value"] floatValue];
        }
    }
    
    //if hashTable of adresses constain object, add this value to ouyValue
    for (NSDictionary* outObject in dictionary[@"vout"]) {
        [self.toAddresses addObject:outObject[@"address"]];
        
        NSString* address = [hashTableAdresses objectForKey:outObject[@"address"]];
        if (address) {
            outMoney += [outObject[@"value"] floatValue];
        }
    }
    
    CGFloat amount = outMoney - inMoney;
    self.amount = @(amount);
    self.send = amount < 0;
}

#pragma mark - Accessory Methods

- (void)setAmount:(NSNumber *)amount
{
    _amount = amount;
    [self createAmountString];
}

- (void)setDateNumber:(NSNumber *)dateNumber
{
    _dateNumber = dateNumber;
    [self createDateString];
}

-(NSMutableArray*)fromAddreses{
    if (!_fromAddreses) {
        _fromAddreses = @[].mutableCopy;
    }
    return _fromAddreses;
}

-(NSMutableArray*)toAddresses{
    if (!_toAddresses) {
        _toAddresses = @[].mutableCopy;
    }
    return _toAddresses;
}

#pragma mark - Private Methods

- (void)createAmountString{
    self.amountString  = [NSString stringWithFormat:@"%0.3f QTUM", [self.amount floatValue]];
}

- (void)createDateString{
    CGFloat dateNumber = [self.dateNumber doubleValue];
    if (!dateNumber) {
        return;
    }
    
    NSTimeInterval dateTimeInterval = dateNumber;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:dateTimeInterval];
    NSTimeInterval nowTimeInterval = [[NSDate new] timeIntervalSince1970];
    
    NSTimeInterval difference = nowTimeInterval - dateTimeInterval;
    
    NSTimeInterval day = 24 * 60 * 60;
    NSTimeInterval currenDayTimeInterval = (long)nowTimeInterval % (long)day;
    
    NSDateFormatter *fullDateFormater = [[NSDateFormatter alloc] init];
    fullDateFormater.dateFormat = @"MMMM, d hh:mm:ss";
    fullDateFormater.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    self.fullDateString = [NSString stringWithFormat:@"%@", [fullDateFormater stringFromDate:date]];
    
    if (difference < currenDayTimeInterval) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"h:mm a";
        dateFormatter.AMSymbol = @"a.m.";
        dateFormatter.PMSymbol = @"p.m.";
        dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        
        self.shortDateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
        return;
    }
    
    if (difference < currenDayTimeInterval + day) {
        self.shortDateString = @"Yestarday";
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM dd";
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    
    self.shortDateString = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
}

- (NSDictionary *)getHashTableOfKeys{
    return [BlockchainInfoManager getHashTableOfKeys];
}

#pragma mark - Setup

-(void)setupWithObject:(id)object{
    
    if ([object isKindOfClass:[NSDictionary class]]) {
            //u shoud not use setter at initionalize
        self.dateNumber = ![object[@"block_time"] isKindOfClass:[NSNull class]] ? object[@"block_time"] : nil;
        self.address = object[@"address"];
        self.confirmed = [object[@"block_height"] floatValue] > 0;
        self.txHash = object[@"tx_hash"];
        [self calcAmountAndAdresses:object];
    }
}

#pragma mark - Equal

-(BOOL)isEqualElementWithoutConfimation:(HistoryElement*)object{
    if (self.address && object.address && ![self.address isEqualToString:object.address]) {
        return NO;
    }
    if (self.amount && object.amount && ![self.amount isEqualToNumber:object.amount]) {
        return NO;
    }
    if (self.amountString && object.amountString && ![self.amountString isEqualToString:object.amountString] ) {
        return NO;
    }
    if (self.dateNumber && object.dateNumber && ![self.dateNumber isEqualToNumber:object.dateNumber] ) {
        return NO;
    }
    if (self.shortDateString && object.shortDateString && ![self.shortDateString isEqualToString:object.shortDateString]) {
        return NO;
    }
    if (!self.send == object.send) {
        return NO;
    }
    if (self.txHash && object.txHash && ![self.txHash isEqualToString:object.txHash]) {
        return NO;
    }
    return YES;
}

@end
