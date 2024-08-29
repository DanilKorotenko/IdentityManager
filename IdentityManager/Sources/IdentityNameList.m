//
//  UsersList.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "IdentityNameList.h"

#import "IdentityUtilities/IUIdentityQuery/IUIdentityQueryNameWatcher.h"

#import "IdentityListWindow.h"

@interface IdentityNameList ()

@property (strong) IBOutlet NSTableView *usersTable;
@property (strong) IBOutlet NSSearchField *searchField;
@property (strong) IBOutlet NSPopUpButton *authorityPopup;

@property (readonly) IUIdentityQueryNameWatcher *queryNameWatcher;
@property (strong) IUIdentity *group;

@property (readonly) NSArray *identitites;

@property (readonly) CSIdentityClass identityClass;

@end

@implementation IdentityNameList

@synthesize identitites;
@synthesize identityClass;
@synthesize queryNameWatcher;

- (instancetype)init
{
    self = [super initWithNibName:@"IdentityList" bundle:[NSBundle mainBundle]];
    if (self)
    {
        identityClass = kCSIdentityClassUser;
        queryNameWatcher = [[IUIdentityQueryNameWatcher alloc] init];
    }
    return self;
}

- (instancetype)initGroups
{
    self = [self init];
    if (self)
    {
        identityClass = kCSIdentityClassGroup;
        queryNameWatcher = [[IUIdentityQueryNameWatcher alloc] init];
    }
    return self;
}

- (instancetype)initWithGroupIdentity:(IUIdentity *)aGroup
{
    self = [self init];
    if (self)
    {
        self.group = aGroup;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usersTable.doubleAction = @selector(tableDoubleAction:);
    [self restartQuery];
}

- (void)restartQuery
{
    NSInteger tag = self.authorityPopup.selectedItem.tag;
    [self.queryNameWatcher startForName:self.searchField.stringValue
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
        NSMutableArray *result = [NSMutableArray arrayWithArray:self.queryNameWatcher.identities];
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

- (IBAction)tableDoubleAction:(id)sender
{
    if (self.identityClass == kCSIdentityClassGroup)
    {
        NSInteger selectedRow = self.usersTable.selectedRow;
        IUIdentity *group = [self.identitites objectAtIndex:selectedRow];
        IdentityListWindow *newWindow = [[IdentityListWindow alloc] initWithGroup:group];
        [newWindow showWindow:nil];
    }
}

@end
