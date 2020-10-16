//
//  PaymentconfController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 04/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentconfController : UIViewController{
    IBOutlet UILabel *amtlbl;
    IBOutlet UIButton  *paycredit,*paystore,*back;
}
@property(nonatomic,strong)NSString *datestr,*timestr,*flagstr,*subid,*amt,*days;



@end
