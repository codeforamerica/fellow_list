//
//  Fellow+Create.h
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import "Fellow.h"

@interface Fellow (Create)

+ (Fellow *)fellowFromDictionary:(NSDictionary *)dictionary
          inManagedObjectContext:(NSManagedObjectContext *)context;

@end
