//
//  PaystoreController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 04/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "PaystoreController.h"
#import "Featured_ViewController.h"
#import "SWRevealViewController.h"
@interface PaystoreController (){
    
}

@end

@implementation PaystoreController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [loc1 addTarget:self action:@selector(loc1:) forControlEvents:UIControlEventTouchUpInside];
    [loc2 addTarget:self action:@selector(loc2:) forControlEvents:UIControlEventTouchUpInside];
    [loc3 addTarget:self action:@selector(loc3:) forControlEvents:UIControlEventTouchUpInside];
    [finalbtn addTarget:self action:@selector(finalbtn:) forControlEvents:UIControlEventTouchUpInside];

   
    
}
-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)finalbtn:(id)sender{
    
  //  Featured_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Featured_ViewController"];
  //  [self.navigationController pushViewController:event animated:NO];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController pushViewController:view animated:YES];
    
}
-(void)loc1:(id)sender{
    NSString *string = [NSString stringWithFormat:@"https://www.google.com/maps/place/38.738086,-9.122505"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
    
}
-(void)loc2:(id)sender{
    NSString *string = [NSString stringWithFormat:@"https://www.google.com/maps/place/38.728623,-9.125064"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}
-(void)loc3:(id)sender{
    NSString *string = [NSString stringWithFormat:@"https://www.google.com/maps/place/38.754507,-9.200664"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:string]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
