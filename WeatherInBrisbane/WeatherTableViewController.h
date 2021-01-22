//
//  WeatherTableViewController.h
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WeatherTableViewController : UITableViewController

@property (atomic, strong) NSMutableArray *weatherData;
@property (atomic, strong) NSMutableArray *weatherAttributes;
@property (atomic, strong) NSMutableArray *weatherDataKeys;

- (void)newWeatherDataReceived:(NSManagedObject *)weatherData;

@end
