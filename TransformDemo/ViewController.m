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
-(void) setupUI {
    // View.
    self.targetView = [[CXInteractiveView alloc] initWithFrame:CGRectMake(20, 70, 200, 250)];
    [self.view addSubview:self.targetView];
}

- (IBAction)reset:(id)sender {
    self.targetView.transform = CGAffineTransformIdentity;
}

- (IBAction)undo:(id)sender {
    
}


@end
