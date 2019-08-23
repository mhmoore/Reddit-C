//
//  MHMPost.m
//  Reddit
//
//  Created by Michael Moore on 8/20/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

#import "MHMPost.h"

static NSString *const dataKey = @"data";
static NSString *const titleKey = @"title";
static NSString *const upsKey = @"ups";
static NSString *const commentCountKey = @"num_comments";
static NSString *const thumbnailKey = @"thumbnail";

@implementation MHMPost

- (instancetype)initWithTitle:(NSString *)title ups:(NSInteger)ups commentCount:(NSInteger)commentCount thumbnail:(nonnull NSString *)thumbnail {
    self = [super init];
    if (self) {
        _title = title;
        _ups = ups;
        _commentCount = commentCount;
        _thumbnail = thumbnail;
    }
    return self;
}
@end


@implementation MHMPost (JSONConvertable)
// this is creates a dictionary that will hold your title key:value, ups key:value, and commentCount key:value pairs
-(instancetype)initWithDictionary:(NSDictionary *)dictionary {
    
    // this is referring to the inner most dictionary.  In the controller, you will dig down to this dictionary
    // Get each post from the data key
    NSDictionary *dataDictionary = dictionary[dataKey];
    // When you're inside the inner-most dataDictionary which holds the objects that you initialize, that is when you can define your properties that come from the JSON
    NSString *title = dataDictionary[titleKey];
    NSInteger ups = [dataDictionary[upsKey] integerValue];
    NSInteger commentCount = [dataDictionary[commentCountKey] integerValue];
    NSString *thumbnail = dataDictionary[thumbnailKey];
    // initializes your POST with the JSON data
    return [self initWithTitle:title ups:ups commentCount:commentCount thumbnail:thumbnail];
}
@end
