//
//  WeatherTableViewController.m
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import "WeatherTableViewController.h"

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    _weatherDataKeys = [[NSMutableArray alloc] init];
    if (_weatherData.count > 0) {
        _weatherDataKeys = [_weatherData[0] allKeys];
    }
}

- (void)newWeatherDataReceived:(NSMutableArray *)weatherData {
    _weatherData = weatherData;
    // assuming the number of attributes doesn't change within a day. If I had more time I could test if this is always true
    if (_weatherData.count > 0) {
        _weatherDataKeys = [_weatherData[0] allKeys];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
     });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _weatherData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weatherDataKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell" forIndexPath:indexPath];
    cell.textLabel.text = _weatherDataKeys[indexPath.row];
    NSDictionary *weather = _weatherData[indexPath.section];
    NSString *keyString = [NSString stringWithFormat: @"%@", (_weatherDataKeys[indexPath.row])];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [weather valueForKey: keyString]];
    
    if ([keyString isEqualToString:@"created"]) {
        cell.contentView.backgroundColor = [UIColor grayColor];
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

@end
