//
//  SimpleTableViewController.h
//  SimpleTable
//
//  Created by Simon Ng on 16/4/12.
//  Copyright (c) 2012 AppCoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UILabel *amountInvested;
@property (nonatomic, retain) IBOutlet UILabel *amountValue;

@property (nonatomic, retain) NSString * investedAmount;
@property (nonatomic, retain) NSString * currentValue;


@end
