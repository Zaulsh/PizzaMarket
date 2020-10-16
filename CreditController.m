//
//  CreditController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 01/06/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "CreditController.h"
#import "CredithistoryController.h"
#import "DBManager.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "HistoryCell.h"
#import "SWRevealViewController.h"
#import "StringConstants.h"

@interface CreditController ()<MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
    NSMutableArray *newArray1;
    MBProgressHUD *HUD;
    NSString *userid;
    NSMutableArray *inputarray;
}
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong, readwrite) PayPalConfiguration *payPalConfiguration;

@end

@implementation CreditController

- (void)viewDidLoad {
    [super viewDidLoad];
    [paybtn addTarget:self action:@selector(paybtn:) forControlEvents:UIControlEventTouchUpInside];
 //   [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    [hisbtn addTarget:self action:@selector(hisbtn:) forControlEvents:UIControlEventTouchUpInside];
    [pickbtn addTarget:self action:@selector(pickbtn:) forControlEvents:UIControlEventTouchUpInside];
    table.hidden=YES;
    userid=[self get_shareddata:@"ID"];
    SWRevealViewController *revealViewController = self.revealViewController;
    
    [noticeView setHidden:YES];
    [mbConfirmView setHidden:YES];
    
     creditamt.text=[NSString stringWithFormat:@"Quantidade de crédito : %@€",@"0.0"];
    
    if([self.str isEqualToString:@"1"]){
        menubtn.hidden=YES;
        back.hidden=NO;
    }else{
        menubtn.hidden=NO;
        back.hidden=YES;
    }
    
    if ( revealViewController )
  {
        //   [self.sidebarButton setTarget: self.revealViewController];
        //  [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];

   // [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   // pvw.layer.borderWidth=1;
   // pvw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    table.layer.borderWidth=1;
    table.layer.borderColor=[UIColor lightGrayColor].CGColor;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];

    // Do any additional setup after loading the view.
}


-(void)back:(id)sender{
    UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    [self.navigationController pushViewController:view animated:YES];
}
-(void)wallet{
    
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_wallet", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@",[self get_shareddata:@"ID"]];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
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
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      
                                                                      NSString *wall=[NSString stringWithFormat:@"%@",[userdetails valueForKey:@"total"]];
                                                                      [self sharedata:@"wallet" :wall];
                                                                      
                                                                      
                                                                      //    walletstr.text=[NSString stringWithFormat:@"Saldo : %@€",[userdetails valueForKey:@"total"]];
                                                                      
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              //   [self.view makeToast:@"Network error" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              //  [self.view makeToast:@"Network error" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    
    [dataTask resume];
    
}

