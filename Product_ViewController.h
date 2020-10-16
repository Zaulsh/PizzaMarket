//
//  Product_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/24/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Product_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UITextFieldDelegate,UIGestureRecognizerDelegate>{
    IBOutlet UIView *menuvw,*filtervw;
    IBOutlet UILabel *name,*email;
    IBOutlet UITableView *menu,*filtertbl;
    IBOutlet UIButton *disbtn,*menubtn,*filterbtn,*fcancel;
    IBOutlet UIButton *searchbtn;
    IBOutlet UITextField *searchTextField;
    IBOutlet UIView *noResultsView;
}

@property BOOL shouldInitiallyFocusSearchField;

@property(nonatomic,weak) IBOutlet UILabel *cart_label;

@property (strong, nonatomic) IBOutlet NSMutableArray *proDescrip_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *profeatured_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *proName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *SizeName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *suppName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *typeName_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *proImage_array;
@property (strong, nonatomic) IBOutlet NSMutableArray *proPrice_array;

@property(weak,nonatomic) IBOutlet UITableView *tableview;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end
