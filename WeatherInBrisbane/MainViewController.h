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

@property (nonatomic, strong) NSMutableArray *weatherData;
@property (nonatomic, strong) NSManagedObjectContext *managedContext;
@property (nonatomic, strong) NSMutableArray *weatherAttributes;
@property (nonatomic, strong) WeatherTableViewController *delegate;

@end

NS_ASSUME_NONNULL_END
