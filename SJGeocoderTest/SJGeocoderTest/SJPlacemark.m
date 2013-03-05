//
//  SJPlacemark.m
//  Departing
//
//  Created by Scott Jackson on 28/02/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import "SJPlacemark.h"

@implementation SJPlacemark

- (id)initWithPlacemark:(CLPlacemark *)placemark {
	self = [super initWithPlacemark:placemark];
	if (self) {
		_backupName = placemark.name;
	}
	return self;
}

- (NSString *)name {
	if ([super name]) {
		return [super name];
	}
	return _backupName;
}

- (void)setName:(NSString *)name {
	_backupName = name;
}

@end
