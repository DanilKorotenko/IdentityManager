//
//  UsersList.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "IdentityList.h"

#import "IdentityUtilities/IUIdentityQuery.h"

@interface IdentityList ()

@property (strong) IBOutlet NSTableView *usersTable;
@property (strong) IBOutlet NSSearchField *searchField;
@property (strong) IBOutlet NSPopUpButton *authorityPopup;

@property (strong) IUIdentityQuery *query;

@end

@implementation IdentityList

- (instancetype)init
{
    self = [super initWithNibName:@"IdentityList" bundle:[NSBundle mainBundle]];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.query = [[IUIdentityQuery alloc] init];
    [self restartQuery];
}

- (void)restartQuery
{
    NSInteger tag = self.authorityPopup.selectedItem.tag;
    [self.query startForName:self.searchField.stringValue authority:(IUIdentityQueryAuthority)tag eventBlock:
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

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    IUIdentity *identity = [self.query.identities objectAtIndex:row];
    view.textField.stringValue = identity.fullName;
    return view;
}

#pragma mark -

- (IBAction)searchFieldDidChange:(id)sender
{
    [self restartQuery];
}

- (IBAction)authorityDidChange:(id)sender
{
    [self restartQuery];
}

@end
