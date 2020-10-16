//
//  Featured_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/15/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Featured_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    IBOutlet UIButton *menubtn;
    IBOutlet UIButton *addcart;
    IBOutlet UIButton *disbtn;
    IBOutlet UIButton *searchbtn;
    IBOutlet UILabel *cartcount;
    IBOutlet UIView *menuvw;
    IBOutlet UILabel *name,*email;
    IBOutlet UITableView *menu;
}

@property(weak,nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


@property (nonatomic) int recordIDToEdit;
//@property (nonatomic, assign) NSInteger counter;
@end
