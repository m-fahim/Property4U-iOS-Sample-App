//
//  DynamicViewController.h
//  Property4U
//
//  Created by mfahim on 02/04/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Configuration.h"

@interface DynamicViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableData;
}

@property (nonatomic, retain) NSString * typeController;
@property (nonatomic, retain) NSString * typeAPI;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *typeToolbar;

- (IBAction)menuBtnS:(id)sender;

- (IBAction)menuBtnNewProperty:(id)sender;

- (Configuration *)loadCustomObjectWithKey:(NSString *)key;

@end
