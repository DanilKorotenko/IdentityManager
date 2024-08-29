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
@property(strong) NSString *name;

@end

@implementation IdentityListWindow

- (instancetype)initWithQuery:(CSIdentityQueryRef)aGroupMemebershipQuery name:(NSString *)aName
{
    self = [super initWithWindowNibName:@"IdentityListWindow"];
    if (self)
    {
        self.list = [[IdentityList alloc] initWithIdentityQuery:aGroupMemebershipQuery];
        self.name = aName;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    self.window.contentView = self.list.view;
    self.window.title = self.name;
}

@end
