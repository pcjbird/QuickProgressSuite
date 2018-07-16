//
//  ViewController.m
//  QuickProgressSuiteDemo
//
//  Created by pcjbird on 2018/7/6.
//  Copyright © 2018年 Zero Status. All rights reserved.
//

#import "ViewController.h"
#import "QuickProgressViewCircle.h"

@interface ViewController ()

- (IBAction)OnClick:(id)sender;
@property (weak, nonatomic) IBOutlet QuickProgressViewCircle *progressView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.progressView setProgress:0.9f animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)OnClick:(id)sender {
    [self.progressView setProgress:(1.0f - self.progressView.progress) animated:YES];
}
@end
