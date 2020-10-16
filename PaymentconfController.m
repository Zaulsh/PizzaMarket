//
//  PaymentconfController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 04/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "PaymentconfController.h"
#import "DBManager.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "PaystoreController.h"
#import "SWRevealViewController.h"
#import "CreditController.h"
#import "StringConstants.h"

@interface PaymentconfController ()<MBProgressHUDDelegate>{
    NSString *storestr,*userid;
    NSMutableArray *newArray;
    MBProgressHUD *HUD;
}
@property (nonatomic, strong) DBManager *dbManager;
@end

@implementation PaymentconfController

- (void)viewDidLoad {
    [super viewDidLoad];
    userid=[self get_shareddata:@"ID"];

    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [paycredit addTarget:self action:@selector(paycredit:) forControlEvents:UIControlEventTouchUpInside];
    [paystore addTarget:self action:@selector(paystore:) forControlEvents:UIControlEventTouchUpInside];
    amtlbl.text=[NSString stringWithFormat:@"%@ €",self.amt];
    NSLog(@"%@\n%@\n%@\n%@\n%@\n%@\n",self.amt,_flagstr,self.timestr,self.datestr,self.days,self.subid);
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];

    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loaddata];

    
}
-(void)loaddata{
    
    newArray=[[NSMutableArray alloc]init];
    NSString *query = @"select ProductID,ProQuantity from CardManager";
    NSArray * arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
         NSLog(@"reultttt %@",aa);
            NSMutableDictionary  *proidss = [[NSMutableDictionary alloc] init];
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:0]];
            NSString *tmpObject1=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:1]];
            NSLog(@"obje %@",tmpObject);
            [proidss setValue:tmpObject forKey:@"ID"];
            [proidss setValue:tmpObject1 forKey:@"QTY"];
            [newArray addObject: proidss];
            tmpObject=nil;
            tmpObject1=nil;


        NSLog(@"%@",newArray);
}
}


-(void)back:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(NSString *)get_shareddata:(NSString *)key{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    NSString *currentLevel=@"";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
        //  Doesn't exist.
        //        Doctor_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Doctor_ViewController"];
        //
        //        //    after_reg1.data=usr1;
        //        [self.navigationController pushViewController:after_reg1 animated:NO];
        
    }
    else
    {
        //  Get current level
        currentLevel = [preferences stringForKey:currentLevelKey];
    }
    return currentLevel;
}
- (void) alertStatus:(NSString *)msg :(NSString *)title :(int) tag
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // code here
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = tag;
        [alertView show];
        
    });
}
-(void)paycredit:(id)sender{
    storestr=@"0";
    [self insertorder];
}

-(void)paystore:(id)sender{
    storestr=@"1";
    [self insertorder];
    
}

-(void)insertorder{
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:newArray options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"json %@",jsonData);
    NSError* error;
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@insertoreder?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@&cartlist=%@&subscriptioncost=%@&subscriptionid=%@&days=%@&startdate=%@&time=%@&store=%@",userid,jsonString,self.amt,self.subid,self.days,self.datestr,self.timestr,storestr];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"%7B" withString:@"{"];
    //value = [value stringByReplacingOccurrencesOfString:@"%7D" withString:@"}"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          
                                                          [HUD hide:YES];
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  
                                                                  [self alertStatus:message :@"" :0];
                                                                  //   [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      [self delete];
                                                                      if([storestr isEqualToString:@"0"]){
                                                                          
                                                                          UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                                                          
                                                                          SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
                                                                          [self.navigationController pushViewController:view animated:YES];
                                                                          
                                                                      }else if([storestr isEqualToString:@"1"]){
                                                                          PaystoreController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PaystoreController"];
                                                                          [self.navigationController pushViewController:event animated:NO];
                                                                    
                                                                      }
                                                                     
                                                                  } if([successs isEqualToString:@"0"]){
                                                                     
                                                        
//                                                                      CreditController *view1 = [mainStoryBoard instantiateViewControllerWithIdentifier:@"CreditController"];
//                                                                      SWRevealViewController *revealController = self.revealViewController;
//                                                                      [revealController setFrontViewController:view1];
//                                                                      [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                                                                    CreditController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CreditController"];
                                                                      event.str=@"1";
                                                                      [self.navigationController pushViewController:event animated:NO];
                                                                      
                                                               //      [self.view makeToast:@"Saldo disponível insuficiente Por favor carregue a sua conta" duration:3.0 position:CSToastPositionBottom];
                                                                  }
                                                                  
                                                                  
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
    
    
    
}


-(void)delete{
    NSString *query = [NSString stringWithFormat:@"delete from CardManager"];
    [self.dbManager executeQuery:query];
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
