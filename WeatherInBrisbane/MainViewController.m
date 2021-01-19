//
//  MainViewController.m
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import "MainViewController.h"

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
    
}

- (IBAction)showWeather:(UIButton *)sender {
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString* urlString = [NSString stringWithFormat: @"https://www.metaweather.com/api/location/1100661/%@", [self getYesterdaysDateAsString]];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        NSLog(@"Request reply: %@", requestReply);
        [self saveWeatherData: data];
    }] resume];
}

@end
