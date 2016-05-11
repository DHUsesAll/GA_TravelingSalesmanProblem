//
//  ViewController.m
//  TravelingSalesmanProblem
//
//  Created by DreamHack on 16/5/11.
//  Copyright © 2016年 DreamHack. All rights reserved.
//

#import "ViewController.h"
#import "DHTSPGa.h"
#import "defines.h"

@interface ViewController ()

@property (nonatomic, strong) DHTSPGa * TSPGa;
@property (weak, nonatomic) IBOutlet UITextField *epochTextField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.title = @"巡回销售员";
    [self.view addSubview:self.TSPGa.mapView];
    self.TSPGa.mapView.frame = CGRectMake(10, 10, 0, 0);
    
}
- (IBAction)onEpoch:(id)sender {
    int epoch = [self.epochTextField.text intValue];
    for (int i = 0; i < epoch; ++i) {
        [self.TSPGa epoch];
    }
    self.title = [NSString stringWithFormat:@"巡回销售员：第%d代进化", [self.TSPGa generation]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (DHTSPGa *)TSPGa
{
    if (!_TSPGa) {
        // 种群数量、城市数量一旦修改，就应对应修改杂交率和变异率来使算法工作起来更为顺利
        _TSPGa = [[DHTSPGa alloc] initWithCrossoverRate:CROSSOVER_RATE mutationRate:MUTATION_RATE popSize:POP_SIZE numCities:NUM_CITIES];
    }
    return _TSPGa;
}

\
@end
