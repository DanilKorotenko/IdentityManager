//
//  UsersList.h
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import <Cocoa/Cocoa.h>

#import "IdentityUtilities/IUIdentity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdentityNameList : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

- (instancetype)init;
- (instancetype)initGroups;

@end

NS_ASSUME_NONNULL_END
