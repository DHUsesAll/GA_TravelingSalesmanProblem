//
//  DHTSPMap.m
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import "DHTSPMap.h"
#import "DHVector.h"
#import "defines.h"

@interface DHTSPMap ()
{
    int _numCities;
    
    double _bestPossibleRoute;
    
    UIView * _mapView;
    
    CAShapeLayer * _resultShapeLayer;
}

- (void)createCitiesCircular;
- (void)calculateBestPossibleRoute;
- (CGFloat)distanceFromCity:(CGPoint)cityA toCity:(CGPoint)cityB;

@end

@implementation DHTSPMap

- (instancetype)initWithNumberOfCities:(int)numCities
{
    self = [super init];
    if (self) {
        _numCities = numCities;
        [self createCitiesCircular];
        [self calculateBestPossibleRoute];
    }
    return self;
}

- (UIView *)mapView
{
    return _mapView;
}

- (CGFloat)bestPossibleRoute
{
    return _bestPossibleRoute;
}

- (CGFloat)getTourLength:(NSArray *)tour
{
    CGFloat tourLength = 0;
    for (int i = 0; i < _numCities; ++i) {
        int city1Idx = i;
        int city2Idx = i+1;
        if (i + 1 == _numCities) {
            city2Idx = 0;
        }
        CGPoint city1 = _cityCoOrds[[tour[city1Idx] intValue]];
        CGPoint city2 = _cityCoOrds[[tour[city2Idx] intValue]];
        CGFloat distance = [self distanceFromCity:city1 toCity:city2];
        tourLength += distance;
    }
    return tourLength;
}

- (void)renderResult:(NSArray *)genome
{
    UIBezierPath * path = [UIBezierPath bezierPath];
    
    int firstCity = [genome.firstObject intValue];
    
    [path moveToPoint:self.cityCoOrds[firstCity]];
    
    for (int i = 1; i < _numCities; ++i) {
        NSNumber * obj = genome[i];
        int cityLocation = [obj intValue];
        [path addLineToPoint:self.cityCoOrds[cityLocation]];
    }
    
    [path closePath];
    
    _resultShapeLayer.path = path.CGPath;
}

#pragma mark - private methods

- (CGFloat)distanceFromCity:(CGPoint)cityA toCity:(CGPoint)cityB
{
    return sqrt(pow((cityA.x - cityB.x), 2) + pow((cityA.y - cityB.y), 2));
}

- (void)createCitiesCircular
{
    _mapView = [[UIView alloc] init];
    _cityCoOrds = malloc(sizeof(CGPoint) * _numCities);
    static const CGPoint center = {MAP_RADIUS, MAP_RADIUS};
    
    DHVector * vector = [[DHVector alloc] initWithStartPoint:center endPoint:CGPointMake(MAP_RADIUS, 0)];
    
    CGFloat radian = 2*M_PI / _numCities;
    
    for (int i = 0; i < _numCities; ++i) {
        UIView * cityView = [self createCityViewAtPosition:vector.endPoint];
        [_mapView addSubview:cityView];
        // 旋转向量
        [vector rotateClockwiselyWithRadian:radian];
        _cityCoOrds[i] = vector.endPoint;
    }
    
    _resultShapeLayer = [CAShapeLayer layer];
    _resultShapeLayer.strokeColor = [UIColor redColor].CGColor;
    _resultShapeLayer.fillColor = [UIColor clearColor].CGColor;
    _resultShapeLayer.lineWidth = 2;
    [_mapView.layer addSublayer:_resultShapeLayer];
}

- (void)calculateBestPossibleRoute
{
//    for (int i = 0; i < _numCities; ++i) {
//        int city1Idx = i;
//        int city2Idx = i+1;
//        if (i + 1 == _numCities) {
//            city2Idx = 0;
//        }
//        CGPoint city1 = _cityCoOrds[city1Idx];
//        CGPoint city2 = _cityCoOrds[city2Idx];
//        CGFloat distance = [self distanceFromCity:city1 toCity:city2];
//        _bestPossibleRoute += distance;
//    }
    CGPoint city1 = _cityCoOrds[0];
    CGPoint city2 = _cityCoOrds[1];
    CGFloat distance = [self distanceFromCity:city1 toCity:city2];
    _bestPossibleRoute = distance * _numCities;
}

- (UIView *)createCityViewAtPosition:(CGPoint)position
{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    view.center = position;
    view.backgroundColor = [UIColor darkGrayColor];
    view.layer.cornerRadius = 2;
    return view;
}

@end
