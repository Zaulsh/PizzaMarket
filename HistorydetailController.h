//
//  HistorydetailController.h
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistorydetailController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    IBOutlet UILabel *lbl1,*lbl2,*lbl3,*lbl4,*lbl5,*lbl6;
    IBOutlet UIButton *back;
    IBOutlet UITableView *table;
}
@property(nonatomic,strong)NSArray *listary;
@end
