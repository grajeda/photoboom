//
//  ViewController.m
//  PhotoBoom
//
//  Created by Perry Bigley on 1/20/15.
//  Copyright (c) 2015 PJBytes. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

CGFloat lastScale;
CGFloat lastX;
CGFloat lastY;

BOOL isPad() {
#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //[[self view] bringSubviewToFront: _cameraButton];
    //[[self view] bringSubviewToFront: _photoLibraryButton];
    
    //[[self view] sendSubviewToBack:self.imageView];
    _saveButton.enabled = FALSE;
    _saveButton.hidden = TRUE;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"Device has no camera"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    }
    
    //TODO: Replace with actual user info, collected from the user
    //Add Dummy Parse user information
    
    PFUser *user = [PFUser user];
    user.username = @"Techlifter";
    user.password = @"123ABC";
    user.email = @"techlifter@perryjoshua.com";
    
    // other fields can be set if you want to save more information
    user[@"phone"] = @"520-245-9677";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
        } else {
            NSString *errorString = [error userInfo][@"There was a problem signing in with Parse"];
            // Show the errorString somewhere and let the user try again.
            
            UIAlertView *parseSignInErrorAlertView = [[UIAlertView alloc] initWithTitle:@"Parse Sign In Error"
                                                                  message:errorString
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles: nil];
            
            [parseSignInErrorAlertView show];
        }
    }];
    

    
}


-(IBAction)camBtnClicked:(id)sender{
    
    //initialize the imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    
    //Set the imagePicker delegate to self
    imagePicker.delegate = self;
    
    //Select image from camera
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
    
    //Set the attributes for the Image Picker
    imagePicker.mediaTypes = mediaTypes;
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    imagePicker.allowsEditing = NO;
    
    //Show the Image Picker
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


-(IBAction)showCameraRoll:(id)sender{
 
    //initialize the imagePicker
    imagePicker = [[UIImagePickerController alloc] init];
    
    //Set the imagePicker delegate to self
    imagePicker.delegate = self;
    
    //select from photo library
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    //If this is an iPad, show popover controller camera roll. If iPhone, display the camera roll in a modal view controller.
    if (isPad()) {
     
        _popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [_popover presentPopoverFromRect:CGRectMake(0.0, 0.0, 400.0, 400.0)
                                  inView:self.view
                permittedArrowDirections:UIPopoverArrowDirectionAny
                                animated:YES];
    }else{
        NSArray *mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
        imagePicker.mediaTypes = mediaTypes;
        imagePicker.allowsEditing = NO;
        
        //Show the Image Picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}




-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    //Clear the previous label text, if any.
    _myLabel.text = @"";
    
    NSURL *mediaURL;
    mediaURL = (NSURL *) [info valueForKey:UIImagePickerControllerMediaURL];
    
    NSLog(@"The selected mediaURL is %@", mediaURL);
    
    UIImage *image = (UIImage *) [info valueForKey:UIImagePickerControllerOriginalImage];
    
    NSLog(@"image:%@",image);
    
   // UIImage *newImage = [self burnTextIntoImage:@"BOOM" :image];
    
    //display the image
    self.imageView.image = image;
    
    //Resize the UIImageView to fix the image - NOT WHAT WE WANT. THE IMAGE IS LIKELY TO BE HUGE. BETTER TO MAKE IT FIT A FIXED WIDTH THRESHOLD
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, image.size.width, image.size.height);
    
    //An attempt to resize the imageview. Something that needs tweaking
    /*
     CGSize imageSize = image.size;
    CGSize viewSize = self.imageView.frame.size;
    
    CGFloat correctImageViewHeight = (viewSize.width / imageSize.width) * imageSize.height;
    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x, self.imageView.frame.origin.y, CGRectGetWidth(self.imageView.bounds), correctImageViewHeight);
    
    
    NSLog(@"self.imageView.frame.origin.x: %f",self.imageView.frame.origin.x);
    NSLog(@"self.imageView.frame.origin.y: %f",self.imageView.frame.origin.y);
    NSLog(@"self.imageView.image.size.width: %f",self.imageView.image.size.width);
     */
    
    _myLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.imageView.frame.size.width, 100)];
    //_myLabel.text = @"I \U00002764 BOOM";
    _myLabel.text = @"I \U00002764 \U0001F37A";
    _myLabel.textColor = [UIColor whiteColor];
    _myLabel.textAlignment = NSTextAlignmentCenter;
    
    NSLog(@" ");
    NSLog(@"myLabel.frame.origin.x: %f",_myLabel.frame.origin.x);
    NSLog(@"myLabel.frame.origin.y: %f",_myLabel.frame.origin.y);
    NSLog(@"myLabel.frame.size.width: %f",_myLabel.frame.size.width);
    
    _myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:50];
    [self.imageView addSubview:_myLabel];
    [self.imageView setUserInteractionEnabled:YES];
    
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    UIRotationGestureRecognizer *rotateGesture = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotateGesture:)];
    
    pinchGesture.delegate = self;
    panGesture.delegate = self;
    rotateGesture.delegate = self;
    
    [_myLabel addGestureRecognizer:pinchGesture];
    [_myLabel addGestureRecognizer:panGesture];
    [_myLabel addGestureRecognizer:rotateGesture];
    [_myLabel setUserInteractionEnabled:YES];
    [_myLabel setMultipleTouchEnabled:YES];
    
    /*_myLabel.layer.shadowColor = [[UIColor redColor] CGColor];
    _myLabel.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    _myLabel.layer.shadowOpacity = 1.0f;
    _myLabel.layer.shadowRadius = 1.0f;
     */
                                              
    
    
    /*
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGesture setMinimumNumberOfTouches:1];
    [panGesture setMaximumNumberOfTouches:1];
    
    [myLabel addGestureRecognizer:panGesture];
    panGesture = nil;
    */
    
    
    //save the image captured
    //[self saveImage];
    
    //hide the image picker
    
    _saveButton.enabled = TRUE;
    _saveButton.hidden = FALSE;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    
}

