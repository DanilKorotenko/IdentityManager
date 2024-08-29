//
//  AppDelegate.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "AppDelegate.h"

#import "IdentityNameList.h"

@interface AppDelegate ()

@property (strong) IBOutlet NSWindow *window;
@property (strong) IBOutlet NSTabView *tabView;

@property (strong) IdentityNameList *generalUsersList;
@property (strong) IdentityNameList *generalGroupsList;

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.generalUsersList = [[IdentityNameList alloc] init];
    self.generalGroupsList = [[IdentityNameList alloc] initGroups];

    [self.tabView tabViewItemAtIndex:0].view = self.generalUsersList.view;
    [self.tabView tabViewItemAtIndex:1].view = self.generalGroupsList.view;
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
