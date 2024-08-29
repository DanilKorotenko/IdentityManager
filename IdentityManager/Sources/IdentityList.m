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
@property (strong) IBOutlet NSButton    *includeHidden;

@property (strong) IUIdentity *groupIdentity;
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


- (instancetype)initWithGroupIdentity:(IUIdentity *)aGroupIdentity
{
    self = [self init];
    if (self)
    {
        self.groupIdentity = aGroupIdentity;
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
    if (self.queryWatcher)
    {
        [self.queryWatcher stop];
    }

    self.queryWatcher = [[IUIdentityQueryWatcher alloc]
        initWithIdentityQuery:self.groupIdentity.groupMemebershipQuery];;
    BOOL includeHiddenFlag = self.includeHidden.state == NSControlStateValueOn;
    [self.queryWatcher startWithIncludeHidden:includeHiddenFlag eventBlock:
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
        IdentityListWindow *newWindow = [[IdentityListWindow alloc] initWithGroupIdentity:identity
            name:identity.fullName];
        [newWindow showWindow:nil];
    }
}

- (IBAction)includeHiddenDidChange:(id)sender
{
    [self.queryWatcher stop];
    [self restartQuery];
}

@end
