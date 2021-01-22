//
//  MainViewController.m
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import "MainViewController.h"
#import "Appdelegate.h"
#import <CoreData/CoreData.h>

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _weatherData = [[NSMutableArray<NSManagedObject*> alloc] init];
    _weatherAttributes = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedContext = delegate.persistentContainer.viewContext;
    
    [self getWeatherFromDataBase];
    [self emptyWeatherInDataBase];
}

- (void)getWeatherFromDataBase {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"Weather"];
    NSMutableArray *weatherFromDB = [[NSMutableArray<NSManagedObject*> alloc] init];
    weatherFromDB = [[_managedContext executeFetchRequest:fetchRequest error: nil] mutableCopy];
    if (weatherFromDB.count > 0) {
        _weatherData = [weatherFromDB mutableCopy];
        // assuming the number of attributes doesn't change within a day. If I had more time I could test if this is always true
        _weatherAttributes = [[[[weatherFromDB[0] entity] attributesByName] allKeys] mutableCopy];
        NSLog(@"--------  weatherData: %@", weatherFromDB);
    }
}

- (void) emptyWeatherInDataBase {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"Weather"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];

    NSError *deleteError = nil;
    [delegate.persistentContainer.persistentStoreCoordinator executeRequest:delete withContext:_managedContext error:&deleteError];
}

- (NSString*)getYesterdaysDateAsString {
    NSDate *today = [NSDate date];
    int numberOfDaysToAdd = -1;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:numberOfDaysToAdd];
    
    NSCalendar *gregorianCal = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDate *yesterday = [gregorianCal dateByAddingComponents:dateComponents toDate:today options:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    
    return [dateFormatter stringFromDate:yesterday];
}

- (void)saveWeatherData:(NSData *)weatherData {
    _weatherData = [[NSMutableArray<NSManagedObject*> alloc] init];
    NSManagedObject *newWeatherEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:_managedContext];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:nil];
    NSDictionary *attributes = [[newWeatherEntry entity] attributesByName];
    
    for (NSDictionary *weather in jsonArray) {
        for (NSString *attribute in attributes) {
            id value = [weather objectForKey:attribute];
            if (value == nil || [value isEqual:[NSNull null]])
            {
                continue;
            }
            else {
                [newWeatherEntry setValue:value forKey:attribute];
            }
        }
        [_weatherData addObject:newWeatherEntry];
    }
    
    NSError *error = nil;
    
    if (![_managedContext save:&error]) {
        NSLog([error localizedDescription]);
    }
}

- (IBAction)showWeather:(UIButton *)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    
    NSString* urlString = [NSString stringWithFormat: @"https://www.metaweather.com/api/location/1100661/%@", [self getYesterdaysDateAsString]];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (data != nil) {
            [self saveWeatherData: data];
            NSMutableArray *weatherArray = [[NSMutableArray alloc] init];
            
            for (NSManagedObject *weather in _weatherData) {
                [weatherArray addObject: [weather dictionaryWithValuesForKeys:_weatherAttributes]];
            }
            
            [self.delegate newWeatherDataReceived: weatherArray];
        }
    }] resume];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    WeatherTableViewController *vc = [segue destinationViewController];
    _delegate = vc;
    vc.weatherData = [[NSMutableArray alloc] init];
    NSMutableArray *weatherArray = [[NSMutableArray alloc] init];
    
    for (NSManagedObject *weather in _weatherData) {
        [weatherArray addObject: [weather dictionaryWithValuesForKeys:_weatherAttributes]];
    }
    vc.weatherData = [weatherArray mutableCopy];
    vc.weatherAttributes = [[NSMutableArray alloc] init];
    vc.weatherAttributes = _weatherAttributes;
}

@end
