//
//  defines.h
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-13.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#ifndef TSP_defines_h
#define TSP_defines_h

#define MAP_RADIUS      150

#define NUM_CITIES      20
#define CITY_SIZE       5

#define MUTATION_RATE   0.2
#define CROSSOVER_RATE  0.75
#define POP_SIZE        40

// 必须为2的倍数
#define NUM_BEST_TO_ADD 2

// 校正精度误差（OC似乎没这个必要，浮点数的大小判断在Xcode中能精确的进行判断）
#define EPSILON         0.000001

#endif
