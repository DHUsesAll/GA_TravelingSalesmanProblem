//
//  DHTSPCga.h
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHTSPGa : NSObject


/**
 *  遗传算法类构造方法
 *
 *  @param crossoverRate 杂交率
 *  @param mutationRate  变异率
 *  @param popSize       种群大小
 *  @param numCities     城市数量
 *
 *  @return 构造出来的遗传算法对象
 */
- (instancetype)initWithCrossoverRate:(double)crossoverRate
                         mutationRate:(double)mutationRate
                              popSize:(int)popSize
                            numCities:(int)numCities;

- (void)stop;
- (BOOL)started;
// 进化一代
- (void)epoch;

- (UIView *)mapView;

- (int)generation;

@end