//Method for getting the dimensions of the image containined within the UIImageView, so the UIImageView can be resized
- (CGRect) getFrameOfImage:(UIImageView *) imgView
{
    //if(!imgView.loaded)
    //    return CGRectZero;
    
    CGSize imgSize      = imgView.image.size;
    CGSize frameSize    = imgView.frame.size;
    
    CGRect resultFrame;
    
    if(imgSize.width < frameSize.width && imgSize.height < frameSize.height)
    {
        resultFrame.size    = imgSize;
    }
    else
    {
        float widthRatio  = imgSize.width  / frameSize.width;
        float heightRatio = imgSize.height / frameSize.height;
        
        float maxRatio = MAX (widthRatio , heightRatio);
        NSLog(@"widthRatio = %.2f , heightRatio = %.2f , maxRatio = %.2f" , widthRatio , heightRatio , maxRatio);
        
        resultFrame.size = CGSizeMake(imgSize.width / maxRatio, imgSize.height / maxRatio);
    }
    
    resultFrame.origin  = CGPointMake(imgView.center.x - resultFrame.size.width/2 , imgView.center.y - resultFrame.size.height/2);
    
    return resultFrame;
}


-(IBAction)btnCaptureImageClicked:(id)sender{
    [self createImage:self.imageView];
}

-(UIImage *)createImage:(UIImageView *)imgView
{
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    UIImage *imgs = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(imgs, nil, nil, nil);
    return imgs;
}


-(void)handlePinchGesture:(id)sender
{
    
    UIPinchGestureRecognizer *gestureRecognizer = (UIPinchGestureRecognizer *) sender;
    
    CGFloat scale = [gestureRecognizer scale];
    CGFloat fontSize = _myLabel.font.pointSize;
    float labelWidth = _myLabel.frame.size.width;
    float imageWidth = self.imageView.frame.size.width;
    
    NSLog(@"scale: %f",scale);
    NSLog(@"fontSize: %f",fontSize);
    NSLog(@"");
    
    if ([(UIPinchGestureRecognizer *) sender state] == UIGestureRecognizerStateBegan) {
        //reset the last scale
        lastScale = [gestureRecognizer scale];
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        CGFloat currentScale = [[[gestureRecognizer view].layer valueForKeyPath:@"transform.scale"] floatValue];
        
        const CGFloat kMaxScale = 2.0;
        const CGFloat kMinScale = 1.0;
        
        //new scale is in the range 0-1
        CGFloat newScale = 1 - (lastScale - [gestureRecognizer scale]);
        
        newScale = MIN(newScale, kMaxScale/currentScale);
        newScale = MAX(newScale, kMinScale/currentScale);
        
        [gestureRecognizer  view].transform = CGAffineTransformScale([[sender view] transform], newScale, newScale);
        _myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize*newScale];
        
        lastScale = [gestureRecognizer scale];
        
    }

    

    
    //if (_myLabel.frame.size.width >= self.imageView.frame.size.width) {
    //     _myLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize*scale];
    //}
   
    
    //[[self view] bringSubviewToFront:_myLabel];
    //[_myLabel transform] = CGAffineTransformScale([[sender view] transform], scale, velocity);
    
    //NSString *resultString = [[NSString alloc] initWithFormat:@"Pinch - scale = %f, velocity = %f", scale, velocity];
    //_myLabel.text = resultString;
}

