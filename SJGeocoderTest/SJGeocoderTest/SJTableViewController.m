//
//  SJTableViewController.m
//  SJGeocoderTest
//
//  Created by Scott Jackson on 5/03/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import "SJTableViewController.h"
#import "SJGeocoder.h"

@interface SJTableViewController ()

@end

@implementation SJTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	
	_segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Geocode", @"+ Local Search"]];
	_segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
	[_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
	self.toolbarItems = @[
					   [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
		[[UIBarButtonItem alloc] initWithCustomView:_segmentedControl],
		[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
		];
	self.navigationController.toolbarHidden = NO;
	
	_segmentedControl.selectedSegmentIndex = 1;
	_searchBar.text = @"Apple Store";
	[self segmentedControlValueChanged:_segmentedControl];
}

- (void)segmentedControlValueChanged:(UISegmentedControl *)sender {
	self.navigationItem.title = @"Searching...";
	SJGeocoderSearchSource source;
	if (sender.selectedSegmentIndex == 0) {
		source = SJGeocoderSearchSourceGeocoder;
	} else {
		source = SJGeocoderSearchSourceAny;
	}
	
	SJGeocoder *geocoder = [[SJGeocoder alloc] initWithSearchSource:source];
	/*
	 Uncomment the commented code below to search for locations in a specific region.
	 */
//	CLRegion *region = [[CLRegion alloc] initCircularRegionWithCenter:CLLocationCoordinate2DMake(37.75, -122.5)
//															   radius:200000
//														   identifier:@"sanFran"];
	[geocoder geocodeAddressString:_searchBar.text
//						  inRegion:region
				 completionHandler:^(NSArray *placemarks, NSError *error) {
					 if (error) {
						 NSLog(@"error performing geocode: %@", error);
						 self.navigationItem.title = @"Error";
					 } else {
						 self.navigationItem.title = @"Search Results";
						 _results = placemarks;
						 [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
					 }
				 }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[self segmentedControlValueChanged:_segmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
	CLPlacemark *placemark = _results[indexPath.row];
	cell.textLabel.text = placemark.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
