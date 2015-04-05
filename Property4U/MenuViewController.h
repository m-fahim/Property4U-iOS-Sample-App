//
//  MenuViewController.h
//  Property4U
//
//  Created by mfahim on 20/02/2015.
//  Copyright (c) 2015 mfahim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController <UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource> {
    
    IBOutlet UITableView *tableData;
    
}
- (IBAction)homeBtn:(id)sender;

@end
