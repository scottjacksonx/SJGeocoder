//
//  SJGeocoder.m
//  Departing
//
//  Created by Scott Jackson on 28/02/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import "SJGeocoder.h"
#import "SJPlacemark.h"

#define IOS_6_1_OR_ABOVE NSClassFromString(@"MKLocalSearchRequest")

@implementation SJGeocoder

- (id)initWithSearchSource:(SJGeocoderSearchSource)source {
	self = [super init];
	if (self) {
		self.searchSource = source;
		_localSearchPlacemarks = [NSMutableArray new];
		_geocodePlacemarks = [NSMutableArray new];
		if (!IOS_6_1_OR_ABOVE) {
			NSLog(@"iOS version < 6.1, so only using CLGeocoder");
			self.searchSource = SJGeocoderSearchSourceGeocoder;
		}
	}
	return self;
}

- (NSArray *)combinedResults {
	NSMutableArray *combinedResults = [NSMutableArray new];
	for (NSArray *array in @[_localSearchPlacemarks, _geocodePlacemarks]) {
		for (SJPlacemark *p in array) {
			if ([self coordinate:p.location.coordinate isContainedInRegion:_searchRegion]) {
				[combinedResults addObject:p];
			}
		}
	}
	return combinedResults;
}

- (void)geocodeAddressString:(NSString *)addressString inRegion:(CLRegion *)region completionHandler:(CLGeocodeCompletionHandler)completionHandler {
	_searchRegion = region;
	if (self.searchSource & SJGeocoderSearchSourceLocalSearch) {
		MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
		request.naturalLanguageQuery = addressString;
		[request setRegion:MKCoordinateRegionMakeWithDistance(region.center, region.radius, region.radius)];
		_localSearch = [[MKLocalSearch alloc] initWithRequest:request];
	}
	
	[super geocodeAddressString:addressString inRegion:region completionHandler:^(NSArray *placemarks, NSError *geocodeError) {
		if (geocodeError) {
			NSLog(@"error geocoding: %@", geocodeError);
		} else {
			NSMutableArray *tempArray = [NSMutableArray new];
			for (CLPlacemark *p in placemarks) {
				SJPlacemark *placemark = [[SJPlacemark alloc] initWithPlacemark:p];
				placemark.name = p.areasOfInterest[0];
				[tempArray addObject:placemark];
			}
			_geocodePlacemarks = tempArray;
		}
		if (_localSearch) {
			[_localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *localSearchError) {
				if (localSearchError) {
					NSLog(@"error doing local search: %@", localSearchError);
				} else {
					NSMutableArray *tempArray = [NSMutableArray new];
					for (MKMapItem *mapItem in response.mapItems) {
						SJPlacemark *tempPlacemark = [[SJPlacemark alloc] initWithPlacemark:mapItem.placemark];
						tempPlacemark.name = mapItem.name;
						[tempArray addObject:tempPlacemark];
					}
					_localSearchPlacemarks = tempArray;
				}
				completionHandler([self combinedResults], localSearchError);
			}];
		} else {
			completionHandler([self combinedResults], geocodeError);
		}
	}];
}

- (BOOL)coordinate:(CLLocationCoordinate2D)coordinate isContainedInRegion:(CLRegion *)region {
	CLLocationCoordinate2D center = region.center;
	CLLocationCoordinate2D northWestCorner, southEastCorner;
	MKCoordinateRegion coordinateRegion = MKCoordinateRegionMakeWithDistance(region.center, region.radius, region.radius);
	
	northWestCorner.latitude  = center.latitude  - (coordinateRegion.span.latitudeDelta/ 2.0);
	northWestCorner.longitude = center.longitude - (coordinateRegion.span.longitudeDelta / 2.0);
	southEastCorner.latitude  = center.latitude  + (coordinateRegion.span.latitudeDelta  / 2.0);
	southEastCorner.longitude = center.longitude + (coordinateRegion.span.longitudeDelta / 2.0);
	
	if (
		coordinate.latitude  >= northWestCorner.latitude &&
		coordinate.latitude  <= southEastCorner.latitude &&
		
		coordinate.longitude >= northWestCorner.longitude &&
		coordinate.longitude <= southEastCorner.longitude
		) {
		return YES;
	}
	
	return NO;
}

@end
