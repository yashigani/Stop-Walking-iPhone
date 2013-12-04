//
//  ViewController.m
//  DemoApp
//
//  Created by taiki on 12/3/13.
//  Copyright (c) 2013 yashigani. All rights reserved.
//

#import "ViewController.h"

#import "SWIManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)showWarningTapped:(id)sender
{
    [SWIManager.sharedManager showWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