-(void)handlePanGesture:(id)sender
{
    UIPanGestureRecognizer *gestureRecognizer = (UIPanGestureRecognizer *) sender;
    CGPoint translation = [gestureRecognizer translationInView:self.view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        //Figure out where the user is trying to drag the view
        CGPoint newCenter = CGPointMake(gestureRecognizer.view.center.x + translation.x,
                                        gestureRecognizer.view.center.y + translation.y);
        
        NSLog(@"This is the new center: %@", NSStringFromCGPoint(newCenter));
        //NSLog(@"This is the imageView origin: %@", NSStringFromCGPoint(self.imageView.frame.origin));
        //NSLog(@"This is the imageView width: %f", self.imageView.frame.size.width);
        //NSLog(@"This is the imageView height: %f", self.imageView.frame.size.height);
        
        //top left
        float topLX=CGRectGetMinX(self.imageView.frame);
        float topLY=CGRectGetMinY(self.imageView.frame);
        
        NSLog(@"top left: (%f,%f)",topLX,topLY);
        
        //top right
        float topRX=CGRectGetMaxX(self.imageView.frame);
        float topRY=CGRectGetMinY(self.imageView.frame);
        
        NSLog(@"top right: (%f,%f)",topRX,topRY);
        
        //bottom left
        float bottomLX=CGRectGetMinX(self.imageView.frame);
        float bottomLY=CGRectGetMaxY(self.imageView.frame);
        
        NSLog(@"bottom left: (%f,%f)",bottomLX,bottomLY);
        
        //bottom right
        float bottomRX=CGRectGetMaxX(self.imageView.frame);
        float bottomRY=CGRectGetMaxY(self.imageView.frame);
        
        NSLog(@"bottom right: (%f,%f)",bottomRX,bottomRY);
        
        
        
        NSLog(@" ");
        
        /*if (CGRectContainsPoint(self.imageView.frame, newCenter)) {
            gestureRecognizer.view.center = newCenter;
            [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        }*/
        
         NSLog(@"This is the scale of the image: %f", self.imageView.image.scale);
        
        CGFloat imageTopLeft = (self.imageView.frame.size.width - (self.imageView.image.size.width * self.imageView.image.scale))/2;
        NSLog(@"This is the starting x of the image: %f", imageTopLeft);
        //CGFloat imageTopRight
        //CGFloat imageBottomLeft
        //CGFloat imageBottomRight
    
        //Only allow the movement if the center remains withing the imageView
        if ((newCenter.y + topRY) >= topRY
            && (newCenter.y + topRY) <= bottomRY
            && (newCenter.x + topLX) >= topLX
            && (newCenter.x + topLX) <= bottomRX) {
            gestureRecognizer.view.center = newCenter;
            [gestureRecognizer setTranslation:CGPointMake(0, 0) inView:self.view];
        }
    }
    
    
    /*
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    
    //reset the last x and y
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastX = [[sender view] center].x;
        lastY = [[sender view] center].y;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        //Figure out where the user is trying to drag the view
        CGPoint newCenter = CGPointMake(_myLabel.center.x, _myLabel.center.y +translatedPoint.y);
        
        if (CGRectContainsPoint(self.imageView.frame, newCenter)) {
            [[sender view] setCenter:newCenter];
            
            lastX = [[sender view] center].x;
            lastY = [[sender view] center].y;
        }
    }
    */
    
    /*
    //reset the last x and y
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastX = [[sender view] center].x;
        lastY = [[sender view] center].y;
    }
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGPoint newPoint = CGPointMake([[sender view] center].x, [[sender view] center].y);
        
        translatedPoint = CGPointMake(lastX+translatedPoint.x, lastY+translatedPoint.y);
        
        NSLog(@"This is the translatedPoint: %@", NSStringFromCGPoint(translatedPoint));
        
        if (CGRectContainsPoint(self.imageView.frame, translatedPoint)) {
            //translatedPoint = CGPointMake(lastX+translatedPoint.x, lastY+translatedPoint.y);
            [[sender view] setCenter:translatedPoint];
            
            lastX = [[sender view] center].x;
            lastY = [[sender view] center].y;
        }
    }
     */
    
    /*
    CGPoint translatedPoint = [gestureRecognizer translationInView:self.view];
    
    //reset the last x and y
    if([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        lastX = [[sender view] center].x;
        lastY = [[sender view] center].y;
    }
    
    
    translatedPoint = CGPointMake(lastX+translatedPoint.x, lastY+translatedPoint.y);
    [[sender view] setCenter:translatedPoint];
    
    
    lastX = [[sender view] center].x;
    lastY = [[sender view] center].y;
    */
    
    
    /*
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.imageView];
    CGFloat firstX;
    CGFloat firstY;
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {

        firstX = [[sender view] center].x;
        firstY = [[sender view] center].y;
        NSLog(@"x point: %f",firstX);
        NSLog(@"y point: %f",firstY);
        
        NSLog(@"translatedPoint point: %@",NSStringFromCGPoint(translatedPoint));
    }
     */
    
    /*
     if (([sender view].center.y+translatedPoint.y)  >= self.imageView.frame.origin.y && ([sender view].center.y+translatedPoint.y)  <= (self.imageView.frame.origin.y + self.imageView.frame.size.height)) {
     translatedPoint = CGPointMake((.5*self.view.frame.size.width), [sender view].center.y+translatedPoint.y);
     }else{
     translatedPoint = CGPointMake((.5*self.view.frame.size.width), [sender view].center.y);
     }
     */
    
    /*
    translatedPoint = CGPointMake(firstX+(.5*self.view.frame.size.width), firstY+translatedPoint.y);
    NSLog(@"post-translatedPoint point: %@",NSStringFromCGPoint(translatedPoint));
    NSLog(@"");
    
    
        [[sender view] setCenter:translatedPoint];
*/
    
}

