//
//  Weather+CoreDataProperties.m
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//
//

#import "Weather+CoreDataProperties.h"

@implementation Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Weather"];
}

@dynamic air_pressure;
@dynamic applicable_date;
@dynamic created;
@dynamic humidity;
@dynamic id;
@dynamic max_temp;
@dynamic min_temp;
@dynamic predictability;
@dynamic the_temp;
@dynamic visibility;
@dynamic weather_state_abbr;
@dynamic weather_state_name;
@dynamic wind_direction;
@dynamic wind_direction_compass;
@dynamic wind_speed;

@end
