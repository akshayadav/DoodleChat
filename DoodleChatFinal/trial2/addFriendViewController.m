//
//  addFriendViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "addFriendViewController.h"
#import <Firebase/Firebase.h>

@interface addFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *wannabeFriend;
@property (weak,nonatomic) NSString *currentLoggedInUser;
@property (nonatomic,strong) NSMutableArray *usersAlreadyFriends;
@property (nonatomic) Firebase *friendsOfLoggedInUser;


- (IBAction)friendNameEntered:(id)sender;


@end

@implementation addFriendViewController



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadDataFromFirebase
{
    
    [self.friendsOfLoggedInUser observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        [self.usersAlreadyFriends addObject:snapshot.name];
        NSLog(@"%lu", (unsigned long)[self.usersAlreadyFriends count]);
//        [self.myTableView reloadData];
        
        
    }];
    
    //cellIdentifier = @"rowCell";
    
    //[self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    NSLog(@"%@",self.usersAlreadyFriends);
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *loggedinusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInUserName"];
    if (loggedinusername) {
        self.currentLoggedInUser = [NSString stringWithString: loggedinusername];
    }
    
    
    NSString *userURL = [@"https://doodlechattrial.firebaseio.com/usernames/" stringByAppendingString:loggedinusername];
    NSString *usersFriendsURL = [userURL stringByAppendingString:@"/friends"];
    
    
    self.friendsOfLoggedInUser = [[Firebase alloc]initWithUrl:usersFriendsURL];
    
     self.usersAlreadyFriends = [[NSMutableArray alloc]init];
    [self loadDataFromFirebase];
    
    
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)friendNameEntered:(id)sender {
    
    NSString *attemptedFriend = [self.wannabeFriend text];
    
    if (attemptedFriend.length == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                          message:@"Username is empty. \n Please enter something!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
    else{   if ([attemptedFriend isEqualToString:[[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInUserName"]]) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid friend name"
                                                          message:@"Its your own Username, Dude!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        
    }
        
    else{ if([self.usersAlreadyFriends containsObject: attemptedFriend]){
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid friend name"
                                                          message:@"You are already friends with this person."
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
    
    }
    else{
        
        
        NSString *parentURLWithSlashAtTheEnd = @"https://doodlechattrial.firebaseio.com/usernames/";
        NSString *childURL = [parentURLWithSlashAtTheEnd stringByAppendingString:attemptedFriend];
        
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
            
            
            
            if(snapshot.value == [NSNull null]){
                UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Invalid Username"
                                                                  message:@"Username does not exists. \n Please check username!"
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil];
                
                [message show];
                NSLog(@"%@",@" does not exist");}
            
            
            else  {
                
                NSString *usernamesRandom = @"https://doodlechattrial.firebaseio.com/usernames/";
                NSString *userBeforeFrdURL = [usernamesRandom stringByAppendingString: self.currentLoggedInUser];
                NSString * userFrdURL = [userBeforeFrdURL stringByAppendingString:@"/friends/"];
                NSString * ultimateFrdURL = [userFrdURL stringByAppendingString:attemptedFriend];
                NSLog(@"%@",ultimateFrdURL);
                
                //-----Friends DB ---
                
                NSString *FrdBeforeUserURL = [usernamesRandom stringByAppendingString: attemptedFriend];
                
                NSString * FrdUserURL = [FrdBeforeUserURL stringByAppendingString:@"/friends/"];
                
                //-------------------
                
                
                
                NSString *theirCanvasName;
                
                
                NSComparisonResult result = [attemptedFriend compare: self.currentLoggedInUser];
                
                if (result == NSOrderedAscending) // stringOne < stringTwo
                    theirCanvasName = [attemptedFriend stringByAppendingString:self.currentLoggedInUser];
                
                if (result == NSOrderedDescending) // stringOne > stringTwo
                    theirCanvasName = [self.currentLoggedInUser stringByAppendingString:attemptedFriend];
                
                
                Firebase *usersFireBaseFriends = [[Firebase alloc]initWithUrl:userFrdURL];
                
                
               // [usersFireBaseFriends setValue:@{attemptedFriend : theirCanvasName}];
                
                [[usersFireBaseFriends childByAppendingPath:attemptedFriend] setValue:theirCanvasName];
                
                Firebase *FrdFireBaseUser = [[Firebase alloc]initWithUrl:FrdUserURL];
                
                [[FrdFireBaseUser childByAppendingPath:self.currentLoggedInUser] setValue:theirCanvasName];
                
                //[FrdFireBaseUser setValue:@{self.currentLoggedInUser : theirCanvasName}];
                [self performSegueWithIdentifier:@"doneAdding" sender:self];
                
            }
            
            
            
            
        }];
        
        
    
            }
    
        
    }
}

    
     NSLog(@"%@",self.usersAlreadyFriends);
}
@end

