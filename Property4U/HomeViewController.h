//
//  HomeViewController.h
//  Property4U
//
//  Created by mfahim on 18/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface HomeViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *tableData;
    
}

- (IBAction)userLogout:(id)sender;
- (IBAction)menuBtnS:(id)sender;

- (Configuration *)loadCustomObjectWithKey:(NSString *)key;

@end
