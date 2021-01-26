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
@property (atomic, strong) NSMutableArray *weatherAttributesOrdered;

- (void)newWeatherDataReceived:(NSMutableArray *)weatherData with:(NSMutableArray*)weatherAttributesOrdered;

@end
