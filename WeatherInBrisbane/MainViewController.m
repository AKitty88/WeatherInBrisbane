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
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSManagedObject *newWeatherEntry = [NSEntityDescription insertNewObjectForEntityForName:@"Weather" inManagedObjectContext:context];
    
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:weatherData options:0 error:nil];
    
    NSDictionary *attributes = [[newWeatherEntry entity] attributesByName];         // save all data
    for (NSString *attribute in attributes) {
        id value = [jsonObject[0] objectForKey:attribute];
        if (value == nil) {
            continue;
        }
        [newWeatherEntry setValue:value forKey:attribute];
    }
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog([error localizedDescription]);
    }
}

- (IBAction)showWeather:(UIButton *)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString* urlString = [NSString stringWithFormat: @"https://www.metaweather.com/api/location/1100661/%@", [self getYesterdaysDateAsString]];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (data != nil) {
            [self saveWeatherData: data];
        }
    }] resume];
}

@end
