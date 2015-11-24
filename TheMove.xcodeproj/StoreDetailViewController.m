//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MapAnnotation.h"
#import "SCViewController.h"
#import <Social/Social.h>




@interface StoreDetailViewController () <MKMapViewDelegate>




@property (weak, nonatomic) IBOutlet UILabel *titleLabelD;
@property (nonatomic, retain)  IBOutlet UIImageView *imaj;
@property (weak, nonatomic) IBOutlet UITextView *descriptionLabelD;
@property (weak, nonatomic) IBOutlet UILabel *dateLabeli;
@property (nonatomic, strong) IBOutlet  UIImageView *shows;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *web;
@property (weak, nonatomic) IBOutlet UILabel *phone;


@end


@implementation StoreDetailViewController
@synthesize fbView,twView;


NSString *webim;
NSString *phone;
NSString * tit;
NSNumber * longa;
NSNumber * lota;
NSString * descim;
NSString * mailim;


- (void)viewDidLoad
{

    
    [super viewDidLoad];
    
    
    NSArray *modelsAsArray = [self.StoreList.title componentsSeparatedByString:@"||"];
    
  

    NSString *tits = [modelsAsArray objectAtIndex:0];
    NSString *desc = [modelsAsArray objectAtIndex:3];
    NSString *imgem = [modelsAsArray objectAtIndex:4];
    NSString *rate = [modelsAsArray objectAtIndex:5];
    NSString *email = [modelsAsArray objectAtIndex:6];
    webim = [modelsAsArray objectAtIndex:10];
    phone = [modelsAsArray objectAtIndex:7];
    mailim = [modelsAsArray objectAtIndex:6];
    
    tit = tits;
    
    
    self.web.text = webim;
    self.phone.text = phone;
    
    self.descriptionLabelD.text = desc;

    
    self.imaj.image = [UIImage imageNamed:rate];
    
    
    NSString *ImageURL = imgem;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.shows.image = [UIImage imageWithData:imageData];
    

    self.titleLabelD.text = tit;
    
    self.email.text = email;

    
    }



- (IBAction)postToTwitter:(id)sender {
    
    
    
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [tweetSheet setInitialText:tit];
    [tweetSheet addURL:[NSURL URLWithString:webim]];
    [tweetSheet addImage:self.shows.image];
    [self presentViewController:tweetSheet animated:YES completion:nil];
    
}

- (IBAction)postToFacebook:(id)sender {
    
    
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [controller setInitialText:tit];
    [controller addURL:[NSURL URLWithString:webim]];
    [controller addImage:self.shows.image];
    [self presentViewController:controller animated:YES completion:Nil];
    
}






-(void)sendMail:(id)sender{
    

    
    //This checks to make sure the device can send email (messages).
    if ([MFMailComposeViewController canSendMail]) {
        
        //Creates a MFMailComposeViewController object and initializes it.
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        //Sets our controller (self) to be the delegate of our MFMailComposeViewController object.
        mail.mailComposeDelegate = self;
        
        //Sets the subject.
        [mail setSubject:(tit)];
        
        //We start by creating an array of emails. We can add more if needed.
        NSArray *toRecipients = [NSArray arrayWithObject:(mailim)];
        
        //Then we add the array of emails to the Recipient field of our MFMailComposeViewController object.
        [mail setToRecipients:toRecipients];
        
        //We create a string that will be placed in the body of the message.
        NSString *emailBody = @"I want to visit your store, i like your store";
        
        //We set our string to the message body.
        //We say NO for HTML because this is for more complex messages with things like images.
        [mail setMessageBody:emailBody isHTML:NO];
        
        //This presents the MFMailComposeViewController object.
        mail.modalPresentationStyle = UIModalPresentationPageSheet;
        [self presentViewController:mail animated:YES completion:nil];
        
    } else {
        
        //This alert tells the user they can't send email on their device.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Run AWAY!" message:@"Fix it!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [alert show];
        
    
        }
    }


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    //We create a switch that responds to the four messages our MFMailComposeViewController object will send.
    
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Saved");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Faild");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Sent");
            break;
        default:
            NSLog(@"Default");
            break;
    }
    
    //Finally we dismiss the view controller.
    [self dismissViewControllerAnimated:YES completion:nil];
    
}





- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SCViewController *vc = [segue destinationViewController];
            //Look at the viewDidLoad in the Destination implementation.
    
    vc.descriptionf = self.StoreList.title;
  
    
}


@end