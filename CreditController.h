//
//  CreditController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 01/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PayPalMobile.h"

@interface CreditController : UIViewController<PayPalPaymentDelegate>{
    IBOutlet UIButton *menubtn,*paybtn,*hisbtn,*pickbtn,*back;
    IBOutlet UILabel *amttxt;
    IBOutlet UILabel *creditamt,*cartlbl;
    IBOutlet UIPickerView *picker;
    IBOutlet UIView *pvw;
    IBOutlet UITableView *table;
    
    IBOutlet UIView *noticeView;
    IBOutlet UILabel *txtEntidade;
    IBOutlet UILabel *txtRef;
    IBOutlet UILabel *txtValue;
    
    IBOutlet UIView *mbConfirmView;
    IBOutlet UITextField *editPhoneNumber;
    IBOutlet UILabel *txtMbwayInfo;
    IBOutlet UIButton *btnPhoneOk;
}
@property(nonatomic,strong)NSString *str;
@end
