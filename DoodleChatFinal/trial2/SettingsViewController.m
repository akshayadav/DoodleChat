//
//  SettingsViewController.m
//  trial2
//
//  Created by Akshay Yadav on 4/26/14.
//  Copyright (c) 2014 Akshay Yadav. All rights reserved.
//

#import "SettingsViewController.h"
#import "Base64.h"
#import "QSStrings.h"
#import <Firebase/Firebase.h>

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) UIImagePickerController *imagePickerController;

@property (strong, nonatomic) NSURL *userImageURL;

@property (nonatomic) NSMutableArray *capturedImages;
@property BOOL didPictureUploaded;

@end

@implementation SettingsViewController
@synthesize brushControl;
@synthesize opacityControl;
@synthesize brushPreview;
@synthesize opacityPreview;
@synthesize brushValueLabel;
@synthesize opacityValueLabel;
@synthesize brush;
@synthesize opacity;
@synthesize delegate;
@synthesize redControl;
@synthesize greenControl;
@synthesize blueControl;
@synthesize redLabel;
@synthesize greenLabel;
@synthesize blueLabel;
@synthesize red;
@synthesize green;
@synthesize blue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (IBAction)showImagePickerForPhotoPicker:(id)sender {
    [self showImagePickerForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
}

//- (IBAction)showImagePickerForPhotoPicker:(id)sender {
//    [self showImagePickerForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
//}

-(void) showImagePickerForSourceType: (UIImagePickerControllerSourceType)sourceType{
    
    if (self.imageView.isAnimating)
    {
        [self.imageView stopAnimating];
    }
    
    if (self.capturedImages.count > 0)
    {
        [self.capturedImages removeAllObjects];
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    
    
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
    
}


- (void)finishAndUpdate
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
            //[self encodeToBase64String:self.imageView.image];
        
                NSLog(@"%@",@"Hello");
            NSLog(@"%@",[UIImagePNGRepresentation([self.capturedImages objectAtIndex:0]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
            
            
                Firebase *checkImg =  [[Firebase alloc] initWithUrl:[[NSUserDefaults standardUserDefaults]stringForKey:@"CanvasBGURL"]];
            
            [checkImg setValue:[UIImagePNGRepresentation([self.capturedImages objectAtIndex:0]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]];
            
            
                NSLog(@"%@",@"world");
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = self.capturedImages;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
        
        // To be ready to start again, clear the captured images array.
        [self.capturedImages removeAllObjects];
    }
    
    self.imagePickerController = nil;
    
//    NSData* data = UIImageJPEGRepresentation(self.imageView.image, 1.0f);
//    NSString *strEncoded = [Base64 encode:data];
//    NSLog(@"%@",strEncoded);
    
    
}
//
//- (NSString *)encodeToBase64String:(UIImage *)image {
//    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
//    NSLog(@"%@",@"Hello");
//    NSLog(@"%@",[UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength]);
//
//        NSLog(@"%@",@"WORLD");
//}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSURL* imageURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    NSLog(@"THIS IS URL %@", imageURL);
    
    NSLog(@"THIS IS Path %@", [imageURL path]);
    
    
    self.userImageURL = imageURL;
    
    self.didPictureUploaded = YES;
    
    [self.capturedImages addObject:image];
    
    [self finishAndUpdate];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.capturedImages = [[NSMutableArray alloc] init];
    
    self.opacityValueLabel.hidden = TRUE;
   // self.opacityPreview.hidden = TRUE;
    self.opacityControl.hidden = TRUE;
    
    
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setBrushControl:nil];
    [self setOpacityControl:nil];
    [self setBrushPreview:nil];
    [self setOpacityPreview:nil];
    [self setBrushValueLabel:nil];
    [self setOpacityValueLabel:nil];
    [self setRedControl:nil];
    [self setGreenControl:nil];
    [self setBlueControl:nil];
    [self setRedLabel:nil];
    [self setGreenLabel:nil];
    [self setBlueLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    
    // ensure the values displayed are the current values
    
    int redIntValue = self.red * 255.0;
    self.redControl.value = redIntValue;
    [self sliderChanged:self.redControl];
    
    int greenIntValue = self.green * 255.0;
    self.greenControl.value = greenIntValue;
    [self sliderChanged:self.greenControl];
    
    int blueIntValue = self.blue * 255.0;
    self.blueControl.value = blueIntValue;
    [self sliderChanged:self.blueControl];
    
    self.brushControl.value = self.brush;
    [self sliderChanged:self.brushControl];
    
    self.opacityControl.value = self.opacity;
    [self sliderChanged:self.opacityControl];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)closeSettings:(id)sender {
    [self.delegate closeSettings:self];
}

- (IBAction)sliderChanged:(id)sender {
    
    UISlider * changedSlider = (UISlider*)sender;
    
    if(changedSlider == self.brushControl) {
        
        self.brush = self.brushControl.value;
        self.brushValueLabel.text = [NSString stringWithFormat:@"%.1f", self.brush];
        
    } else if(changedSlider == self.opacityControl) {
        
        self.opacity = self.opacityControl.value;
        self.opacityValueLabel.text = [NSString stringWithFormat:@"%.1f", self.opacity];
        
    } else if(changedSlider == self.redControl) {
        
        self.red = self.redControl.value/255.0;
        self.redLabel.text = [NSString stringWithFormat:@"Red: %d", (int)self.redControl.value];
        
    } else if(changedSlider == self.greenControl){
        
        self.green = self.greenControl.value/255.0;
        self.greenLabel.text = [NSString stringWithFormat:@"Green: %d", (int)self.greenControl.value];
    } else if (changedSlider == self.blueControl){
        
        self.blue = self.blueControl.value/255.0;
        self.blueLabel.text = [NSString stringWithFormat:@"Blue: %d", (int)self.blueControl.value];
        
    }
    
    UIGraphicsBeginImageContext(self.brushPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, 1.0);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), 45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.brushPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.opacityPreview.frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(),self.brush);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), self.red, self.green, self.blue, self.opacity);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(),45, 45);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.opacityPreview.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

@end
