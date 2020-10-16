//
//  FixedPlans_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/15/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedPlans_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet NSMutableArray *FixedplanID_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *FixedplanName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *FixedplanImage_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *FixedplanDescription_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *FixedplanPrice_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *SubscriptionName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *ProductID_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *ProductName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *ProductPrice_array;

@property(weak,nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(weak,nonatomic) IBOutlet UIView *indi_view;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
