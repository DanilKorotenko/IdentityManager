//
//  UsersList.m
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import "IdentityList.h"

#import "IdentityUtilities/IUIdentityQuery/IUIdentityQueryNameWatcher.h"

#import "IdentityListWindow.h"

@interface IdentityList ()

@property (strong) IBOutlet NSTableView *usersTable;

@property (strong) IUIdentityQueryWatcher *queryWatcher;

@property (readonly) NSArray *identitites;

@end

@implementation IdentityList

@synthesize identitites;

- (instancetype)init
{
    self = [super initWithNibName:@"IdentityList" bundle:[NSBundle mainBundle]];
    if (self)
    {

    }
    return self;
}


- (instancetype)initWithIdentityQuery:(CSIdentityQueryRef)aGroupMemebershipQuery
{
    self = [self init];
    if (self)
    {
        self.queryWatcher = [[IUIdentityQueryWatcher alloc] initWithIdentityQuery:aGroupMemebershipQuery];
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
    [self.queryWatcher startWithEventBlock:
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
        NSMutableArray *result = [NSMutableArray arrayWithArray:self.queryWatcher.identities];
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

- (IBAction)tableDoubleAction:(id)sender
{
    NSInteger selectedRow = self.usersTable.selectedRow;
    IUIdentity *identity = [self.identitites objectAtIndex:selectedRow];
    if (identity.isGroup)
    {
        IdentityListWindow *newWindow = [[IdentityListWindow alloc] initWithQuery:identity.groupMemebershipQuery
            name:identity.fullName];
        [newWindow showWindow:nil];
    }
}

@end
