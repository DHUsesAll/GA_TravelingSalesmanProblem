//
//  DHTSPMap.h
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16-4-12.
//  Copyright (c) 2016年 DreamHack. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DHTSPMap : NSObject

@property (nonatomic, assign) CGPoint * cityCoOrds;

- (instancetype)initWithNumberOfCities:(int)numCities;


- (CGFloat)getTourLength:(NSArray *)tour;
// getters
- (UIView *)mapView;
- (CGFloat)bestPossibleRoute;

- (void)renderResult:(NSArray *)genome;

@end
