//
//  FellowAppDelegate.m
//  FellowList
//
//  Created by Zach Williams on 4/20/12.
//  Copyright (c) 2012 Code for America. All rights reserved.
//

#import "FellowAppDelegate.h"
#import "FellowMasterViewController.h"
#import "Fellow+Create.h"

@implementation FellowAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    [self checkFellowsDatabase];
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    FellowMasterViewController *controller = (FellowMasterViewController *)navigationController.topViewController;
    controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)customizeAppearance
{
    // Code for America colors.
    // UIColor *red = [UIColor colorWithRed:199/255.0f green:30/255.0f blue:63/255.0f alpha:1];
    UIColor *blue = [UIColor colorWithRed:44/255.0f green:137/255.0f blue:194/255.0f alpha:1];
    UIColor *offWhite = [UIColor colorWithRed:250/255.0f green:250/255.0f blue:248/255.0f alpha:1];
    UIColor *separate = [UIColor colorWithRed:235/255.0f green:235/255.0f blue:234/255.0f alpha:1];
    [[UINavigationBar appearance] setTintColor:blue];
    [[UITableView appearance] setBackgroundColor:offWhite];
    [[UITableView appearance] setSeparatorColor:separate];
}

- (void)checkFellowsDatabase{
    // Check to see if the Fellows database is empty or not.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fellow"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fellows = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (![fellows count]) {
        NSLog(@"Empty database");
        [self populateDatabaseFromJSON];
    } else {
        NSLog(@"Database has data in it!");
    }
}

- (void)populateDatabaseFromJSON{
    dispatch_queue_t jsonQ = dispatch_queue_create("JSON Queue", NULL);
    dispatch_async(jsonQ, ^{
        NSString *file = [[NSBundle mainBundle] pathForResource:@"fellows" ofType:@"json"];
        NSString *json = [[NSString alloc] initWithContentsOfFile:file
                                                     encoding:NSUTF8StringEncoding
                                                            error:nil];
        NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
        NSArray *data = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        for (NSDictionary *fellow in data) {
            [Fellow fellowFromDictionary:fellow inManagedObjectContext:self.managedObjectContext];
        }
    });
    dispatch_release(jsonQ);
}
							
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store
// coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FellowList" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Fellows.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

@end
