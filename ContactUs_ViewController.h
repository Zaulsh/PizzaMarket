//
//  ContactUs_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/21/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface ContactUs_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UIButton *callbtn,*menubtn,*disbtn;
    IBOutlet UITableView *menu;
    IBOutlet UILabel *namestr,*emailstr;
    IBOutlet UIView *menuvw;
}
@property(weak,nonatomic) IBOutlet UIScrollView *scrollViewChildDetail;

@property (weak, nonatomic) IBOutlet UITextField *name_txt;
@property (weak, nonatomic) IBOutlet UITextField *contact_txt;
@property (weak, nonatomic) IBOutlet UITextField *email_txt;
@property (weak, nonatomic) IBOutlet UITextView *descrip_txt;
- (IBAction)Send:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
