//
//  DHTSPCga.m
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHTSPGa.h"
#import "DHTSPMap.h"
#import "DHTSPGenome.h"
#import "defines.h"

@interface DHTSPGa ()
{
    double  _mutationRate;
    double  _crossoverRate;
    
    // 整个种子群体的总适应性分数
    double  _totalFitness;
    // 在此之前找到的最短周游路径
    double  _shortestRoute;
    // 在此之前找到的最长周游路径
    double  _longestRoute;
    // 种子群中基因组的数目
    int     _popSize;
    // 染色体长度
    int     _chromoLength;
    // 最新一代中适应分最高的成员
    int     _fittestGenome;
    // 当前是第几代
    int     _generation;
    // 当前是否正在绘图
    BOOL    _started;

}

// 交换变异
- (void)exchangeMutate:(DHTSPGenome *)genome;
// 部分匹配杂交
- (void)partiallyMappedCrossover:(DHTSPGenome *)mum :(DHTSPGenome *)dad :(DHTSPGenome *)baby1 :(DHTSPGenome *)baby2;
// 赌轮选择
- (DHTSPGenome *)rouletteWheelSelection;
// 计算种群适应性分数
- (void)calculatePopulationsFitness;

// 重设各种变量
- (void)reset;
// 创建初始种群
- (void)createStartingPopulation;
// 将种群按照适应性分数进行排序
- (void)sortPopulation;


// 基因群组
@property (nonatomic, strong) NSMutableArray * population;

@property (nonatomic, strong) DHTSPMap * map;


@end

@implementation DHTSPGa


- (instancetype)initWithCrossoverRate:(double)crossoverRate
                         mutationRate:(double)mutationRate
                              popSize:(int)popSize
                            numCities:(int)numCities
{
    self = [super init];
    if (self) {
        _crossoverRate = crossoverRate;
        _mutationRate = mutationRate;
        _popSize = popSize;
        _chromoLength = numCities;
        
        _generation = 0;
        [self reset];
        
        self.map = [[DHTSPMap alloc] initWithNumberOfCities:numCities];
        [self createStartingPopulation];
    }
    return self;
}

- (void)stop
{
    _started = NO;
}

- (BOOL)started
{
    return _started;
}

- (UIView *)mapView
{
    return self.map.mapView;
}

- (int)generation
{
    return _generation;
}

#pragma mark - private methods

- (DHTSPGenome *)rouletteWheelSelection
{
    double range = arc4random()%101 / 100.f;
    double fSlice = range * _totalFitness;
    
    double cfTotal = 0;
    int selectedGenome = 0;
    for (int i = 0; i < _popSize; i++) {
        DHTSPGenome * genome = self.population[i];
        cfTotal += genome.fitness;
        if (cfTotal > fSlice) {
            selectedGenome = i;
            break;
        }
    }
    
    return self.population[selectedGenome];
}


- (void)createStartingPopulation
{
    self.population = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < _popSize; ++i) {
        DHTSPGenome * genome = [[DHTSPGenome alloc] initWithNumCities:_chromoLength];
        [self.population addObject:genome];
    }
    [self sortPopulation];
    
}

- (void)reset
{
    _fittestGenome = 0;
    _totalFitness = 0;
    _shortestRoute = INT_MAX;
    _longestRoute = 0;
    _started = NO;
}

- (void)epoch
{
    [self reset];
    [self calculatePopulationsFitness];
    // 如果找到了一个解，则退出
    if (_shortestRoute - [self.map bestPossibleRoute] <= EPSILON) {
        DHTSPGenome * fittestGenome = self.population.firstObject;
        [_map renderResult:fittestGenome.cities];
        return;
    }
    // 即将进化为新种群
    NSMutableArray * newPopulation = [NSMutableArray arrayWithCapacity:0];
    // 首先把上一代最适应的NUM_BEST_TO_ADD个成员（精英）加入到种群
    for (int i = 0; i < NUM_BEST_TO_ADD; ++i) {
        [newPopulation addObject:self.population[i]];
    }
    // 再创建种群的其他成员
    while (newPopulation.count != _popSize) {
        // 选取两个基因作为父代
        DHTSPGenome * mum = [self rouletteWheelSelection];
        DHTSPGenome * dad = [self rouletteWheelSelection];
        // 创建两个子代
        DHTSPGenome * baby1 = [[DHTSPGenome alloc] init];
        DHTSPGenome * baby2 = [[DHTSPGenome alloc] init];
        
        // 杂交
        [self partiallyMappedCrossover:mum :dad :baby1 :baby2];
        // 变异
        [self exchangeMutate:baby1];
        [self exchangeMutate:baby2];
        
        // 加入新种群
        [newPopulation addObject:baby1];
        [newPopulation addObject:baby2];
    }
    
    // 复制到下一代
    self.population = newPopulation;
    // 代加1
    ++_generation;
    
    
    [self sortPopulation];
    DHTSPGenome * fittestGenome = self.population.firstObject;
    [_map renderResult:fittestGenome.cities];
}

