//
//  FAQ_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/25/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQ_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIButton *menubtn;
    IBOutlet UITextField *searchtxt;
    IBOutlet UIView *svw;
    
    
}

@property(weak, nonatomic) IBOutlet UITableView *tableview;
@property(weak, nonatomic) IBOutlet UILabel *answer_label;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property int pagenum;
@end
