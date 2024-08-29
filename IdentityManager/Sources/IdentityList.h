//
//  UsersList.h
//  IdentityManager
//
//  Created by Danil Korotenko on 8/20/24.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface IdentityList : NSViewController<NSTableViewDelegate, NSTableViewDataSource>

- (instancetype)initWithIdentityQuery:(CSIdentityQueryRef)aGroupMemebershipQuery;

@end

NS_ASSUME_NONNULL_END
