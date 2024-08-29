//
//  IdentityListWindow.h
//  IdentityManager
//
//  Created by Danil Korotenko on 8/23/24.
//

#import <Cocoa/Cocoa.h>
#import "IdentityUtilities/IUIdentity.h"

NS_ASSUME_NONNULL_BEGIN

@interface IdentityListWindow : NSWindowController

- (instancetype)initWithGroup:(IUIdentity *)aGroup;

@end

NS_ASSUME_NONNULL_END
