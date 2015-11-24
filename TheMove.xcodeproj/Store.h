//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import <Foundation/Foundation.h>

/**
 Class that rapreset a single store.
 */
@interface Store : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSString *descriptionf;
@property (nonatomic, strong) NSString *uploadDate;
@property (nonatomic, strong) UIImage *storeThumb;
@property (nonatomic, strong) NSString *storeThumbUrl;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) UIImage *userThumb;
@property (nonatomic, strong) NSString *userThumbUrl;


/**

 @param dict The Json structure that rapresent a single store information.
 */
- (void)deserializeDictionary:(NSDictionary *)dict;

@end