-(void)sharedata:(NSString*)key :(NSString*)value{
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    
    const NSString *currentLevel = value;
    [preferences setValue:currentLevel forKey:currentLevelKey];
    
    //  Save to disk
    const BOOL didSave = [preferences synchronize];
    NSLog(@"key =====: %@", key);
    NSLog(@"value =====: %@", value);
    if (!didSave)
    {
        value=@"";
        //  Couldn't save (I've never seen this happen in real world testing)
    }
    
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _payPalConfiguration = [[PayPalConfiguration alloc] init];
        
        // See PayPalConfiguration.h for details and default values.
        // Should you wish to change any of the values, you can do so here.
        // For example, if you wish to accept PayPal but not payment card payments, then add:
        _payPalConfiguration.acceptCreditCards = YES;
        // Or if you wish to have the user choose a Shipping Address from those already
        // associated with the user's PayPal account, then add:
        _payPalConfiguration.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getwallet];

    [self getrange];
    [self loaddata];
    [self wallet];

  // [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentSandbox];
     [PayPalMobile preconnectWithEnvironment:PayPalEnvironmentProduction];

}
-(void)pickbtn:(id)sender{
    table.hidden=NO;
}
-(void)getrange{
    inputarray =[[NSMutableArray alloc]init];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@get_wallet_range", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@",userid];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          
                                                          //      [HUD hide:YES];
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      inputarray=[userdetails valueForKey:@"range"];
                                                                      
                                                                      if(inputarray.count ==1){
                                                                          table.frame=CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width,40);
                                                                      }else if(inputarray.count<4){
                                                                          table.frame=CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width,40*inputarray.count);
                                                                          
                                                                      }else{
                                                                          table.frame=CGRectMake(table.frame.origin.x, table.frame.origin.y, table.frame.size.width,200);
                                                                          
                                                                      }
                                                                      amttxt.text=[NSString stringWithFormat:@"%@",[inputarray objectAtIndex:0]];
                                                                      [table reloadData];
                                                                      //   creditamt.text=[NSString stringWithFormat:@"Quantidade de crédito : %@€",[userdetails valueForKey:@"total"]];
                                                                      
                                                                  }
                                                                  
                                                              });
                                                              //     [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   // tableView.separatorColor = [UIColor clearColor];
    return [inputarray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 40;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        static NSString *identifier = @"HistoryCell";
        HistoryCell *cell = (HistoryCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HistoryCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //  cell.vw.layer.borderWidth=1;
        // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        cell.lbl1.text=[NSString stringWithFormat:@"%@",[inputarray objectAtIndex:indexPath.row]];
    
        return cell;
  
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
     amttxt.text=[NSString stringWithFormat:@"%@",[inputarray objectAtIndex:indexPath.row]];
     table.hidden=YES;
}
-(void)hisbtn:(id)sender{
     CredithistoryController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"CredithistoryController"];
       [self.navigationController pushViewController:after_reg1 animated:NO];
}
-(void)paybtn:(id)sender{
    [amttxt resignFirstResponder];
    if([amttxt.text isEqualToString:@""]){
        
        [self.view makeToast:@"Enter amount" duration:3.0 position:CSToastPositionBottom];
        
    }else{
    
    PayPalPayment *payment = [[PayPalPayment alloc] init];
    
    // Amount, currency, and description
    payment.amount = [[NSDecimalNumber alloc] initWithString:[NSString stringWithFormat:@"%@",amttxt.text]];
    payment.currencyCode = @"EUR";
    payment.shortDescription = @"Carregamento";
    
  
    payment.intent = PayPalPaymentIntentSale;
    
 
    if (!payment.processable) {
        [self.view makeToast:@"Please enter amount" duration:3.0 position:CSToastPositionBottom];
        // If, for example, the amount was negative or the shortDescription was empty, then
        // this payment would not be processable. You would want to handle that here.
    }else{
    PayPalPaymentViewController *paymentViewController;
    paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment
                                                                   configuration:self.payPalConfiguration
                                                                        delegate:self];
    
    // Present the PayPalPaymentViewController.
        [self presentViewController:paymentViewController animated:YES completion:nil];
        
        
    }
    }
}
- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController
                 didCompletePayment:(PayPalPayment *)completedPayment {
    // Payment was processed successfully; send to server for verification and fulfillment.
    [self verifyCompletedPayment:completedPayment];
    
    // Dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController {
    // The payment was canceled; dismiss the PayPalPaymentViewController.
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)verifyCompletedPayment:(PayPalPayment *)completedPayment {
    // Send the entire confirmation dictionary
    
    NSData *confirmation = [NSJSONSerialization dataWithJSONObject:completedPayment.confirmation
                                                           options:0
                                                             error:nil];
    NSError *error;
    if ([confirmation length] > 0 && error == nil){
        NSError *parseError = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:confirmation options:0 error:&parseError];
        // NSLog(@"Server Response (we want to see a 200 return code) %@",response);
        NSLog(@"dictionary %@",dictionary);
        NSDictionary *  results = [dictionary valueForKey:@"response"];
        NSLog(@"results %@",dictionary);
       
        NSString * donationCat_str = [results objectForKey:@"id"];
        
        NSLog(@"   >>>>>>,,,,category,,, %@",donationCat_str);
       
        NSString *ID_str=[results objectForKey:@"state"];
        NSLog(@"emailll %@",ID_str);
       
    }
    
    
    [self addwallet];
   // ThankYou_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ThankYou_ViewController"];
    
    //    after_reg1.data=usr1;
 //   [self.navigationController pushViewController:after_reg1 animated:NO];
    
   
}


