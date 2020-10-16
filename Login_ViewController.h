//
//  Login_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/19/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Login_ViewController : UIViewController{
    IBOutlet UILabel *lbl1;
    IBOutlet UIButton *regbtn,*back;
    
}
@property(weak,nonatomic) IBOutlet UIScrollView *scrollViewChildDetail;
@property(weak,nonatomic)IBOutlet UITextField *username_txt;
@property(weak,nonatomic)IBOutlet UITextField *pass_txt;

@property(weak,nonatomic) IBOutlet NSString *user_str;
@property(weak,nonatomic) IBOutlet NSString *pass_str;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property(weak, nonatomic) IBOutlet UIView *forgot_view;
@property(weak, nonatomic) IBOutlet UITextField *forgot_txt;
@end
