//
//  ItemsViewController.h
//  Homepwner
//
//  Created by Lewis Cooper on 2/12/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailViewController.h"

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
}

//- (UIView *) headerView;
- (IBAction)addNewItem:(id)sender;
//- (IBAction)toggleEditingMode:(id)sender;


@end
