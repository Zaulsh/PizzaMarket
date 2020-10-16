//
//  Registration_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/19/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Registration_ViewController : UIViewController{
    IBOutlet UIButton *regbtn;
    IBOutlet UIView *vw,*postvw;
    
    
    IBOutlet UITableView *table;
    
}
@property(weak,nonatomic) IBOutlet UIScrollView *scrollViewChildDetail;
@property (weak, nonatomic) IBOutlet UITextField *username_txt;
@property (weak, nonatomic) IBOutlet UITextField *contact_txt;
@property (weak, nonatomic) IBOutlet UITextField *email_txt;
@property (weak, nonatomic) IBOutlet UITextField *pass_txt;
@property (weak, nonatomic) IBOutlet UITextField *conpass_txt;
@property(weak,nonatomic) IBOutlet UITextField *address_txt;
@property (weak, nonatomic) IBOutlet UITextField *taxno_txt;
@property(weak,nonatomic) IBOutlet UITextField *postcode;
- (IBAction)signup:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@end
