//
//  IdentityListWindow.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/23/24.
//

#import "IdentityListWindow.h"

#import "IdentityUtilities/IUIdentityQuery/IUIdentityQueryWatcher.h"
#import "IdentityNameList.h"

@interface IdentityListWindow ()

@property(strong) IUIdentity *groupIdentity;
@property(strong) IdentityNameList *list;

@end

@implementation IdentityListWindow

- (instancetype)initWithGroup:(IUIdentity *)aGroup
{
    self = [super initWithWindowNibName:@"IdentityListWindow"];
    if (self)
    {
        self.groupIdentity = aGroup;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.list = [[IdentityNameList alloc] initWithGroupIdentity:self.groupIdentity];
}

@end
