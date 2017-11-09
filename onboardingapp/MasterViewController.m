//
//  MasterViewController.m
//  onboardingapp
//
//  Created by Ben Marten on 11/8/17.
//  Copyright © 2017 Leanplum. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailTableViewController.h"
#import "AppDelegate.h"
#import "Leanplum/Leanplum.h"

@interface MasterViewController ()

@property NSMutableDictionary *data;
@property NSMutableArray *objects;

@end

@implementation MasterViewController

DEFINE_VAR_STRING(json, @"");

- (void)variablesChanged {
    NSError* error;
    NSString *string = json.stringValue;
    self.data = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
    
    [(AppDelegate*)[UIApplication sharedApplication].delegate setData:self.data];
    
    for (NSDictionary* element in self.data) {
        [self.objects addObject:element];
    }
    NSLog(@"data updated");
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    self.objects = [NSMutableArray new];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    [Leanplum addVariablesChangedResponder:self withSelector:@selector(variablesChanged)];
}


- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"details"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *title = self.objects[indexPath.row];
        NSDictionary *steps = [self.data objectForKey:title];

        [Leanplum setUserAttributes:@{@"Employee Role": title}];
        DetailTableViewController *controller = (DetailTableViewController *)[segue destinationViewController];

        [controller setSteps:steps];
    }
}


#pragma mark - Table View

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *title = self.data[indexPath.row];
//    NSDictionary *steps = self.data[indexPath.row];

    [self performSegueWithIdentifier:@"details" sender:self];
    
//    [Leanplum setUserAttributes:@{@"Employee Role": title}];
//    DetailTableViewController *controller = (DetailTableViewController *)[[segue destinationViewController] topViewController];
//
//    [controller setSteps:steps];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSString *title = self.objects[indexPath.row];
    cell.textLabel.text = title;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}


@end
