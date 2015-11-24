//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface StoreCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIView *feedContainer;

@property (nonatomic, weak) IBOutlet UIImageView *picImageView;

@property (nonatomic, weak) IBOutlet UIImageView *imaj;

@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;

@property (nonatomic, weak) IBOutlet UILabel *dateLabel;

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;

@end
