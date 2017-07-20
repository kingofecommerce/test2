//
//  OfferWallTableViewController.m
//  IOSChallengeJiahn
//
//  Created by jiahn on 7/19/17.
//  Copyright © 2017 jiahn. All rights reserved.
//

#import "OfferWallTableViewController.h"
#import "NSString+SHA1.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>


@interface OfferWallTableViewController ()<UITableViewDataSource, UITableViewDataSource, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *NoDataView;
@property (nonatomic, strong, setter=setFields:) NSMutableDictionary *fields;
@property (nonatomic, strong)  NSDictionary  *content;
@property (nonatomic, weak) IBOutlet UIView *emptyOffersView;
- (void)getOffers;

@end

static NSString *cellIdentifier = @"OfferCustomTableViewCell";
@implementation OfferWallTableViewController
#pragma mark -
#pragma mark - Life Cycle

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName: cellIdentifier bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier: cellIdentifier];
    self.navigationItem.title = @"Offers";
    self.tableView.accessibilityLabel = self.tableView.accessibilityIdentifier =  @"offerTableView";
    [self getOffers];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden: NO animated: YES];
}

- (void)setFields:(NSMutableDictionary *)fields
{
    _fields = fields;
}

#pragma mark -
#pragma mark - Get Offers

- (void)getOffers
{
    //이 부분을 클래스 리팩토링 필요
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(50,300,150,150)];
    spinner.color = [UIColor blueColor];
    spinner.center=self.view.center;
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    NSLog(@"sUid%@",[_fields objectForKey:@"uid"]);
    //테스트를 위해서 아이디 및 다른 정보를 하드코딩해 놓는다. ...
    
    NSString *sAppid=[_fields objectForKey:@"appid"];
    NSString *sUid=[_fields objectForKey:@"uid"];
    //   NSString *ip=@"109.235.143.113";
    NSString *locale=@"DE";
    NSString *device_id=@"";
    //   NSString *ps_time=@"1312211903";
    NSString *sPub0=@"campaign2";
    NSString *timestamp=@"";
    //   NSString *offer_types=@"112";
    NSString *apple_idfa=@"";
    NSString *apple_idfa_tracking_enabled=@"";
    NSString *sapikey=@"1c915e3b5d42d05136185030892fbb846c278927";
    
    device_id=[ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;
    
    timestamp=[NSString stringWithFormat:@"%lu", (long)[[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]] integerValue]];
    
    NSString *os_version =[[UIDevice currentDevice] systemVersion];
    
    NSString *hashData = [NSString stringWithFormat: @"appid=%@&device_id=%@&locale=%@&os_version=%@&pub0=%@&timestamp=%@&uid=%@&%@", sAppid, device_id,locale, os_version, sPub0, timestamp, sUid, sapikey];
    
    
    NSData *data2 = [hashData dataUsingEncoding:NSUTF8StringEncoding];
    NSString *hashkey =[[[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding] sha1];
    
    
    apple_idfa=[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    BOOL dd =[[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
    apple_idfa_tracking_enabled = dd ? @"true" : @"false";
    
    NSString *urlAsString = [NSString stringWithFormat:@"http://api.fyber.com/feed/v1/offers.json?appid=%@&uid=%@&pub0=%@&device_id=%@&locale=%@&os_version=%@&timestamp=%@&hashkey=%@",sAppid,sUid,sPub0,device_id,locale,os_version,timestamp,hashkey];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:urlAsString]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                if (error) {
                    NSLog(@"my error is %@", error);
                    
                } else {
                    //NSLog(@"2222%@", urlAsString);
                    
                    NSHTTPURLResponse* newResp = (NSHTTPURLResponse*)response;
                    //NSLog(@"%d", newResp.statusCode);
                    if (newResp.statusCode == 200) {
                        NSLog(@"normal");
                        //NSLog(@"DATA:\n%@\nEND DATA\n", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
                        
                        NSString *responseBody=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSString *signatureBody=[NSString stringWithFormat:@"%@%@",responseBody,sapikey];
                        
                        NSDictionary *headers = [(NSHTTPURLResponse *)response allHeaderFields];
                        //NSLog(@"%@", headers);
                        //check X-Sponsorpay-Response-Signature
                        NSString *signature=[headers objectForKey:@"X-Sponsorpay-Response-Signature"];
                        NSLog(@"%@", signature);
                        if([signature isEqualToString:[signatureBody sha1]]){
                            NSLog(@"---%@", @"시그니처 키 오케이");
                        }else{
                            NSLog(@"---%@", @"시그니처 키 이상함");
                        }
                        _content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        if( _content.count){
                            [_NoDataView removeFromSuperview];
                            [self.tableView reloadData];
                        }else{
                            [self.view addSubview: _NoDataView];
                        }
                        
                    }else{
                        NSLog(@"abnormal");
                        [self.view addSubview: _NoDataView];
                    }
                
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        [spinner removeFromSuperview];
                    });
                
                }
            }] resume];
    

    
}



#pragma mark
#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *resultsDictionary = [_content objectForKey:@"offers"];
    return   resultsDictionary.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //기본셀을 사용 실제로 하면 커스텀 셀을 사용하여 모양 좋게 하는데
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyCell"];
    }
    //cell.accessibilityLabel = [NSString stringWithFormat:@"Offer %d", indexPath.row];
    NSDictionary *resultsDictionary = [[_content objectForKey:@"offers"] objectAtIndex:indexPath.row];
    NSString *sTitle = [resultsDictionary objectForKey:@"title"];
    NSString *sTeaser = [resultsDictionary objectForKey:@"teaser"];
    NSNumber *sPayout = [resultsDictionary objectForKey:@"payout"];
    NSDictionary *thum = [resultsDictionary objectForKey:@"thumbnail"];
    NSString *lowres=[thum objectForKey:@"lowres"];
    NSString *string = [NSString stringWithFormat:@"Title:%@ / Teaser:%@ / Payout:%@", sTitle,sTeaser,sPayout];
    
    cell.textLabel.text=string;
    //cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 3;
    cell.imageView.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:lowres]]];;
    //Offer *offer = _content[indexPath.row];
    //[cell setOffer: offer];1
    return cell;
    //return nil;
    
}

#pragma mark -
#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 226.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    
    //Offer *offer = _content[indexPath.row];
    //[self performSegueWithIdentifier: @"pushWebView" sender: offer.link];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}
#pragma mark -
#pragma mark - UIAlertView Delegate


@end