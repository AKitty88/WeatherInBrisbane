//
//  WeatherTableViewController.h
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WeatherTableViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *weatherData;
@property (nonatomic, strong) NSMutableArray *weatherAttributes;
@property (nonatomic, strong) NSArray *keysInWeatherData;

- (void)newWeatherDataReceived:(NSManagedObject *)weatherData;

@end
