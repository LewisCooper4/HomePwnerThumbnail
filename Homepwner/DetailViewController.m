//
//  DetailViewController.m
//  Homepwner
//
//  Created by Lewis Cooper on 2/16/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"

@implementation DetailViewController

@synthesize item;
@synthesize dismissBlock;



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [nameField setText:[item itemName]];
    [serialNumberField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        UIImage *imageToDisplay = [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        [imageView setImage:imageToDisplay];
    }
    else {
        [imageView setImage:nil];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialNumberField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    
    return nil;
}


- (id)initForNewItem:(BOOL)isNew
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    
    return self;
}


- (void) save:(id)sender
{
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void) cancel:(id)sender
{
    [[BNRItemStore sharedStore] removeItem:item];
    //[[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void) setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (void)viewDidUnload {
    nameField = nil;
    serialNumberField = nil;
    valueField = nil;
    dateLabel = nil;
    imageView = nil;
    [super viewDidUnload];
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    }
    else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    
    [[self view] setBackgroundColor:clr];
    
    //[[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}


- (IBAction)takePicture:(id)sender {
    
    if ([imagePickerPopover isPopoverVisible]) {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    //[self presentViewController:imagePicker animated:YES completion:nil];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        
        [imagePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    }
    else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    if (oldKey) {
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [item setThumbnailDataFromImage:image];
    
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef newUniqueIDString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueID);
    
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    [[BNRImageStore sharedStore] setImage:image forKey:[item imageKey]];
    
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    [imageView setImage:image];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
    
    //[self dismissViewControllerAnimated:YES completion:nil];
}


- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)io
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return YES;
    }
    else {
        return (io == UIInterfaceOrientationPortrait);
    }
}


- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}


- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}


@end
