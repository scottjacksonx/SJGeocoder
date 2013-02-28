//
//  SJGeocoder.h
//  Departing
//
//  Created by Scott Jackson on 28/02/13.
//  Copyright (c) 2013 Scott Jackson. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

enum {
	SJGeocoderSearchSourceGeocoder = 1 << 0,
	SJGeocoderSearchSourceLocalSearch = 1 << 1,
	SJGeocoderSearchSourceAny = SJGeocoderSearchSourceGeocoder | SJGeocoderSearchSourceLocalSearch
};
typedef NSUInteger SJGeocoderSearchSource;

@interface SJGeocoder : CLGeocoder {
	CLRegion *_searchRegion;
	MKLocalSearch *_localSearch;
	
	NSArray *_localSearchPlacemarks;
	NSArray *_geocodePlacemarks;
}

@property SJGeocoderSearchSource searchSource;

- (id)initWithSearchSource:(SJGeocoderSearchSource)source;

@end
