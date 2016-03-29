//
//  LoginViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "LoginViewController.h"

#import <Firebase/Firebase.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginusername;
- (IBAction)loginUsernameChecker:(id)sender;

@property (strong, nonatomic) NSString *LoggedInUserName;


@end

@implementation LoginViewController


-(NSString *) LoggedInUserName{
    if (!_LoggedInUserName)_LoggedInUserName = [[NSString alloc]init];
    return _LoggedInUserName;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) changeView{
[self performSegueWithIdentifier:@"correctUserLoggedIn" sender:self];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *loggedinusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInUserName"];
    if (loggedinusername) {
        self.LoggedInUserName = [NSString stringWithString: loggedinusername];
        [self performSegueWithIdentifier:@"correctUserLoggedIn" sender:self];
        NSLog(@"%@",@"Reached here");
        //        [self changeView];
    }
    else{
        // Stay oon this page
    }
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
//    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//    [vc setModalPresentationStyle:UIModalPresentationFullScreen];
//    
//    [self presentModalViewController:vc animated:YES];
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

- (IBAction)loginUsernameChecker:(id)sender {
    NSString *loginUserName = [self.loginusername text];
    if (loginUserName.length == 0) {
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
        NSString *childURL = [parentURLWithSlashAtTheEnd stringByAppendingString:loginUserName];
        
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
                
                [[NSUserDefaults standardUserDefaults]setValue:loginUserName forKey:@"loggedInUserName"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                NSLog(@"Path %@",path);
                [self performSegueWithIdentifier:@"correctUserLoggedIn" sender:self];
                
            }
            
            
            else  {
                
                
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                                  message:@"Username does not exists. \n Please try different username!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [message show];
                
                
                
                NSLog(@"%@",@"does not exist");
                
            }
            
            
            
            
        }];
        
        
    }
    
}
@end
