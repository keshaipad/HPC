//
//  ViewController.m
//  HumanPatternCycle
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "ViewController.h"
#import "TimeLineViewControl.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *times = @[@"sun",@"mon",@"tue",@"wed",@"thr",@"fri"];
    NSArray *descriptions = @[@"state 1",@"state 2",@"state 3",@"state 4",@"state 6",@"state 7"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                                           andTimeDescriptionArray:descriptions
                                                                  andCurrentStatus:times.count
                                                                          andFrame:CGRectMake(100, 240, self.view.frame.size.width - 60, 400)];
    timeline.center = self.view.center;
    [self.view addSubview:timeline];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
