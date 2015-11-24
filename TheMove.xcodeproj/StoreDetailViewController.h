//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>


@interface StoreDetailViewController : UIViewController<MFMailComposeViewControllerDelegate>{

MFMailComposeViewController *mailComposer;
    IBOutlet UIButton *fbView;
    IBOutlet UIButton *twView;

}

-(IBAction)sendMail:(id)sender;

@property (weak, nonatomic) UIViewController *StoreList;
@property (nonatomic, retain) UIButton *fbView;
@property (nonatomic, retain) UIButton *twView;

- (IBAction)postToTwitter:(id)sender;
- (IBAction)postToFacebook:(id)sender;

@end