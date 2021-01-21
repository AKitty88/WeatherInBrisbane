//
//  WeatherTableViewController.m
//  WeatherInBrisbane
//
//  Created by User on 19/1/21.
//

#import "WeatherTableViewController.h"
#import "Appdelegate.h"
#import <CoreData/CoreData.h>

@implementation WeatherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self getWeatherFromDataBase];
}

- (void)getWeatherFromDataBase {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = delegate.persistentContainer.viewContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName: @"Weather"];

    NSManagedObject *weatherD = [[NSManagedObject alloc] init];
    weatherD = [[context executeFetchRequest:fetchRequest error: nil] mutableCopy];
    // [_tableview reloadData];
    NSLog(@"--------  weatherData: %@", weatherD);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
