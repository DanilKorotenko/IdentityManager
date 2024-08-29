//
//  IdentityListWindow.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/23/24.
//

#import "IdentityListWindow.h"

#import "IdentityList.h"

@interface IdentityListWindow ()

@property(strong) IdentityList *list;

@end

@implementation IdentityListWindow

- (instancetype)initWithQuery:(CSIdentityQueryRef)aGroupMemebershipQuery
{
    self = [super initWithWindowNibName:@"IdentityListWindow"];
    if (self)
    {
        self.list = [[IdentityList alloc] initWithIdentityQuery:aGroupMemebershipQuery];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.window.contentView = self.list.view;
}

@end
