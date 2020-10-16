//
//  DeliverySchedule_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 11/29/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeliverySchedule_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(weak,nonatomic) IBOutlet UIView *indi_view;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(weak,nonatomic) IBOutlet UITableView *tableview;
@property(weak,nonatomic) IBOutlet NSString *orderid_str;
@property(weak,nonatomic) IBOutlet UIView *calender_view;
@property (strong, nonatomic) IBOutlet UIDatePicker *datepicker;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_btn;
@property (strong, nonatomic) IBOutlet UITextField *Date_label;

@end
