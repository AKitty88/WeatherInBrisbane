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
}

- (void)newWeatherDataReceived:(NSMutableArray *)weatherData with:(NSMutableArray*)weatherAttributesOrdered {
    _weatherData = [weatherData mutableCopy];
    _weatherAttributesOrdered = [weatherAttributesOrdered mutableCopy];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _weatherData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _weatherAttributesOrdered.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"weatherCell" forIndexPath:indexPath];
    cell.textLabel.text = _weatherAttributesOrdered[indexPath.row];
    NSDictionary *weather = _weatherData[indexPath.section];
    NSString *keyString = [NSString stringWithFormat: @"%@", (_weatherAttributesOrdered[indexPath.row])];
    cell.detailTextLabel.text = [NSString stringWithFormat: @"%@", [weather valueForKey: keyString]];
    
    if ([keyString isEqualToString:_weatherAttributesOrdered[0]]) {
        cell.contentView.backgroundColor = [UIColor lightGrayColor];
    }
    else {
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    return cell;
}

@end
