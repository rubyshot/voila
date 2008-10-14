//
//  DogViewController.m
//  active_resource
//
//  Created by vickeryj on 8/21/08.
//  Copyright 2008 Joshua Vickery. All rights reserved.
//

#import "DogViewController.h"
#import "Dog.h"
#import "AddDogViewController.h"
#import "ViewDogController.h"

@interface DogViewController (Private)

- (void) loadDogs;

@end


@implementation DogViewController

@synthesize dogs, addController, tableView , addButton;

- (IBAction) addDogButtonClicked:(id) sender {
	[self.navigationController pushViewController:addController animated:YES];
}

- (void) loadDogs {
	self.dogs = [Dog findAll];
	[tableView reloadData];
}

#pragma mark UIViewController methods

- (void)viewDidLoad {
	self.addController = [[[AddDogViewController alloc] initWithNibName:@"AddDogView" bundle:nil] autorelease];
  self.navigationItem.leftBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated {
	[self loadDogs];
}

#pragma mark UITableViewDataSource methods

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
  
  [super setEditing:editing animated:animated];
  
  [tableView setEditing:editing animated:YES];
  
  if (editing) {
   
    addButton.enabled = NO;
    
  } else {
    
    addButton.enabled = YES;
    
  }
  
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [dogs count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"cellId";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:cellId];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	cell.text = ((Dog *)[dogs objectAtIndex:indexPath.row]).name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ViewDogController * aViewDogController = [[ViewDogController alloc] initWithStyle:UITableViewStyleGrouped];
  aViewDogController.dog = [dogs objectAtIndex:indexPath.row];
  [self.navigationController pushViewController:aViewDogController animated:YES];
  [aViewDogController release];
  
}

- (void)tableView:(UITableView *)aTableView  commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
                                            forRowAtIndexPath:(NSIndexPath *)indexPath { 
  [tableView beginUpdates]; 
  if (editingStyle == UITableViewCellEditingStyleDelete) { 

    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES]; 
    [(Dog *)[dogs objectAtIndex:indexPath.row] destroy];
    [dogs removeObjectAtIndex:indexPath.row];
  } 
  [tableView endUpdates];   
}

#pragma mark cleanup
- (void)dealloc {
  
  [addButton release];
	[tableView release];
	[addController release];
	[dogs release];
	[super dealloc];

}


@end
