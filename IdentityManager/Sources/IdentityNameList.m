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
@property (strong) IBOutlet NSButton    *includeHidden;

@property (readonly) IUIdentityQueryNameWatcher *queryNameWatcher;

@property (readonly) NSArray *identitites;

@property (readonly) CSIdentityClass identityClass;

@end

@implementation IdentityNameList

@synthesize identitites;
@synthesize identityClass;
@synthesize queryNameWatcher;

- (instancetype)init
{
    self = [super initWithNibName:@"IdentityNameList" bundle:[NSBundle mainBundle]];
    if (self)
    {
        identityClass = kCSIdentityClassUser;
        queryNameWatcher = [[IUIdentityQueryNameWatcher alloc] init];
    }
    return self;
}

- (instancetype)initGroups
{
    self = [super initWithNibName:@"IdentityNameList" bundle:[NSBundle mainBundle]];
    if (self)
    {
        identityClass = kCSIdentityClassGroup;
        queryNameWatcher = [[IUIdentityQueryNameWatcher alloc] init];
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
    BOOL includeHiddenFlag = self.includeHidden.state == NSControlStateValueOn;

    [self.queryNameWatcher startForName:self.searchField.stringValue
        authority:(IUIdentityQueryAuthority)tag
        identityClass:self.identityClass
        includeHidden:includeHiddenFlag
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
    NSInteger selectedRow = self.usersTable.selectedRow;
    IUIdentity *identity = [self.identitites objectAtIndex:selectedRow];
    if (identity.isGroup)
    {
        IdentityListWindow *newWindow = [[IdentityListWindow alloc] initWithGroupIdentity:identity
            name:identity.fullName];
        [newWindow showWindow:nil];
    }
}

- (IBAction)includeHiddenDidChange:(id)sender
{
    [self restartQuery];
}

@end
