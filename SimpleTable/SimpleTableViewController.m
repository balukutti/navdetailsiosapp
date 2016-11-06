//
//  SimpleTableViewController.m
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//

#import "SimpleTableViewController.h"
#import "SimpleTableCell.h"
#import <RestKit/RestKit.h>
#import "CustomCell.h"
#import "Location.h"


@interface SimpleTableViewController ()

@property (nonatomic, strong) NSArray *location;

@end

@implementation SimpleTableViewController
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureRestKit];
    [self loadVenues];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://localhost:8080"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"date", @"isin", @"nav", @"schemeCode", @"schemeName", @"customSchemeName", @"amountInvested", @"currentAmount", @"totalInvestedAmount", @"totalCurrentAmount",
                                                     @"profitLossPercentage"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:locationMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/MutualFundSnapShot/rest/products"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadVenues
{
    NSDictionary *queryParams = @{};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/MutualFundSnapShot/rest/products"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _location = mappingResult.array;
                                                  [self.myTableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_location count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"FundDetailCell";
    
    CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
//    if (indexPath.row > 0) {
//        NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
//        [tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//    }
    
    Location *venue = _location[indexPath.row];
    
    
    cell.fundName.text = venue.customSchemeName;
    cell.navDate.text = [NSString stringWithFormat:@"Nav Date: %@", venue.date];
    cell.nav.text = [NSString stringWithFormat:@"Nav: %@", venue.nav];
    cell.investedAmount.text = [NSString stringWithFormat:@"Invested Amt: %@", venue.amountInvested];
    cell.currentAmount.text = [NSString stringWithFormat:@"Current Amt: %@", venue.currentAmount];
    cell.profitLoss.text = [NSString stringWithFormat:@"P/L : %@", venue.profitLossPercentage];
    if ([venue.profitLossPercentage containsString:@"-"])
    {
        cell.profitLoss.textColor = [UIColor redColor];
    }
    else
    {
        cell.profitLoss.textColor = [Location colorFromHex:@"006633"];
    }
    
    _amountInvested.text = [NSString stringWithFormat:@"Amount Invested  :  Rs. %@", venue.totalInvestedAmount];
    _amountValue.text = [NSString stringWithFormat:@"Valuation Amount :  Rs. %@", venue.totalCurrentAmount];
    

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}



@end

