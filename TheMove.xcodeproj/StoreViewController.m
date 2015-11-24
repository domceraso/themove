//
//  TheMove
//
//  Created by Steel City Developers, llc.
//  Copyright (c) 2015 TheMove. All rights reserved.
//

#import "StoreViewController.h"
#import "StoreRequest.h"
#import "Store.h"
#import "StoreCell.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "UIImageView+AFNetworking.h"
#import "UIActivityIndicatorView+AFNetworking.h"
#import "UIAlertView+AFNetworking.h"
#import "AFNetworkReachabilityManager.h"
#import "StoreDetailViewController.h"


static NSInteger const max_pages = 1;


@interface StoreViewController () {
    

    
    
    NSMutableArray *storeList;
    StoreRequest *storeRequest;
    
    UIAlertView *alertDownload;
    UIActivityIndicatorView *act;
    UIActivityIndicatorView *footerActivity;
    
    NSInteger lastPage;
}
@property (nonatomic, retain)  IBOutlet UIImageView *imajkategori;
@property (nonatomic, retain)  IBOutlet UIImageView *imajkategoripad;
@end

@implementation StoreViewController



#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];

#define kFontNavigationTextColour [UIColor colorWithRed: 106.f/255.f green:62.f/255.f blue:29.f/255.f alpha: 1.f];


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        lastPage = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
        
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh CityGuide"];
    [refresh addTarget:self
                action:@selector(refreshView:)
      forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (storeList == nil) {
        storeList = [[NSMutableArray alloc] init];
        
        alertDownload = [[UIAlertView alloc] initWithTitle:@"CityGuide Loading.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [alertDownload setValue:act forKey:@"accessoryView"];
        }
        else {
            act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            act.frame=CGRectMake(135, 50, 16, 16);
            [alertDownload addSubview:act];
        }
        [alertDownload show];
        [act startAnimating];
        
        [self getStoreList];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    storeList = nil;
}

#pragma mark - Privete Methods

- (void)setupTableviewHeaderAndFooter:(NSString *)url userNanme:(NSString *)name
{
    UIView *tableViewHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    
     if (SYSTEM_VERSION_LESS_THAN(@"7.0"))
         
      self.tableView.tableHeaderView = tableViewHeader;
    
    UIView *tableViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
    footerActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [footerActivity setFrame:CGRectMake((320 - footerActivity.frame.size.width) / 2, (45 - footerActivity.frame.size.height) / 2, footerActivity.frame.size.width, footerActivity.frame.size.height)];
    [tableViewFooter addSubview:footerActivity];
    [footerActivity startAnimating];
    [footerActivity setHidden:NO];
    self.tableView.tableFooterView = tableViewFooter;
}

- (void)refreshView:(UIRefreshControl *)refresh
{
    if (storeList == nil)
        storeList = [[NSMutableArray alloc] init];
    
    alertDownload = [[UIAlertView alloc] initWithTitle:@"CityGuide Loading.." message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [alertDownload setValue:act forKey:@"accessoryView"];
    }
    else {
        act = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        act.frame = CGRectMake(135, 50, 16, 16);
        [alertDownload addSubview:act];
    }
    [alertDownload show];
    [act startAnimating];
  
    // only to UI purpose
    lastPage = 0;
    
    [self getStoreList];
    
    [refresh endRefreshing];
}

- (void)getStoreList
{
    if (storeRequest == nil) {
        storeRequest = [[StoreRequest alloc] init];
    }
    
    if (lastPage < max_pages) {
      lastPage=1;
        
        if (footerActivity) {
            [footerActivity startAnimating];
            [footerActivity setHidden:NO];
        }
        
        [storeRequest requestStoreListPage:lastPage response:^(id responseData) {
            if (responseData == nil) {
                if (lastPage == 1)
                    [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Network error occured. Retry later..." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
                [footerActivity stopAnimating];
                [footerActivity setHidden:YES];
            } else {
                // Check if user refresh view
                if (lastPage == 1 && storeList.count > 0)
                    [storeList removeAllObjects];
                
                   [self.tableView reloadData];
       
                for (NSDictionary *dict in responseData) {
                    Store *store = [[Store alloc] init];
                    [store deserializeDictionary:dict];
                    [storeList addObject:store];
                }
      
           
                
                // Tableview footer view activityview configuration
                if (lastPage == 1) {
                    [alertDownload dismissWithClickedButtonIndex:0 animated:YES];
                    
                    Store *store = [storeList objectAtIndex:0];
                    
                    [self setupTableviewHeaderAndFooter:store.userThumbUrl userNanme:store.userName];
                }
                
                [self.tableView reloadData];
            }
        }];
    } else {
        [footerActivity stopAnimating];
        lastPage=1;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return (storeList.count > 0 && storeList)?storeList.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"StoreCell";
    StoreCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[StoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Store *store = [storeList objectAtIndex:indexPath.row];
    
    [cell.activityIndicator startAnimating];
    [cell.activityIndicator setHidden:NO];
    if (store.storeThumb == nil) {
        [storeRequest requestStoreThumb:store.storeThumbUrl success:^(UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                StoreCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                if (updateCell) {
                    updateCell.picImageView.image = image;
                    store.storeThumb = image;
                    [cell.activityIndicator stopAnimating];
                    [cell.activityIndicator setHidden:YES];
                }
            });
        } failure:^{
#ifdef DEBUG
            NSLog(@"Fail download image");
#endif
            cell.picImageView.image = nil;
            store.storeThumb = nil;
            [cell.activityIndicator stopAnimating];
            [cell.activityIndicator setHidden:YES];
        }];
    } else {
        cell.picImageView.image = store.storeThumb;
        [cell.activityIndicator stopAnimating];
        [cell.activityIndicator setHidden:YES];
    }
    
    

  
    NSArray *modelsAsArray = [store.descriptionf componentsSeparatedByString:@"||"];
    
   
    
    
    NSString *tita = [modelsAsArray objectAtIndex:7];
    NSString *desca = [modelsAsArray objectAtIndex:2];
    NSString *tip = [modelsAsArray objectAtIndex:8];

    
    cell.titleLabel.text = tita;
    cell.descriptionLabel.text = store.descriptionf;
    cell.dateLabel.text = store.uploadDate;
    
    cell.picImageView.image = store.storeThumb;
    
    
    cell.descriptionLabel.text = desca;
    
    
    NSString *rate = [modelsAsArray objectAtIndex:4];
    
    NSString *imageName = [NSString stringWithFormat:@"%@.png", rate];
    
   
    
    cell.imaj.image = [UIImage imageNamed:imageName];
    
    
    
    
    NSString *imageName2 = [NSString stringWithFormat:@"cat_%@.png",tip];
    NSString *imageName3 = [NSString stringWithFormat:@"ipadcat_%@.png",tip];
   self.imajkategori.image = [UIImage imageNamed:imageName2];
    self.imajkategoripad.image = [UIImage imageNamed:imageName3];
    

 
    if (indexPath.row == storeList.count - 2) {
        [self getStoreList];
    }
    
    return cell;
}






- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    StoreDetailViewController *vc = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    vc.StoreList = [storeList objectAtIndex:indexPath.row];
    
    
    
}



@end
