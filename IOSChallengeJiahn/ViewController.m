//
//  ViewController.m
//  IOSIOSChallengeJiahn
//
//  Created by jiahn on 7/18/17.
//  Copyright © 2017 jiahn. All rights reserved.
//
#import "ViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSString+SHA1.h"
#import "OfferWallTableViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *uid;
@property (weak, nonatomic) IBOutlet UITextField *apikey;
@property (weak, nonatomic) IBOutlet UITextField *appid;
@property (weak, nonatomic) IBOutlet UITextField *pub0;
@property (weak, nonatomic) IBOutlet UILabel *subject;
@property (weak, nonatomic) IBOutlet UITextField *title1;
@property (weak, nonatomic) IBOutlet UILabel *teaser;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *hires;
@property (weak, nonatomic) IBOutlet UILabel *payout;

@end

@implementation ViewController

@synthesize uid;
@synthesize apikey;
@synthesize appid;
@synthesize pub0;

@synthesize subject;
@synthesize teaser;
@synthesize payout;
@synthesize thumbnail;
@synthesize hires;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    thumbnail.frame =CGRectMake(0,0,10,10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)submit:(id)sender {
    NSLog(@"%@",uid.text);
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"offerWallTableViewController"]) {
        
        NSMutableDictionary *fields=[[NSMutableDictionary alloc] init];
        [fields setObject:uid.text  forKey:@"uid"];
        [fields setObject:apikey.text  forKey:@"apikey"];
        [fields setObject:appid.text  forKey:@"appid"];
        [fields setObject:pub0.text  forKey:@"pub0"];
        
        OfferWallTableViewController *offerWallTableViewController = (OfferWallTableViewController *)segue.destinationViewController;
        [offerWallTableViewController setFields: fields];
    }
}


-(NSString *)getJson{
    
    NSString *d=@"{\"code\":\" OK\",\"message\":\"OK\",\"count\":1,\"pages\":1,\"information\":{\"app_name\":\"SP Test App\",\"appid\":157,\"virtual_currency\":\"Coins\",\"country\":\" US\",\"language\":\" EN\",\"support_url\":\"http://iframe.fyber.com/mobile/DE/157/my_offers\"},\"offers\":[{\"title\":\"Tap  Fish\",\"offer_id\":13554,\"teaser\":\"Download and START\",\"required_actions\":\"Download and START\",\"link\":\"http://iframe.fyber.com/mbrowser?appid=157&lpid=11387&uid=player1\",\"offer_types\":[{\"offer_type_id\":101,\"readable\":\"Download\"},{\"offer_type_id\":112,\"readable\":\"Free\"}],\"thumbnail\":{\"lowres\":\"http://cdn.fyber.com/assets/1808/icon175x175-2_square_60.png\",\"hires\":\"http://cdn.fyber.com/assets/1808/icon175x175-2_square_175.png\"},\"payout\":90,\"time_to_payout\":{\"amount\":1800,\"readable\":\"30 minutes\"}}]}";
    
    return d;
}

@end
