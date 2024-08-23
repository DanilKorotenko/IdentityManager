//
//  UsersList.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "UsersList.h"

#import "IdentityUtilities/IUIdentityQuery.h"

@interface UsersList ()

@property (strong) IBOutlet NSTableView *usersTable;

@property (strong) IUIdentityQuery *query;

@end

@implementation UsersList

- (instancetype)init
{
    self = [super initWithNibName:@"UsersList" bundle:[NSBundle mainBundle]];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.query = [[IUIdentityQuery alloc] init];
    [self.query startWithEventBlock:
        ^(CSIdentityQueryEvent event, NSError * _Nonnull anError)
        {
            [self.usersTable reloadData];
        }];
}

#pragma mark table

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.query.identities.count;
}

@end
