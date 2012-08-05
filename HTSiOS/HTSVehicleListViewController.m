//
//  HTSVehicleListViewController.m
//  atlas
//
//  Created by Justin Marrington on 3/08/12.
//  Copyright (c) 2012 University of Queensland. All rights reserved.
//

#import "HTSVehicleListViewController.h"
#import "HTSSurveyQuestionViewController.h"

@interface HTSVehicleListViewController () <CreatedVehicleDelegate>

@property (nonatomic, strong) NSMutableArray *vehicles;
@end

@implementation HTSVehicleListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.vehicles = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView setEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"CreateVehicle"]) {
        int vehicleNum = [self tableView:self.tableView numberOfRowsInSection:0];
        [segue.destinationViewController setGroupName:[NSString stringWithFormat:@"Vehicle %d", vehicleNum]];
        [segue.destinationViewController setDelegate:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.vehicles count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *VehicleCellIdentifier = @"VehicleCell";
    static NSString *VehicleAddCellIdentifier = @"AddVehicleCell";
    
    UITableViewCell *cell;
    if (indexPath.row == self.vehicles.count) {
        cell = [tableView dequeueReusableCellWithIdentifier:VehicleAddCellIdentifier];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:VehicleCellIdentifier];
        cell.textLabel.text = [self.vehicles objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.vehicles.count) {
        return UITableViewCellEditingStyleInsert;
    }
    return UITableViewCellEditingStyleDelete;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.vehicles removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        [self performSegueWithIdentifier:@"CreateVehicle" sender:self];
    }   
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.vehicles.count) {
        [self performSegueWithIdentifier:@"CreateVehicle" sender:self];
    }
}

- (IBAction)submitQuestions:(id)sender {
    // Need to submit questions here
    
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark CreatedVehicleDelegate methods
- (void)didCreateVehicleWithType:(NSString *)vehicleType
{
    [self.vehicles addObject:vehicleType];
    [self.tableView reloadData];
}

@end
