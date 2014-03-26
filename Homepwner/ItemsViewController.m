//
//  ItemsViewController.m
//  Homepwner
//
//  Created by Lewis Cooper on 2/12/14.
//  Copyright (c) 2014 Lewis Cooper. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "HomepwnerItemCell.h"

@implementation ItemsViewController

- (id) init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        //for (int i = 0; i < 5; i++) {
          //  [[BNRItemStore sharedStore] createItem];
         //}
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
    }
    return self;
}


- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}


- (void) viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"HomepwnerItemCell" bundle:nil];
    
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"HomepwnerItemCell"];
}



- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    //if (!cell) {
      //  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      //reuseIdentifier:@"UITableViewCell"];
    //}
    
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    //[[cell textLabel] setText:[p itemName]];
    
    
    HomepwnerItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialNumberLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText:[NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    
    [[cell thumbnailView] setImage:[p thumbnail]];
    
    return cell;
}

/*
- (UIView *) headerView
{
    if (!headerView) {
        [[NSBundle mainBundle] loadNibNamed:@"headerView" owner:self options:nil];
    }
    
    return headerView;
}
 */

/*
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self headerView];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [[self headerView] bounds].size.height;
}
 */

/*
- (IBAction)toggleEditingMode:(id)sender
{
    if ([self isEditing]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}
 */

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
}

- (void) tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //DetailViewController *detailViewController = [[DetailViewController alloc] init];
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

- (IBAction)addNewItem:(id)sender
{
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    //int lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    //NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //[[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
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


@end
