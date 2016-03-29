//
//  listOfFriendsViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/29/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "listOfFriendsViewController.h"
#import <Firebase/Firebase.h>

@interface listOfFriendsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentLoggedInUser;
- (IBAction)logOutButton:(id)sender;
@property (nonatomic) Firebase *friendsOfLoggedInUser;
@property (weak, nonatomic) NSString *loggedInUsersNameLocal;

@property (nonatomic,strong) NSMutableArray *data;

@end


@implementation listOfFriendsViewController

- (IBAction)logOutButton:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggedInUserName"];
      [[NSUserDefaults standardUserDefaults]synchronize];
      [self performSegueWithIdentifier:@"loggingOffUser" sender:self];
    
    
}
static NSString *cellIdentifier;







//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    //link the CloudViewController with its View
//    NSBundle *appBundle = [NSBundle mainBundle];
//    
//    self = [super initWithNibName:@"FoodTruckViewController" bundle:appBundle];
//    if (self) {
//        self.myTableView.delegate = self;
//        self.myTableView.dataSource = self;
//        [self loadDataFromFirebase];
//        [self.myTableView reloadData];
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self.myTableView reloadData];
//}
//
//-(void)loadDataFromFirebase
//{
//    self.data = [[NSMutableArray alloc] init];
//    Firebase* listRef = [[Firebase alloc] initWithUrl:@"https://doodlechattrial.firebaseio.com/usernames/a/friends"];
//    [listRef observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
//        NSLog(@"%@", snapshot.value);
//        [self.data addObject:snapshot.value];
//    }];
//}
//
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.data count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    [cell.textLabel setText:[self.data objectAtIndex:indexPath.row]];
//    
//    return cell;
//}
//
//#pragma mark - Table view delegate
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here. Create and push another view controller.
//    /*
//     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
//     // ...
//     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
//     */
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *loggedinusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggedInUserName"];
    if (loggedinusername) {
        self.currentLoggedInUser.text = [NSString stringWithString: loggedinusername];
        self.loggedInUsersNameLocal = loggedinusername;
    }
    
    NSString *userURL = [@"https://doodlechattrial.firebaseio.com/usernames/" stringByAppendingString:loggedinusername];
    NSString *usersFriendsURL = [userURL stringByAppendingString:@"/friends"];
    
    
    self.friendsOfLoggedInUser = [[Firebase alloc]initWithUrl:usersFriendsURL];
    
    
    
    self.data = [[NSMutableArray alloc] init];
    [self loadDataFromFirebase];
    [self.myTableView reloadData];
    NSLog(@"%lu", (unsigned long)[self.data count]);
    //self.myTableView.delegate = self;
    //self.myTableView.dataSource = self;
}

-(void)loadDataFromFirebase
{
    
    [self.friendsOfLoggedInUser observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
        NSLog(@"%@", snapshot.value);
        [self.data addObject:snapshot.name];
         NSLog(@"%lu", (unsigned long)[self.data count]);
        [self.myTableView reloadData];
        
        
    }];
    
    cellIdentifier = @"rowCell";
    
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    
    NSLog(@"%@",self.data);
    
}



