//
//  ProductDetail_ViewController.h
//  Homem De Pao
//
//  Created by Itgenesys on 10/21/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetail_ViewController : UIViewController{
    IBOutlet UILabel *toplbl;
    
    IBOutlet UIView *vw,*plusvw;
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *addcartbtn;
}
@property(nonatomic,weak) IBOutlet UILabel *cart_label;
@property (weak,nonatomic) IBOutlet NSString* proName_str;
@property (weak,nonatomic) IBOutlet NSString* proDescrip_str;
@property (weak,nonatomic) IBOutlet NSString* proPrice_str;
@property (weak,nonatomic) IBOutlet NSString* proImage_str;
@property (weak,nonatomic) IBOutlet NSString* proID_str;

@property (weak,nonatomic) IBOutlet UIImageView* proImage;
@property (weak,nonatomic) IBOutlet UILabel *desLabel;
@property (weak,nonatomic) IBOutlet UILabel *nameLabel;
@property (weak,nonatomic) IBOutlet UILabel *priceLabel;
@property(weak,nonatomic) IBOutlet UILabel *btnCount_label;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic) int recordIDToEdit;

@end
