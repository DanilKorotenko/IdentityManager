//
//  AppDelegate.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "AppDelegate.h"

#import "IdentityList.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;

@property (strong) IdentityList *generalUsersList;

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.generalUsersList = [[IdentityList alloc] init];
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
