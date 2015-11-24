//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import "StoreRequest.h"
#import "AFNetworking.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "CityGuideViewController.h"


@interface StoreRequest () {
    BOOL reachable;
}

@end



@implementation StoreRequest


- (id)init
{
    self = [super init];
    
    if (self) {
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
        reachable = YES;
        
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
#ifdef DEBUG
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
#endif
            if (status > 0)
                reachable = YES;
            else
                reachable = NO;
        }];
    }
    
    return self;
}

- (void)requestStoreList:(void (^)(id responseData))block
{
    if (reachable) {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            block(nil);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
    } else
        block(nil);
}

- (void)requestStoreListPage:(NSInteger)page response:(void (^)(id))block
{
    if (reachable) {
        [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
        
        NSString *pageUrlStr = [NSString stringWithFormat:@"%@?page=%d", urlStr, page];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:pageUrlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            block(responseObject);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            block(nil);
            [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
        }];
    } else
        block(nil);
}

- (void)requestStoreThumb:(NSString *)urlStr success:(void(^)(UIImage *image))success failure:(void(^)())failure
{
    [[AFNetworkActivityIndicatorManager sharedManager] incrementActivityCount];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImageView *tmpImage = [[UIImageView alloc] init];
    [tmpImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        success(image);
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        failure();
        [[AFNetworkActivityIndicatorManager sharedManager] decrementActivityCount];
    }];
}


@end
