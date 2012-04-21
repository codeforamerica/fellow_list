//
//  Fellow+Create.m
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import "Fellow+Create.h"

@implementation Fellow (Create)

+ (Fellow *)fellowFromDictionary:(NSDictionary *)dict
          inManagedObjectContext:(NSManagedObjectContext *)context
{
    Fellow *fellow = [NSEntityDescription insertNewObjectForEntityForName:@"Fellow"
                                                   inManagedObjectContext:context];
    fellow.name = [dict objectForKey:@"name"];
    fellow.city = [dict objectForKey:@"city"];
    fellow.skills = [dict objectForKey:@"skills"];
    fellow.twitter = [dict objectForKey:@"twitter"];
    return fellow;
}

@end
