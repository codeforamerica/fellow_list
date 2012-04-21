//
//  FellowDetailViewController.m
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import "FellowDetailViewController.h"

@interface FellowDetailViewController ()
- (void)configureView;
@end

@implementation FellowDetailViewController

#pragma mark - Managing the detail item

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.fellow) {
        // Name.
        self.navigationItem.title = [[self.fellow.name componentsSeparatedByString:@" "] objectAtIndex:0];
        self.nameDetail.detailTextLabel.text = self.fellow.name;
        self.twitterDetail.detailTextLabel.text = self.fellow.twitter;
        
        // Skills.
        self.primarySkill.detailTextLabel.text = [self.fellow.skills objectAtIndex:0];
        self.secondarySkill.detailTextLabel.text = [self.fellow.skills objectAtIndex:1];
        self.finalSkill.detailTextLabel.text = [self.fellow.skills objectAtIndex:2];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end
