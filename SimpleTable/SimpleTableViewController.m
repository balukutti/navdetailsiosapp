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
@property (nonatomic, strong) NSArray *locationsorted;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector( appActivated: )
                                                 name: UIApplicationDidBecomeActiveNotification
                                               object: nil];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}


- (void)appActivated:(NSNotification *)note
{
    [self loadVenues];
}

- (void)configureRestKit
{
    // initialize AFNetworking HTTPClient
    NSURL *baseURL = [NSURL URLWithString:@"http://www.growmyworth.info"];
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping addAttributeMappingsFromArray:@[@"date", @"isin", @"nav", @"schemeCode", @"schemeName", @"customSchemeName", @"amountInvested", @"currentAmount", @"totalInvestedAmount", @"totalCurrentAmount", @"profitLossPercentage"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor =
    [RKResponseDescriptor responseDescriptorWithMapping:locationMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:@"/rest/products"
                                                keyPath:@""
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [objectManager addResponseDescriptor:responseDescriptor];
}

- (void)loadVenues
{
    NSDictionary *queryParams = @{};
    
    [[RKObjectManager sharedManager] getObjectsAtPath:@"/rest/products"
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  _location = mappingResult.array;
                                                  [self.myTableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    _location = [_location sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [(Location*)a customSchemeName];
        NSString *second = [(Location*)b customSchemeName];
        return [first compare:second];
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
    NSLog(@"LENGTH IS: %lu", (unsigned long)[_location count]);
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
    
    if([venue.totalCurrentAmount doubleValue] > [venue.totalInvestedAmount doubleValue])
    {
        _amountValue.textColor  = [UIColor greenColor];
        
        NSString *profitAmount= [NSString stringWithFormat:@"%.2lf", [venue.totalCurrentAmount doubleValue] - [venue.totalInvestedAmount doubleValue]];
        
        NSString *formattedProfitAmountString = @" (";
        formattedProfitAmountString = [formattedProfitAmountString stringByAppendingString: profitAmount];
        formattedProfitAmountString = [formattedProfitAmountString stringByAppendingString: @")"];
        
        _amountInvested.text = [NSString stringWithFormat:@"Amount Invested  :  Rs. %@", venue.totalInvestedAmount];
        _amountValue.text = [NSString stringWithFormat:@"Valuation Amount :  Rs. %@", [venue.totalCurrentAmount stringByAppendingString:formattedProfitAmountString]];
    }
    else
    {
        _amountValue.textColor  = [UIColor redColor];
        NSString *lossAmount= [NSString stringWithFormat:@"%.2lf", [venue.totalInvestedAmount doubleValue] - [venue.totalCurrentAmount doubleValue]];
        
        NSString *formattedLossAmountString = @" (";
        formattedLossAmountString = [formattedLossAmountString stringByAppendingString: lossAmount];
        formattedLossAmountString = [formattedLossAmountString stringByAppendingString: @")"];
        
        _amountInvested.text = [NSString stringWithFormat:@"Amount Invested  :  Rs. %@", venue.totalInvestedAmount];
        _amountValue.text = [NSString stringWithFormat:@"Valuation Amount :  Rs. %@", [venue.totalCurrentAmount stringByAppendingString: formattedLossAmountString]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}



@end

