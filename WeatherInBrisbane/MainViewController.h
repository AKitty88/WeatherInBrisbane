//
//  MainViewController.h
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import <UIKit/UIKit.h>
#import "WeatherTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewController : UIViewController

@property (atomic, strong) NSMutableArray *weatherData;
@property (atomic, strong) NSManagedObjectContext *managedContext;
@property (atomic, strong) NSMutableArray *weatherAttributes;
@property (atomic, strong) WeatherTableViewController *delegate;
@property (atomic, strong) NSMutableArray *weatherAttributesOrdered;

@end

NS_ASSUME_NONNULL_END
