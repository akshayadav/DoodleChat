//
//  SignUpViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//
#import "SignUpViewController.h"
#import <Firebase/Firebase.h>

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *signUpUsername;
- (IBAction)signUpButton:(id)sender;

@end

@implementation SignUpViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpButton:(id)sender {
    
    NSString *enteredUsername = [self.signUpUsername text];
    
    if (enteredUsername.length == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                          message:@"Username is empty. \n Please enter something!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    
    //     NSLog(@"%lu",(unsigned long)enteredUsername.length);
    
    else{
        
        NSString *parentURLWithSlashAtTheEnd = @"https://doodlechattrial.firebaseio.com/usernames/";
        NSString *childURL = [parentURLWithSlashAtTheEnd stringByAppendingString:enteredUsername];
        
        //    Firebase *delMe = [[Firebase alloc]initWithUrl:@"https://doodlechattrial.firebaseio.com/usernames" ];
        //
        //        [delMe observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        //            NSString *thisname = [snapshot.value childBehaviors] ;
        //                  NSLog(@"%@",thisname);}];
        
        
        
        Firebase *childUserName = [[Firebase alloc]initWithUrl: childURL];
        
        
        
        [childUserName observeSingleEventOfType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            
            //        NSString *thisname =  snapshot.value[@"name"];
            //
            //        NSLog(@"%@",thisname);
            
            
            
            if(snapshot.value != [NSNull null]){
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                                  message:@"Username already exists. \n Please try different username!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [message show];
                NSLog(@"%@",@"exist");}
            
            
            else  {
                //
                //            Firebase *newChildDetails = [[Firebase alloc]initWithUrl: [childURL stringByAppendingString:@"/name"]];
                //
                //            [newChildDetails setValue:enteredUsername];
                
                [childUserName setValue:@{@"name" : enteredUsername}];
                
                
                
                NSLog(@"%@",@"does not exist");
                
                [[NSUserDefaults standardUserDefaults]setValue:enteredUsername forKey:@"loggedInUserName"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                [self performSegueWithIdentifier:@"correctLoginInfoSegue" sender:self];
             
                
            }
            
            
            
            
        }];
        
    }
    
    
    
    
    
    
    
    
    /*
     NSString* url = @"https://SampleChat.firebaseIO-demo.com/users/fred/name/first";
     Firebase* dataRef = [[Firebase alloc] initWithUrl:url];
     [dataRef observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
     NSLog(@"fred's first name is: %@", snapshot.value);
     }];
     */
    
    
    
    
}
@end

