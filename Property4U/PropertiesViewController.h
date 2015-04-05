//
//  PropertiesViewController.h
//  Property4U
//
//  Created by mfahim on 20/03/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface PropertiesViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableData;
}

- (IBAction)menuBtnS:(id)sender;

- (IBAction)menuBtnNewProperty:(id)sender;

- (Configuration *)loadCustomObjectWithKey:(NSString *)key;


@property (nonatomic, retain) NSString *userRolePropertiesVC;

@end
