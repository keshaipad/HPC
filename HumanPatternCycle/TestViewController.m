//
//  TestViewController.m
//  HumanPatternCycle
//
//  Created by Admin on 09.03.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "TestViewController.h"
#import "TimeLineViewControl.h"

@interface TestViewController ()

@end
@implementation TestViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *times = @[@"sun",@"mon",@"tue",@"wed",@"thr",@"fri",@"sat"];
    NSArray *descriptions = @[@"state 1",@"state 2",@"state 3",@"state 4",@"very very long and very very detailed description 0f state 5",@"state 6",@"state 7"];
    TimeLineViewControl *timeline = [[TimeLineViewControl alloc] initWithTimeArray:times
                                                           andTimeDescriptionArray:descriptions
                                                                  andCurrentStatus:4
                                                                          andFrame:CGRectMake(50, 120, self.view.frame.size.width - 30, 200)];
    timeline.center = self.view.center;
    [self.view addSubview:timeline];
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
