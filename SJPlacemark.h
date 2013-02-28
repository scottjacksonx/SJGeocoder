//
//  SJPlacemark.h
//  Departing
//
//  Created by Scott Jackson on 28/02/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface SJPlacemark : CLPlacemark {
	NSString *_backupName;
}

- (NSString *)name;
- (void)setName:(NSString *)name;

@end
