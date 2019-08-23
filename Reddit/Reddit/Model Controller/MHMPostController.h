//
//  MHMPostController.h
//  Reddit
//
//  Created by Michael Moore on 8/20/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MHMPost.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHMPostController : NSObject

+(instancetype)shared;

-(void)searchForPostWithSearchTerm:(NSString *)searchTerm completion:(void (^) (NSArray<MHMPost *> *posts, NSError *error))completion;

-(void)fetchImagePost:(MHMPost *)post completion:(void(^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
