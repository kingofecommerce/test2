//
//  OfferWallTableViewController.h
//  IOSChallengeJiahn
//
//  Created by jiahn on 7/19/17.
//  Copyright © 2017 jiahn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OfferWallTableViewController : UITableViewController

/*!
 * @discussion Custom fields setter
 * @param fields an NSMutableDictionary with the request params
 */
- (void)setFields:(NSMutableDictionary *)fields;

@end
