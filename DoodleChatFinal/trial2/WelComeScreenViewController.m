//
//  WelComeScreenViewController.m
//  trial2
//
//  Created by Akshay Yadav on 5/7/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "WelComeScreenViewController.h"

@interface WelComeScreenViewController ()

@end

@implementation WelComeScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *loginStatus = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInUserName"];
    if (loginStatus == @"nobodyisloggedin") {
        <#statements#>
    }
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