-(void)handleRotateGesture:(id)sender
{
    UIRotationGestureRecognizer *gestureRecognizer = (UIRotationGestureRecognizer *) sender;
    gestureRecognizer.view.transform = CGAffineTransformRotate(gestureRecognizer.view.transform, gestureRecognizer.rotation);
    gestureRecognizer.rotation = 0;
}

-(BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    //user did not select image/video. hide the image picker
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//Take a passed-in image and string and "burn" the string into the image
- (UIImage *)burnTextIntoImage:(NSString *)text :(UIImage *)img {
    
    NSLog(@"burnTextIntoImage was called with text: %@",text);
    
    UIGraphicsBeginImageContext(img.size);
    //Set the ImageContext to the size of the incoming image (image size, opaque, scale (default))
    //UIGraphicsBeginImageContextWithOptions(img.size,NO,0.0);

    
    //Generate a rectangle matching the incoming image dimensions
    CGRect myRectangle = CGRectMake(0,0, img.size.width, img.size.height);
    [img drawInRect:myRectangle];
    
    //Set the text color (default to White...may make this variable in the future)
    [[UIColor whiteColor] set];
   
    //Set the default font size (default to 14...may make this variable in the future)
    NSInteger fontSize = 300;
    if ( [text length] > 200 ) {
        fontSize = 50;
    }
    
    //Set the font to bold
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
    
    //[UIFont boldSystemFontOfSize: fontSize];
    //[UIFont fontWithName:@"HelveticaNeue-Thin" size:fontSize];
    
    //Make a copy of the default paragraph stle
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    //Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    //Create a dictionary to contain the style selections
    NSDictionary *attributes = @{NSFontAttributeName: font,
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    
    
    //[text drawInRect:myRectangle withAttributes:attributes];
    [text drawInRect:myRectangle withFont:font lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    
    
    //Extract the image from the ImageContext
    UIImage *theImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //Close the ImageContect
    UIGraphicsEndImageContext();
    
    //Return the finished image to the caller
    return theImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
