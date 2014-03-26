//
//  DetailViewController.h
//  Homepwner
//
//  Created by Lewis Cooper on 2/16/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface DetailViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UIPopoverControllerDelegate>
{
    __weak IBOutlet UITextField *nameField;    
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UITextField *serialNumberField;
    __weak IBOutlet UIImageView *imageView;
    
    UIPopoverController *imagePickerPopover;
}

- (IBAction)backgroundTapped:(id)sender;

- (id) initForNewItem:(BOOL)isNew;

@property (nonatomic, copy) void (^dismissBlock)(void);

@property (nonatomic, strong) BNRItem *item;
- (IBAction)takePicture:(id)sender;

@end
