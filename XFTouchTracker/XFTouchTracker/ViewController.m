//
//  ViewController.m
//  XFTouchTracker
//
//  Created by apple on 16/1/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "ViewController.h"
#import "XFDrowView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *myButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.myButton addTarget:self action:@selector(touchme) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) touchme
{
    NSLog(@"%@", @"touchme by upinside!");
}

- (void) loadView
{
    //self.view =[[XFDrowView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
}

@end
