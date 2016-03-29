//
//  ViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "ViewController.h"
#import "Twitter/TWTweetComposeViewController.h"
#import <Firebase/Firebase.h>
#import "QSStrings.h"

@interface ViewController ()

@property (strong, nonatomic) Firebase* currentSegment;
@property (strong, nonatomic) NSMutableDictionary* lastpoints;

@end

@implementation ViewController
@synthesize mainImage;
@synthesize tempDrawImage;



-(void)loadBG{
    Firebase *checkImg =  [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasBGURL"]];
    
    [checkImg observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
       // NSLog(@"%@ -> %@", snapshot.value);
        
        if (snapshot.value != [NSNull null]) {
            
            NSData * data = [[NSData alloc]initWithBase64EncodedString:snapshot.value options:NSDataBase64DecodingIgnoreUnknownCharacters];
            
            UIImage *toputImg = [UIImage imageWithData:data];
            [self.mainImage setImage:toputImg];
        }
    }];

}

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    self.lastpoints = [[NSMutableDictionary alloc] init];
    [self setupFirebaseListeners];
    [super viewDidLoad];
    
    [self loadBG];
    
     
    
    
    
}

- (void)viewDidUnload
{
   // [self setMainImage:nil];
   // [self setTempDrawImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)pencilPressed:(id)sender {
    
    UIButton * PressedButton = (UIButton*)sender;
    
    switch(PressedButton.tag)
    {
        case 0:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 1:
            red = 105.0/255.0;
            green = 105.0/255.0;
            blue = 105.0/255.0;
            break;
        case 2:
            red = 255.0/255.0;
            green = 0.0/255.0;
            blue = 0.0/255.0;
            break;
        case 3:
            red = 0.0/255.0;
            green = 0.0/255.0;
            blue = 255.0/255.0;
            break;
        case 4:
            red = 102.0/255.0;
            green = 204.0/255.0;
            blue = 0.0/255.0;
            break;
        case 5:
            red = 102.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
        case 6:
            red = 51.0/255.0;
            green = 204.0/255.0;
            blue = 255.0/255.0;
            break;
        case 7:
            red = 160.0/255.0;
            green = 82.0/255.0;
            blue = 45.0/255.0;
            break;
        case 8:
            red = 255.0/255.0;
            green = 102.0/255.0;
            blue = 0.0/255.0;
            break;
        case 9:
            red = 255.0/255.0;
            green = 255.0/255.0;
            blue = 0.0/255.0;
            break;
    }
}

- (IBAction)eraserPressed:(id)sender {
    
    red = 255.0/255.0;
    green = 255.0/255.0;
    blue = 255.0/255.0;
    opacity = 1.0;
}