-(void)menubtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString *)get_shareddata:(NSString *)key{
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    NSString *currentLevelKey = key;
    NSString *currentLevel=@"";
    
    if ([preferences objectForKey:currentLevelKey] == nil)
    {
        
    }
    else
    {
        //  Get current level
        currentLevel = [preferences stringForKey:currentLevelKey];
    }
    return currentLevel;
}
-(void)addwallet{
   
  //  HUD = [[MBProgressHUD alloc] initWithView:self.view];
   // HUD.labelText =@"A carregar...";
   // HUD.delegate = self;
   // [self.view addSubview:HUD];
   // [HUD show:YES];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@add_wallet", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@&amt=%@",userid,amttxt.text];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
    [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          
                                                    //      [HUD hide:YES];
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"returnDictionary = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      [self getwallet];
                                                                   //   creditamt.text=[NSString stringWithFormat:@"Quantidade de crédito : %@€",[userdetails valueForKey:@"total"]];
                                                                      
                                                                  }
                                                                  
                                                              });
                                                         //     [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
                                                          }
                                                          
                                                      }];
    [dataTask resume];
}
-(void)getwallet{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
        NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
        NSString *path = [NSString stringWithFormat:@"%@get_wallet", BASE_URL];
        NSLog(@"%@",path);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:path]];
        [request setHTTPMethod:@"POST"];
        NSLog(@"%@",request);
        
        NSString *value = [NSString stringWithFormat:@"&userid=%@",userid];
        NSLog(@"value:%@",value);
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
        
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
                                                                    //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                      
                                                                      if([successs isEqualToString:@"1"]){
                                                                          
                                                                          NSString *wall=[NSString stringWithFormat:@"%@",[userdetails valueForKey:@"total"]];
                                                                          [self sharedata:@"wallet" :wall];
                                                                          creditamt.text=[NSString stringWithFormat:@"Quantidade de crédito : %@€",[userdetails valueForKey:@"total"]];
                                                                          
                                                                         
                                                                          
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
                                                 [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                                  
                                                              }
                                                              
                                                          }];
        [dataTask resume];
    
}
-(void)loaddata{
//    NSString *str;
//    NSString *query = @"select SUM(ProQuantity) from CardManager";
//    NSArray * arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
//
//    NSLog(@"totall %@",arrPeopleInfo);
//
//    for (NSDictionary *try in arrPeopleInfo) {
//
//        NSArray * ssss2=try;
//        str=[NSString stringWithFormat:@"%@",[ssss2 objectAtIndex:0]];
//
//
//    }
//     cartlbl.text=[NSString stringWithFormat:@"%@",str];
//
//    // Get the results.
//
//    NSLog(@"prqua %@",arrPeopleInfo);
    
    NSArray *arrPeopleInfo=[[NSArray alloc]init];
    
    int count = 0;
    NSMutableArray   *newArray1=[[NSMutableArray alloc]init];
    NSString *query = @"select ProQuantity from CardManager";
    
    // Get the results.
    if (arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    NSLog(@"ooooo %@",arrPeopleInfo);
    for (NSDictionary *result in arrPeopleInfo) {
        NSArray *aa=result;
        NSLog(@"reultttt %@",aa);
        for (int i=0;i<[aa count];i++){
            
            NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                 [aa objectAtIndex:i]];
            NSLog(@"temp%@",tmpObject);
            int j=[tmpObject intValue];
            count=count+j;
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray1.count);
        cartlbl.text=[NSString stringWithFormat:@"%d",count];
        
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
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
- (IBAction)btnPayWithIfthenPay:(id)sender {
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@getMultibancoCode", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@&amount=%@",[self get_shareddata:@"ID"], amttxt.text];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"value:%@",value);
    
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
                                                                  NSString *data = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"data"]];
                                                              
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                                                               
                                                                      NSLog(@"data = %@", data);
                                                                      NSArray* dd = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                                                                      NSString *entid = [NSString stringWithFormat:@"%@",[dd valueForKey:@"ent_id"]];
                                                                      NSString *ref = [NSString stringWithFormat:@"%@",[dd valueForKey:@"reference"]];
                                                                      NSString *val= [NSString stringWithFormat:@"%@",[dd valueForKey:@"value"]];
                                                                      NSLog(@"dd = %@/%@/%@", entid, ref, val);
                                                                      
                                                                      [txtEntidade setText:entid];
                                                                      [txtRef setText:ref];
                                                                      [txtValue setText:val];
                                                                      noticeView.hidden = NO;
                                                                      
                                                                      [self getwallet];
                                                                  }
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                          }
                                                          
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                          }
                                                          
                                                      }];
    
    [dataTask resume];
}
- (IBAction)btnPayWithMBway:(id)sender {
    
    mbConfirmView.hidden = NO;
    btnPhoneOk.hidden = NO;
    editPhoneNumber.hidden = NO;
    txtMbwayInfo.text = @"Introduza o seu número de telemóvel";
    
}
- (IBAction)onClickBtnMBwayPhoneConfirm:(id)sender {
    
    NSString *number = editPhoneNumber.text;
    if([number isEqualToString:@""])
        return;
    
     mbConfirmView.hidden = YES;
    
    //[self get_shareddata:@"mobilenum"]
   
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@pay_mb_mobile", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&userid=%@&amount=%@&phone_no=%@",[self get_shareddata:@"ID"], amttxt.text, number];
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"value:%@",value);
    
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
                                                                  NSString *data = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"data"]];

                                                                  if([successs isEqualToString:@"1"]){
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                                                                      data = [data stringByReplacingOccurrencesOfString:@"\\" withString:@""];

                                                                      NSLog(@"data = %@", data);
                                                                      NSArray* dd = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
                                                                      NSString *entid = [NSString stringWithFormat:@"%@",[dd valueForKey:@"ent_id"]];
                                                                      NSString *ref = [NSString stringWithFormat:@"%@",[dd valueForKey:@"reference"]];
                                                                      NSString *val= [NSString stringWithFormat:@"%@",[dd valueForKey:@"value"]];
                                                                      NSLog(@"dd = %@/%@/%@", entid, ref, val);

                                                                      mbConfirmView.hidden = NO;
                                                                      btnPhoneOk.hidden = YES;
                                                                      editPhoneNumber.hidden = YES;
                                                                      txtMbwayInfo.text = @"O seu pedido de pagamento MBway foi enviado. Obrigado";
                                                                      
                                                                      [self getwallet];
                                                                  }

                                                              });
                                                              [HUD hide:YES];
                                                          }

                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                          }

                                                      }];
    
    [dataTask resume];
}

- (IBAction)onClickCloseNoticeView:(id)sender {
    [noticeView setHidden:YES];
}


- (IBAction)onClickCloseMBConfirmView:(id)sender {
    mbConfirmView.hidden = YES;
}

@end
