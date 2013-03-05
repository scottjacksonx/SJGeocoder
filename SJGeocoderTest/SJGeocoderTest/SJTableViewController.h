//
//  SJTableViewController.h
//  SJGeocoderTest
//
//  Created by Scott Jackson on 5/03/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SJTableViewController : UITableViewController<UISearchBarDelegate> {
	NSArray *_results;
	UISegmentedControl *_segmentedControl;
	IBOutlet UISearchBar *_searchBar;
}

@end
