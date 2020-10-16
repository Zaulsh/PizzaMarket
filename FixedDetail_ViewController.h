//
//  FixedDetail_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/24/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixedDetail_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,weak) IBOutlet UILabel *cart_label;

@property(nonatomic, strong) IBOutlet NSMutableArray *proID_array;
@property(nonatomic, strong) IBOutlet NSMutableArray *proName_array;
@property(nonatomic, strong) IBOutlet NSMutableArray *proPrice_array;
@property(nonatomic, strong) IBOutlet NSString *proDescrip_array;

@property(weak,nonatomic) IBOutlet UITableView *tableview;
@property(weak,nonatomic) IBOutlet UILabel *descrip_label;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
