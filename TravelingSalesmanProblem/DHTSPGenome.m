//
//  DHTSPGenome.m
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHTSPGenome.h"

@interface DHTSPGenome ()



- (void)grabPermutation:(int)numCities;

// 查看当前染色体中是否存在了该数字
- (BOOL)testNumbers:(int)number;

@end

@implementation DHTSPGenome

- (instancetype)init
{
    self = [self initWithNumCities:0];
    return self;
}

- (instancetype)initWithNumCities:(int)numCities
{
    self = [super init];
    if (self) {
        [self grabPermutation:numCities];
    }
    return self;
}

#pragma mark - private methods
- (void)grabPermutation:(int)numCities
{
    self.cities = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < numCities; i++) {
        int nextPossibleNumber = arc4random() % numCities;
        while ([self testNumbers:nextPossibleNumber]) {
            nextPossibleNumber = arc4random() % numCities;
        }
        [self.cities addObject:@(nextPossibleNumber)];
    }
}

- (BOOL)testNumbers:(int)number
{
    return [self.cities containsObject:@(number)];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%f",self.fitness];
}

@end
