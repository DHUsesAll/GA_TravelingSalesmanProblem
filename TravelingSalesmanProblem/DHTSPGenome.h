//
//  DHTSPGenome.h
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>

// 基因序
@interface DHTSPGenome : NSObject

@property (nonatomic, strong) NSMutableArray * cities;
@property (nonatomic, assign) double fitness;

- (instancetype)initWithNumCities:(int)numCities;

@end
