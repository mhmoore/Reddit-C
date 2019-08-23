//
//  MHMPostController.m
//  Reddit
//
//  Created by Michael Moore on 8/20/19.
//  Copyright © 2019 Michael Moore. All rights reserved.
//

#import "MHMPostController.h"


@implementation MHMPostController

+ (MHMPostController *) shared {
    static MHMPostController *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [MHMPostController new];
    });
    return shared;
}

// Mark: - Properties
static NSString *const baseURLString = @"https://www.reddit.com/r/";


-(void)searchForPostWithSearchTerm:(NSString *)searchTerm completion:(void (^) (NSArray<MHMPost *> *posts, NSError *error))completion {
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
//    NSURL *baseURL = [[NSURL alloc] initWithString:baseURLString];
    baseURL = [baseURL URLByAppendingPathComponent: searchTerm];

    NSURL *finalURL = [baseURL URLByAppendingPathExtension:@"json"];
    NSLog(@"%@", finalURL);
    
    
    [[NSURLSession.sharedSession dataTaskWithURL:finalURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"dataTask error. %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        
        if (!data) {
            NSLog(@"There's no data. %@", error.localizedDescription);
            completion(nil, error);
            return;
        }
        // gets highest level of data, ALL the data
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if(!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]]){
            completion(nil, error);
            return;
        }
        // grabs the data dictionary in the top level JSON dictionary
        NSDictionary *postDataDictionaries = jsonDictionary[@"data"];
        // grabs the children array in the data dictionary
        NSArray *childrenArray = postDataDictionaries[@"children"];
        // need a placeholder array so we can complete with the type that we defined for our return object ([MHMPost])
        NSMutableArray *postsArray = [[NSMutableArray alloc] init];
        // Parse the data
        // here we loop through each of the data dictionaries in the children array
        for (NSDictionary *dataDictionary in childrenArray) {
            // and pass those data dictionaries through our initWithDictionary function and grab the data we want,
            MHMPost *post = [[MHMPost alloc] initWithDictionary:dataDictionary];
            // and place those in our posts array.
            [postsArray addObject:post];
        }
        // finally call completion with our array full of posts
        completion(postsArray, nil);
    }] resume];
}

-(void)fetchImagePost:(MHMPost *)post completion:(void (^)(UIImage *))completion {
    
    NSString *thumbnailString = [[NSString alloc] initWithFormat: @"%@", post.thumbnail];
    NSURL *thumbnailURL = [[NSURL alloc] initWithString: thumbnailString];
    
    
    [[[NSURLSession sharedSession] dataTaskWithURL: thumbnailURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error handling image. %@: %@", error, error.localizedDescription);
            completion(nil); return;
        }
        
        if (!data) {
            NSLog(@"There was no data. %@: %@", error, error.localizedDescription);
            completion(nil); return;
        }
        
        UIImage *thumbnail = [[UIImage alloc] initWithData:data];
        completion(thumbnail);
    }] resume];
}
                                     
@end
