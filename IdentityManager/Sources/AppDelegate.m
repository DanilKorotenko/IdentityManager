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
@property (strong) IBOutlet NSTabView *tabView;

@property (strong) IdentityList *generalUsersList;
@property (strong) IdentityList *generalGroupsList;

@end

@implementation AppDelegate

- (void)awakeFromNib
{
    self.generalUsersList = [[IdentityList alloc] init];
    self.generalGroupsList = [[IdentityList alloc] init];

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
