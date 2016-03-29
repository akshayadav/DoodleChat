//
//  listOfFriendsViewController.h
//  trial2
//
//  Created by Akshay Yadav on 4/29/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface listOfFriendsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;

@end
