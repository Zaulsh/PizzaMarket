//
//  Payment_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 11/11/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Payment_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UILabel *lbl1,*lbl2;
    IBOutlet UITableView *subtable,*timetable;
    IBOutlet UIView *subvw,*svw,*altvw,*altvw1,*payvw,*timevw,*timevww;
    IBOutlet UIButton *back,*subvwbtn,*deletebtn,*altok,*altcancel,*altok1,*altcan1,*payok,*paycan,*paydate,*paytime,*timecancel;
    IBOutlet UITextField *pricetxt;
    
}
@property(weak,nonatomic) IBOutlet UITableView *tblPeople;
@property(weak,nonatomic) IBOutlet UILabel *total_label;

@property (weak, nonatomic) IBOutlet UIPickerView *sub_picker;
@property (weak, nonatomic) IBOutlet UIButton *sub_btn;
@property(strong,nonatomic) IBOutlet NSArray *sub_id;
@property(strong,nonatomic) IBOutlet NSArray *pro_id;
@end
