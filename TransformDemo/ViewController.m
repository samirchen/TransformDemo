//
//  ViewController.m
//  TransformDemo
//
//  Created by SamirChen on 7/23/14.
//  Copyright (c) 2014 SamirChen. All rights reserved.
//

#import "ViewController.h"
#import "CXInteractiveView.h"

@interface ViewController ()
@property (nonatomic, strong) CXInteractiveView* targetView;

@end

@implementation ViewController

#pragma mark - View Controller Lifecycle
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Setup UI.
    [self setupUI];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
- (void)setupUI {
    // View.
    self.targetView = [[CXInteractiveView alloc] initWithFrame:CGRectMake(20, 70, 250, 250)];
    [self.view addSubview:self.targetView];
}

- (IBAction)reset:(id)sender {
    
    [UIView animateWithDuration:0.5 animations:^{
        self.targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
    
}

- (IBAction)undo:(id)sender {

}

#pragma mark - Utility
- (void)printFrameOfView:(UIView *)v {
    
    NSLog(@"Frame:(%.2f, %.2f, %.2f, %.2f) Center:(%.2f, %.2f) Bounds:(%.2f, %.2f, %.2f, %.2f)", v.frame.origin.x, v.frame.origin.y, v.frame.size.width, v.frame.size.height, v.center.x, v.center.y, v.bounds.origin.x, v.bounds.origin.y, v.bounds.size.width, v.bounds.size.height);
    
}


@end