- (IBAction)reset:(id)sender {
    
    self.mainImage.image = nil;
    self.tempDrawImage.image = nil;
    Firebase *f = [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasURL"]];
    [f removeValue];
    
    Firebase *fi = [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasBGURL"]];
    [fi removeValue];
    
}

- (IBAction)friends:(id)sender{}

- (IBAction)settings:(id)sender {
    
   // [self prepareForSegueSettings:segue sender:self]
}

- (IBAction)save:(id)sender {
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Save to Camera Roll", @"Tweet it!", @"Cancel", nil];
    [actionSheet showInView:self.view];
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        Class tweeterClass = NSClassFromString(@"TWTweetComposeViewController");
        
        if(tweeterClass != nil) {   // check for Twitter integration
            
            // check Twitter accessibility and at least one account is setup
            if([TWTweetComposeViewController canSendTweet]) {
                
                UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO,0.0);
                [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
                UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                TWTweetComposeViewController *tweetViewController = [[TWTweetComposeViewController alloc] init];
                // set initial text
                [tweetViewController setInitialText:@"Check out this drawing I made using Doodle Chat with my Friend! :"];
                
                // add image
                [tweetViewController addImage:SaveImage];
                tweetViewController.completionHandler = ^(TWTweetComposeViewControllerResult result) {
                    if(result == TWTweetComposeViewControllerResultDone) {
                        // the user finished composing a tweet
                    } else if(result == TWTweetComposeViewControllerResultCancelled) {
                        // the user cancelled composing a tweet
                    }
                    [self dismissViewControllerAnimated:YES completion:nil];
                };
                
                [self presentViewController:tweetViewController animated:YES completion:nil];
            } else {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You can't send a tweet right now, make sure you have at least one Twitter account setup and your device is using iOS5" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"You must upgrade to iOS5.0 in order to send tweets from this application" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
        
    } else if(buttonIndex == 0) {
        
        UIGraphicsBeginImageContextWithOptions(self.mainImage.bounds.size, NO, 0.0);
        [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height)];
        UIImage *SaveImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(SaveImage, self,@selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Image could not be saved.Please try again"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Image was successfully saved in photoalbum"  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Close", nil];
        [alert show];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    //    lastPoint = [touch locationInView:self.view];
    lastPoint = [touch locationInView:self.tempDrawImage];
    Firebase *f = [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasURL"]];
    self.currentSegment = [f childByAutoId];
    
}

- (void) setupFirebaseListeners {
    Firebase* readf = [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasURL"]];
    // new data
    [readf observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *psnapshot) {
        [psnapshot.ref observeEventType:FEventTypeChildAdded withBlock:^(FDataSnapshot *snapshot) {
            if([snapshot.value[0] intValue] == -1) {
                [self.lastpoints removeObjectForKey:psnapshot.name];
            }
            else {
                [self drawArray:snapshot.value forPname:psnapshot.name];
            }
        }];
    }];
    
    
    [readf observeEventType:FEventTypeChildRemoved withBlock:^(FDataSnapshot *snapshot) {
        self.mainImage.image = nil;
        self.tempDrawImage.image = nil;
    }];
}

- (void) drawArray:(NSArray *)fpoint forPname:(NSString *)pname{
    // when a new segment is created, clear this value out
    if(self.lastpoints[pname] != nil) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        NSLog(@"last: %f, %f", [self.lastpoints[pname][0] floatValue], [self.lastpoints[pname][1] floatValue]);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), [self.lastpoints[pname][0] floatValue], [self.lastpoints[pname][1] floatValue]);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), [fpoint[0] floatValue], [fpoint[1] floatValue]);
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), [fpoint[6] floatValue] );
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), [fpoint[2] floatValue], [fpoint[3] floatValue], [fpoint[4] floatValue], 1.0);
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
        
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        [self.tempDrawImage setAlpha:[fpoint[5] floatValue]];
        UIGraphicsEndImageContext();
    }
    self.lastpoints[pname] = fpoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    //CGPoint currentPoint = [touch locationInView:self.view];
    
    CGPoint currentPoint = [touch locationInView:self.tempDrawImage];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
    
    [[self.currentSegment childByAutoId] setValue:
     [NSArray arrayWithObjects:
      [NSNumber numberWithFloat:currentPoint.x],
      [NSNumber numberWithFloat:currentPoint.y],
      [NSNumber numberWithFloat:red],
      [NSNumber numberWithFloat:green],
      [NSNumber numberWithFloat:blue],
      [NSNumber numberWithFloat:opacity],
      [NSNumber numberWithFloat:brush],
      
      nil]];
    
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    //self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    
    [[self.currentSegment childByAutoId] setValue:
     [NSArray arrayWithObjects:
      [NSNumber numberWithInt:-1],
      nil]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"canvasToSettings"]){
        
        SettingsViewController * settingsVC = (SettingsViewController *)segue.destinationViewController;
        settingsVC.delegate = self;
        settingsVC.brush = brush;
        settingsVC.opacity = opacity;
        settingsVC.red = red;
        settingsVC.green = green;
        settingsVC.blue = blue;
    }
    
    
    
    
}

#pragma mark - SettingsViewControllerDelegate methods

- (void)closeSettings:(id)sender {
    
    brush = ((SettingsViewController*)sender).brush;
    opacity = ((SettingsViewController*)sender).opacity;
    red = ((SettingsViewController*)sender).red;
    green = ((SettingsViewController*)sender).green;
    blue = ((SettingsViewController*)sender).blue;
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end