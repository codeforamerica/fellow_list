//
//  FellowDetailViewController.h
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import "Fellow.h"

@interface FellowDetailViewController : UITableViewController

@property (strong, nonatomic) Fellow *fellow;

@property (weak, nonatomic) IBOutlet UITableViewCell *nameDetail;
@property (weak, nonatomic) IBOutlet UITableViewCell *twitterDetail;
@property (weak, nonatomic) IBOutlet UITableViewCell *primarySkill;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondarySkill;
@property (weak, nonatomic) IBOutlet UITableViewCell *finalSkill;

- (IBAction)sendTweet:(id)sender;

@end
