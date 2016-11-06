//
//  UITableViewCell+CustomCell.h
//  
//
//  Created by Balaji S. Rajendran on 11/5/16.
//
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *fundName;
@property (nonatomic, weak) IBOutlet UILabel *navDate;
@property (nonatomic, weak) IBOutlet UILabel *nav;
@property (nonatomic, weak) IBOutlet UILabel *investedAmount;
@property (nonatomic, weak) IBOutlet UILabel *currentAmount;
@property (nonatomic, weak) IBOutlet UILabel *profitLoss;
@property (nonatomic, weak) IBOutlet UIImageView *fundHouseImageView;

@end
