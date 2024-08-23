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

@property (readonly) NSArray *identitites;

@property (readonly) CSIdentityClass identityClass;

@end

@implementation IdentityList

@synthesize identitites;
@synthesize identityClass;

- (instancetype)initUsers
{
    self = [super initWithNibName:@"IdentityList" bundle:[NSBundle mainBundle]];
    if (self)
    {
        identityClass = kCSIdentityClassUser;
    }
    return self;
}

- (instancetype)initGroups
{
    self = [super initWithNibName:@"IdentityList" bundle:[NSBundle mainBundle]];
    if (self)
    {
        identityClass = kCSIdentityClassGroup;
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
    [self.query startForName:self.searchField.stringValue
        authority:(IUIdentityQueryAuthority)tag
        identityClass:self.identityClass
        eventBlock:
        ^(CSIdentityQueryEvent event, NSError * _Nonnull anError)
        {
            self->identitites = nil;
            [self.usersTable reloadData];
        }];
}

- (NSArray *)identitites
{
    if (identitites == nil)
    {
        NSMutableArray *result = [NSMutableArray arrayWithArray:self.query.identities];
        [result sortUsingComparator:
            ^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2)
            {
                return [[(IUIdentity *)obj1 fullName] compare:[(IUIdentity *)obj2 fullName]];
            }];
        identitites = result;
    }
    return identitites;
}

#pragma mark table

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.identitites.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:tableColumn.identifier owner:self];
    IUIdentity *identity = [self.identitites objectAtIndex:row];
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
