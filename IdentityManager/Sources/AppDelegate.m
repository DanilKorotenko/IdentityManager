//
//  AppDelegate.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "AppDelegate.h"

#import "UsersList.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (strong) UsersList *generalUsersList;

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.generalUsersList = [[UsersList alloc] init];
    self.window.contentView = self.generalUsersList.view;
}

#pragma mark app delegate

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app
{
    return YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

@end
