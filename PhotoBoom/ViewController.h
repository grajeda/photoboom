//
//  ViewController.h
//  PhotoBoom
//
//  Created by Perry Bigley on 1/20/15.
//  Copyright (c) 2015 PJBytes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate>{

    UIImagePickerController *imagePicker;
    

}

//expose outlet(s) as properties
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *photoLibraryButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *myLabel;

//other properties
@property (strong, nonatomic) UIPopoverController *popover;

//declare action(s)
-(IBAction)camBtnClicked:(id)sender;
-(IBAction)showCameraRoll:(id)sender;
-(IBAction)btnCaptureImageClicked:(id)sender;

@end