- (void)partiallyMappedCrossover:(DHTSPGenome *)mum :(DHTSPGenome *)dad :(DHTSPGenome *)baby1 :(DHTSPGenome *)baby2
{
    baby1.cities = [mum.cities mutableCopy];
    baby2.cities = [dad.cities mutableCopy];
    
    // 是否立即返回取决于杂交率或者两个父辈来自同一染色体
    double flag = arc4random()%101 / 100.f;
    if (flag > _crossoverRate || [mum.cities isEqualToArray:dad.cities]) {
        return;
    }
    
    // 首先选取染色体的一节（section）的开始点beg
    int beg = arc4random() % (mum.cities.count - 1);
    int end = beg;
    
    // 再选一个结束点end
    while (end <= beg) {
        end = arc4random() % mum.cities.count;
    }
    
    // 从beg到end，依次寻找匹配的基因对，并交换两个子染色体中的位置
    for (int pos = beg; pos < end + 1; ++pos) {
        
        int gene1 = [mum.cities[pos] intValue];
        int gene2 = [dad.cities[pos] intValue];
        
        if (gene1 != gene2) {
            // 将它们从子代baby1中寻找出来，并进行交换
            NSInteger pos1 = [baby1.cities indexOfObject:@(gene1)];
            NSInteger pos2 = [baby1.cities indexOfObject:@(gene2)];
            [baby1.cities exchangeObjectAtIndex:pos1 withObjectAtIndex:pos2];
            
            // 再将它们从子代baby2中寻找出来，并进行交换
            pos1 = [baby2.cities indexOfObject:@(gene1)];
            pos2 = [baby2.cities indexOfObject:@(gene2)];
            [baby2.cities exchangeObjectAtIndex:pos1 withObjectAtIndex:pos2];
        }
    }
}

- (void)exchangeMutate:(DHTSPGenome *)genome
{
    // 根据变异率判断是否进行变异处理
    double flag = arc4random()%10001 / 10000.f;
    if (flag > _mutationRate) {
        return;
    }
    
    // 选择第一个基因
    int pos1 = arc4random()%genome.cities.count;
    int pos2 = pos1;
    while (pos1 == pos2) {
        pos2 = arc4random()%genome.cities.count;
    }
    // 交换它们位置上的内容
    [genome.cities exchangeObjectAtIndex:pos1 withObjectAtIndex:pos2];
}


- (void)calculatePopulationsFitness
{
    // 对每一个染色体
    [self.population enumerateObjectsUsingBlock:^(DHTSPGenome * obj, NSUInteger idx, BOOL *stop) {
        
        // 计算染色体周游路线长度
        double tourLength = [self.map getTourLength:obj.cities];
        
        obj.fitness = tourLength;
        // 在每一代中保存最短路程长度
        if (tourLength < _shortestRoute) {
            _shortestRoute = tourLength;
        }
        // 在每一代中保存最长路程长度
        if (tourLength > _longestRoute) {
            _longestRoute = tourLength;
        }
        
    }];
    
    // 计算完所有周游路径长度，下一步计算它们的适应性分数
    [self.population enumerateObjectsUsingBlock:^(DHTSPGenome * obj, NSUInteger idx, BOOL *stop) {
        obj.fitness = _longestRoute - obj.fitness;
        _totalFitness += obj.fitness;
    }];
    // 将种群按照适应性分数排序
    [self sortPopulation];
}

- (void)sortPopulation
{
    // 适应性高的个体在种群最开始的位置
    [self.population sortUsingComparator:^NSComparisonResult(DHTSPGenome * obj1, DHTSPGenome * obj2) {
        if (obj1.fitness > obj2.fitness) {
            return NSOrderedAscending;
        }
        if (obj1.fitness < obj2.fitness) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
}

@end
