//
//  Fellow.h
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Fellow : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) id skills;

@end
