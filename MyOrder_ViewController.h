//
//  MyOrder_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 11/28/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyOrder_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property(weak,nonatomic) IBOutlet UIView *indi_view;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property(weak,nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UILabel *cost_label;
@property(weak, nonatomic) IBOutlet UILabel *NoDel_label;
@property(weak, nonatomic) IBOutlet UILabel *Subs_label;
@property(weak,nonatomic) IBOutlet UIButton *drawer_btn;

@end
