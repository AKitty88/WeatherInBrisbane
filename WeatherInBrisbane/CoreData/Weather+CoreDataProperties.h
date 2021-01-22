//
//  Weather+CoreDataProperties.h
//  WeatherInBrisbane
//
//  Created by User on 21/1/21.
//
//

#import "Weather+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Weather (CoreDataProperties)

+ (NSFetchRequest<Weather *> *)fetchRequest;

@property (nullable, nonatomic) float air_pressure;
@property (nullable, nonatomic, copy) NSString *applicable_date;
@property (nullable, nonatomic, copy) NSString *created;
@property (nullable, nonatomic) int64_t humidity;
@property (nonatomic) int64_t id;
@property (nullable, nonatomic) double max_temp;
@property (nullable, nonatomic) double min_temp;
@property (nullable, nonatomic) int64_t predictability;
@property (nullable, nonatomic) double the_temp;
@property (nullable, nonatomic) double visibility;
@property (nullable, nonatomic, copy) NSString *weather_state_abbr;
@property (nullable, nonatomic, copy) NSString *weather_state_name;
@property (nullable, nonatomic) double wind_direction;
@property (nullable, nonatomic, copy) NSString *wind_direction_compass;
@property (nullable, nonatomic) double wind_speed;

@end

NS_ASSUME_NONNULL_END
