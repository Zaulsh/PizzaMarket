//
//  FAQ_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/25/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "FAQ_ViewController.h"
#import "SWRevealViewController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "ItemCell.h"
#import "StringConstants.h"

@interface FAQ_ViewController ()<MBProgressHUDDelegate>{
    NSMutableArray *question_array;
    NSMutableArray *answer_array;
    NSMutableArray *id_array;
    NSString *ss1;
    MBProgressHUD *HUD;
    NSMutableArray *listary,*searchary;
    int num;
}

@end

@implementation FAQ_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //add label in toolbar
//    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(200,8,200,30)];
//    navLabel.text = @"My Text";
//    navLabel.textColor = [UIColor redColor];
//    [self.navigationController.navigationBar addSubview:navLabel];
//    [navLabel setBackgroundColor:[UIColor clearColor]];
//    [self.view addSubview:self.navigationController.navigationBar];
  //  [menubtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
    listary=[[NSMutableArray alloc]init];
    searchary=[[NSMutableArray alloc]init];

    _pagenum = 0;
    num=0;
    svw.layer.borderWidth=0.5;
    svw.layer.borderColor=[UIColor colorWithRed:64/255.0 green:30/255.0 blue:7/255.0 alpha:1].CGColor;
    svw.layer.cornerRadius=5;
  //  self.tableview.layer.borderWidth=0.5;
   // self.tableview.layer.borderColor=[UIColor lightGrayColor].CGColor;
    
    [self.view endEditing:YES];

    SWRevealViewController *revealViewController = self.revealViewController;

    if ( revealViewController )
    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [menubtn addTarget:self.revealViewController action:@selector(revealToggle:) forControlEvents:UIControlEventTouchUpInside];
  //  [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self show:_pagenum];
   // [self.tableview reloadData];
    [self wallet];
    
    // Do any additional setup after loading the view.
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
                                                              //   [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              //  [self.view makeToast:@"Verifique a conexão com a Internet" duration:3.0 position:CSToastPositionBottom];                                                                  //couldn't download
                                                              
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
-(void)menubtn:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)show:(int) pagenum {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@get_faq", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%d",_pagenum];
    NSLog(@"value:%@",value);
    value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
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
                                                                      NSMutableArray *tmp = [userdetails valueForKey:@"faqlist"];
                                                                      if(listary == nil){
                                                                          listary = tmp;
                                                                          searchary = tmp;
                                                                      }else{
                                                                          [listary addObjectsFromArray:tmp];
                                                                          [searchary addObjectsFromArray:tmp];
                                                                      }
                                                                     
                                                                      if([tmp count] >= 10 ){
                                                                          _pagenum++;
                                                                          [self show:_pagenum];
                                                                      }
                                                                      else{
                                                                        [self.tableview reloadData];
                                                                          NSLog(@"ary %@",listary);
                                                                      }

                                                                      
                                                                  }else{
                                                                      [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    
    return [listary count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(indexPath.row == num){

        NSString *lbl=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"FaqAnswer"]];
      //  CGFloat dataTextHeight = [self getLabelHeightForIndex:lbl];
     //   lbl = [lbl stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

      //  UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:17.0];
      //  CGSize constraintSize = CGSizeMake(self.tableview.frame.size.width-15, MAXFLOAT);
       // CGSize dataTextHeight = [lbl sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
       // NSLog(@"ro wheight %d :%f",indexPath.row,dataTextHeight.height);
        CGSize dataTextHeight = [lbl sizeWithFont:[UIFont fontWithName:@"Oswald-Regular" size:14]
                      constrainedToSize:CGSizeMake(self.tableview.frame.size.width - 15, CGFLOAT_MAX) // - 40 For cell padding
                          lineBreakMode:NSLineBreakByWordWrapping];
        return dataTextHeight.height + 70;
    }else{
     
        return 50;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *identifier = @"ItemCell";
    ItemCell *cell = (ItemCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ItemCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if(indexPath.row == num){
        cell.price.hidden =NO;
    }else{
        cell.price.hidden=YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.name.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"FaqQuestion"]];
     NSString *lbl=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"FaqAnswer"]];
       lbl = [lbl stringByReplacingOccurrencesOfString:@"\n" withString:@" "];

   
   //   CGFloat dataTextHeight = [self getLabelHeightForIndex:lbl];
    //  NSLog(@"%f",dataTextHeight);
    
  //  UIFont *cellFont = cell.price.font;
  //  CGSize constraintSize = CGSizeMake(self.tableview.frame.size.width-15, MAXFLOAT);
 //   CGSize labelSize = [lbl sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
   // cell.price.frame.size.height = labelSize.height;
    
    CGSize labelSize = [lbl sizeWithFont:[UIFont fontWithName:@"Oswald-Regular" size:14]
                            constrainedToSize:CGSizeMake(self.tableview.frame.size.width - 15, CGFLOAT_MAX) // - 40 For cell padding
                                lineBreakMode:NSLineBreakByWordWrapping];
    cell.price.text = lbl;
    cell.price.frame=CGRectMake(cell.price.frame.origin.x, cell.price.frame.origin.y, cell.price.frame.size.width, labelSize.height);
   // cell.price.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"FaqAnswer"]];
  //  [cell.price sizeToFit];

    
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  ss1=[answer_array objectAtIndex:indexPath.row];
   // NSLog(@"++++++++++++image++++++++++++%@",ss1);
   // self.answer_label.text=ss1;
    [self.view endEditing:YES];
    num=indexPath.row;
    [self.tableview reloadData];
}

-(CGFloat)getLabelHeightForIndex:(NSString *)string
{
    CGSize maximumSize = CGSizeMake(280.0f, 10000);
    
    CGSize labelHeightSize = [string sizeWithFont:[UIFont fontWithName:@"system" size:14.0f] constrainedToSize:maximumSize lineBreakMode:NSLineBreakByWordWrapping];
    

    
    return labelHeightSize.height;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField canResignFirstResponder]) {
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *searchKey = [textField.text stringByAppendingString:string];
    NSLog(@"%@",searchKey);
    listary = nil;
    searchKey = [searchKey stringByReplacingCharactersInRange:range withString:@""];
    if (searchKey.length) {
     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FaqAnswer CONTAINS[c] %@ OR FaqQuestion CONTAINS[c] %@", searchKey,searchKey];
        NSArray *ar1 = [searchary filteredArrayUsingPredicate:predicate];
        listary = [NSMutableArray arrayWithArray:ar1];
        num=0;
        
    }
    else{
        listary = searchary;
    }

    
    if(listary.count>0){
        self.tableview.hidden=NO;
    }else{
        self.tableview.hidden=YES;
    }
    [self.tableview reloadData];
    
    
//    if([searchKey isEqualToString:@""]){
//
//        listary = searchary;
//        if(listary.count>0){
//            self.tableview.hidden=NO;
//        }else{
//            self.tableview.hidden=YES;
//        }
//        NSLog(@"search : %@",searchary);
//        [self.tableview reloadData];
//    }else{
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"FaqAnswer CONTAINS[c] %@ OR FaqQuestion CONTAINS[c] %@", searchKey,searchKey];
//        NSArray *ar1 = [searchary filteredArrayUsingPredicate:predicate];
//        listary = [NSMutableArray arrayWithArray:ar1];
//        num=0;
    
    

   
    
     return YES;
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
