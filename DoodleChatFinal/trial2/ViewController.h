//
//  ViewController.h
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"

#import "listOfFriendsViewController.h"

@interface ViewController : UIViewController <SettingsViewControllerDelegate, UIActionSheetDelegate> {
    
    CGPoint lastPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
}


@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;

- (IBAction)pencilPressed:(id)sender;
- (IBAction)eraserPressed:(id)sender;
- (IBAction)reset:(id)sender;
- (IBAction)settings:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)friends:(id)sender;
- (IBAction)backButton:(id)sender;

@end