//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    
//    self.data = [[NSMutableArray alloc]init];
//    
//    [self.data addObject:@"apple"];
//    [self.data addObject:@"banana"];
//    
//    Firebase *pairingURL = [[Firebase alloc]initWithUrl:@"https://doodlechattrial.firebaseio.com/usernames/a/friends"];
//    [pairingURL observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *psnapshot) {
////        [[psnapshot.ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot)  {
//    
//       // NSLog(@"%@",[psnapshot.value stringValue]);
//        NSString *thisGuy = psnapshot.name;
//        NSLog(@"%@",thisGuy);
//        [self.data addObject:thisGuy ];
//        NSLog(@"%@",@"value should be added");
//    }];
//    
//    [self.data addObject:@"kiwi"];
//    NSLog(@"%@",self.data);
//
//    
//    
//	
////    self.data = [[NSMutableArray alloc]initWithObjects:@"Apple",@"Banana",@"Peach",@"Grape",@"Strawberry",@"Watermelon",nil];
//
//    cellIdentifier = @"rowCell";
//    
//    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
//    
//}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    UIImage *placeholderImage = [UIImage imageNamed:@"whitebg.png"];         cell.imageView.image = placeholderImage;
    
    
    //------attempting---thumbnail---canvas-------
    
    NSMutableDictionary* lastpoints;
    lastpoints = [[NSMutableDictionary alloc] init];
    
  //  UIImageView *tempImage;
    NSString * cellCanvasName;
    
    
    NSComparisonResult result = [[self.data objectAtIndex:indexPath.row] compare:self.loggedInUsersNameLocal];
    
    if (result == NSOrderedAscending) // stringOne < stringTwo
        cellCanvasName = [[self.data objectAtIndex:indexPath.row]stringByAppendingString:[self.currentLoggedInUser text]];
    
    if (result == NSOrderedDescending) // stringOne > stringTwo
        cellCanvasName = [[self.currentLoggedInUser text]stringByAppendingString:[self.data objectAtIndex:indexPath.row]];
    
    
    
    
    
    
    Firebase* readf = [[Firebase alloc] initWithUrl:[@"https://doodlechattrial.firebaseio.com/canvases/" stringByAppendingString:[cellCanvasName stringByAppendingString:@"/strokes"]]] ;
    //[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasURL"]];
    // new data
    [readf observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *psnapshot) {
        [psnapshot.ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            if([snapshot.value[0] intValue] == -1) {
                [lastpoints removeObjectForKey:psnapshot.name];
            }
            else {
//                [self drawArray:snapshot.value forPname:psnapshot.name];
                
                if(lastpoints[psnapshot.name] != nil) {
                    
                    
                    
                    
                    
                    UIGraphicsBeginImageContext(self.view.frame.size);
                    [cell.imageView.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
                    NSLog(@"last: %f, %f", [lastpoints[psnapshot.name][0] floatValue], [lastpoints[psnapshot.name][1] floatValue]);
                    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), [lastpoints[psnapshot.name][0] floatValue], [lastpoints[psnapshot.name][1] floatValue]);
                    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [snapshot.value[0] floatValue], [snapshot.value[1] floatValue]);
                    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
                    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [snapshot.value[6] floatValue] );
                    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), [snapshot.value[2] floatValue], [snapshot.value[3] floatValue], [snapshot.value[4] floatValue], 1.0);
                    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
                    
                    CGContextStrokePath(UIGraphicsGetCurrentContext());
                    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
                    [cell.imageView setAlpha:[snapshot.value[5] floatValue]];
                    UIGraphicsEndImageContext();
                }
             
                lastpoints[psnapshot.name] = snapshot.value;
                
                
            }
        }];
    }];
    
    
   
    
    
    //------------------XXXX----------------------
    
    
    
    
    
    
    
    
    
    
    
    
    
    cell.textLabel.text = [self.data objectAtIndex:indexPath.row];
//    UIImage *image = [UIImage imageNamed: @"Eraser.png"];
//    [cell.imageView setImage:image] ;
    

   
   
    
    
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * nameOfCanvas;
    
    //[self.data objectAtIndex:indexPath.row];
        NSComparisonResult result = [[self.data objectAtIndex:indexPath.row] compare:[self.currentLoggedInUser text]];
        
        if (result == NSOrderedAscending) // stringOne < stringTwo
            nameOfCanvas = [[self.data objectAtIndex:indexPath.row]stringByAppendingString:[self.currentLoggedInUser text]];
        
        if (result == NSOrderedDescending) // stringOne > stringTwo
       nameOfCanvas = [[self.currentLoggedInUser text]stringByAppendingString:[self.data objectAtIndex:indexPath.row]];
    
    NSString *canvasUltimatePath = [@"https://doodlechattrial.firebaseio.com/canvases/" stringByAppendingString: [nameOfCanvas stringByAppendingString:@"/strokes"] ];
    NSLog(@"%@",canvasUltimatePath);
    
    [[NSUserDefaults standardUserDefaults]setValue:canvasUltimatePath forKey:@"CanvasURL"];
    
    NSString *canvasBGImagePath = [@"https://doodlechattrial.firebaseio.com/canvases/" stringByAppendingString: [nameOfCanvas stringByAppendingString:@"/bgimg"] ];
    //NSLog(@"%@",canvasUltimatePath);
    
    [[NSUserDefaults standardUserDefaults]setValue:canvasBGImagePath forKey:@"CanvasBGURL"];
    
    
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [self performSegueWithIdentifier:@"canvasNameReady" sender:self];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end