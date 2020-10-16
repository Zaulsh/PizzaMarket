//
//  AboutUs_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/25/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutUs_ViewController : UIViewController{
    IBOutlet UIButton *menubtn,*disbtn;
    IBOutlet UILabel *lbl;
    IBOutlet UITableView *menu;
    IBOutlet UILabel *name,*email;
    IBOutlet UIView *menuvw;
    
}
@property (strong, nonatomic) IBOutlet UILabel *detail_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property(weak,nonatomic) IBOutlet UIView *indi_view;
@property(weak,nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@end
