//
//  Weather+CoreDataProperties.h
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//
//

#import "Weather+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest;

@property (nonatomic) float air_pressure;
@property (nullable, nonatomic, copy) NSString *applicable_date;
@property (nullable, nonatomic, copy) NSString *created;
@property (nonatomic) int64_t humidity;
@property (nonatomic) int64_t id;
@property (nonatomic) double max_temp;
@property (nonatomic) double min_temp;
@property (nonatomic) int64_t predictability;
@property (nonatomic) double the_temp;
@property (nonatomic) double visibility;
@property (nullable, nonatomic, copy) NSString *weather_state_abbr;
@property (nullable, nonatomic, copy) NSString *weather_state_name;
@property (nonatomic) double wind_direction;
@property (nullable, nonatomic, copy) NSString *wind_direction_compass;
@property (nonatomic) double wind_speed;

@end

NS_ASSUME_NONNULL_END
