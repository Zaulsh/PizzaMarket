//
//  AddCart_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 11/5/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCart_ViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property(weak,nonatomic) IBOutlet UITableView *tblPeople;
@property(weak,nonatomic) IBOutlet UILabel *total_label;
@end
