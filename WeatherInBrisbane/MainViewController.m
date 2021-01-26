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
    _weatherData = [[NSMutableArray alloc] init];
    _weatherAttributes = [[NSMutableArray alloc] init];
    _weatherAttributesOrdered = [[NSMutableArray alloc] init];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    _managedContext = delegate.persistentContainer.viewContext;
    
    [self getWeatherFromDataBase];
    
    if ([self connectedToInternet] == YES) {
        [self emptyWeatherInDataBase];
    }
}

- (Boolean)connectedToInternet {
    NSURL *scriptUrl = [NSURL URLWithString:@"https://www.metaweather.com/api/location/1100661"];
    NSData *data = [NSData dataWithContentsOfURL:scriptUrl];
    if (data) {
        return YES;
    }
    else {
        return NO;
    }
}

- (void)getWeatherFromDataBase {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"Weather"];
    NSMutableArray *weatherFromDB = [[NSMutableArray alloc] init];
    weatherFromDB = [[_managedContext executeFetchRequest:fetchRequest error: nil] mutableCopy];
    if (weatherFromDB.count > 0) {
        _weatherData = [weatherFromDB mutableCopy];
        // assuming the number of attributes doesn't change within a day. If I had more time I could test if this is always true
        _weatherAttributes = [[[[weatherFromDB[0] entity] attributesByName] allKeys] mutableCopy];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:_weatherAttributes forKey:@"weatherAttributes"];
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
    NSManagedObject *newWeatherEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:_managedContext];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:nil];
    NSDictionary *attributes = [[newWeatherEntry entity] attributesByName];
    // assuming the number of attributes doesn't change within a day. If I had more time I could test if this is always true
    _weatherData = nil;
    _weatherData = [[NSMutableArray alloc] init];
    
    
    for (NSDictionary *weather in jsonArray) {
        NSManagedObject *newWeatherEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:_managedContext];
        
        for (NSString *attribute in attributes) {
            id value = [weather objectForKey:attribute];
            
            if (value == nil || [value isEqual:[NSNull null]]) {
                continue;
            }
            else {
                [newWeatherEntry setValue:value forKey:attribute];
                
                if (![_weatherAttributesOrdered containsObject:attribute] && _weatherAttributesOrdered.count < attributes.count) {
                    [_weatherAttributesOrdered addObject:attribute];
                }
            }
        }
        [_weatherData addObject:newWeatherEntry];
        _weatherAttributes = [_weatherAttributesOrdered mutableCopy];
        
        if (_managedContext != nil) {
            [_managedContext performBlockAndWait:^{
                NSError *error = nil;
                if (![_managedContext save:&error]) {
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                }
            }];
        }
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
            [self.delegate newWeatherDataReceived: weatherArray with:self.weatherAttributesOrdered];
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
    vc.weatherAttributesOrdered = [[NSMutableArray alloc] init];
    
    if (_weatherAttributesOrdered.count > 0) {
        vc.weatherAttributesOrdered = [_weatherAttributesOrdered mutableCopy];
    }
    else {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSArray *attributesfromUserDefaults = [userDefaults objectForKey:@"weatherAttributes"];
        
        if (attributesfromUserDefaults == nil) {
            attributesfromUserDefaults =  [[NSMutableArray alloc] init];
        }
        vc.weatherAttributesOrdered = [attributesfromUserDefaults mutableCopy];
    }
}

@end
