//
//  Registration_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/19/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "Registration_ViewController.h"
#import "SWRevealViewController.h"
#import "Login_ViewController.h"
#import "UIView+Toast.h"
#import "MBProgressHUD.h"
#import "Featured_ViewController.h"
#import "AppDelegate.h"
#import "PostalCell.h"
#import "StringConstants.h"

@interface Registration_ViewController ()<MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>{
    MBProgressHUD *HUD;
    NSMutableArray *listary,*searchary,*postalcode;
    
    
}

@end

@implementation Registration_ViewController
@synthesize username_txt,pass_txt,conpass_txt,email_txt,contact_txt,scrollViewChildDetail;
- (void)viewDidLoad {
    [super viewDidLoad];
    table.hidden=YES;
    
    listary=[[NSMutableArray alloc]init];
    searchary=[[NSMutableArray alloc]init];
    postalcode=[[NSMutableArray alloc]init];

    
    table.layer.cornerRadius=4;
    
//    SWRevealViewController *revealViewController = self.revealViewController;
//
//    if ( revealViewController )
//    {
//        [self.sidebarButton setTarget: self.revealViewController];
//        [self.sidebarButton setAction: @selector( revealToggle: )];
//        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
//    }

    // Do any additional setup after loading the view.
    
    
    [_postcode addTarget:self action:@selector(postcodebtn:) forControlEvents:UIControlEventEditingChanged];
    [scrollViewChildDetail setScrollEnabled:YES];
    [scrollViewChildDetail setContentSize:CGSizeMake(self.view.frame.size.width, vw.frame.size.height+vw.frame.origin.y)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardDidHideNotification object:nil];
    
    //hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    [self getpostcode];
    
    
    // Do any additional setup after loading the view.
}

- (void)postcodebtn:(UITextField *)textField {
    NSLog(@"post code text changed: %@", textField.text);

//    if([textField.text length]==4){
//        textField.text=[NSString stringWithFormat:@"%@-",textField.text];
//
//    }
//    if(text){
//
//    }
  
}

-(void)getpostcode{
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@getpostalcode", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
  //  NSString *value = [NSString stringWithFormat:@"&userid=%@",[self get_shareddata:@"ID"]];
   // NSLog(@"value:%@",value);
  //  value = [value stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    //  value = [value stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    
 //   [request setHTTPBody:[value dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionDataTask *dataTask =[defaultSession dataTaskWithRequest:request
                                                      completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError) {
                                                          [HUD hide:YES];
                                                          
                                                          if (!connectionError || data.length > 0) {
                                                              NSLog(@"going to process");
                                                              NSArray* userdetails = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&connectionError];
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  NSLog(@"postalcode = %@", userdetails);
                                                                  
                                                                  NSString *successs = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"status"]];
                                                                  NSString *message = [NSString stringWithFormat:@"%@",[userdetails valueForKey:@"msg"]];
                                                                  //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  if([successs isEqualToString:@"1"]){
                                                                      
                                                                      listary=[userdetails valueForKey:@"postalcode"];
                                                                      searchary=[userdetails valueForKey:@"postalcode"];
                                                                      postalcode=[[userdetails valueForKey:@"postalcode"] valueForKey:@"PostalCode"];
                                                                     // NSString *wall=[NSString stringWithFormat:@"%@",[userdetails valueForKey:@"total"]];
                                                                     // [self sharedata:@"wallet" :wall];
                                                                      
                                                                      
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
-(void)dismissKeyboard {
    
    table.hidden=YES;
    [self.username_txt resignFirstResponder];
    [self.pass_txt resignFirstResponder];
    [self.conpass_txt resignFirstResponder];
    [self.email_txt resignFirstResponder];
    [self.contact_txt resignFirstResponder];
    [self.address_txt resignFirstResponder];
    [self.postcode resignFirstResponder];
    
}

-(void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollViewChildDetail.contentInset = contentInsets;
    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
}
-(void)keyboardWasShown:(NSNotification*)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.view.frame.origin.x,self.view.frame.origin.y, kbSize.height+100, 0);
    self.scrollViewChildDetail.contentInset = contentInsets;
    self.scrollViewChildDetail.scrollIndicatorInsets = contentInsets;
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

- (IBAction)signup:(id)sender {
    table.hidden=YES;
    [self.username_txt resignFirstResponder];
    [self.pass_txt resignFirstResponder];
    [self.conpass_txt resignFirstResponder];
    [self.email_txt resignFirstResponder];
    [self.contact_txt resignFirstResponder];
    [self.address_txt resignFirstResponder];
    [self.postcode resignFirstResponder];
    
    NSString *pass=[NSString stringWithFormat:@"%@",pass_txt.text];
    NSString *cpass=[NSString stringWithFormat:@"%@",conpass_txt.text];
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if([username_txt.text isEqualToString:@""]){
        [self.view makeToast:@"Nome Completo deve ser preenchido" duration:3.0 position:CSToastPositionBottom];
        
    }
    else if([email_txt.text isEqualToString:@""]){
        [self.view makeToast:@"Por Introduza válido Email" duration:3.0 position:CSToastPositionBottom];

    }else if ([emailTest evaluateWithObject:email_txt.text] == NO){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        
        [self.view makeToast:@"por Introduza válido email" duration:3.0 position:CSToastPositionBottom];
    }
    else if ([self.address_txt.text isEqualToString:@""]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        
        [self.view makeToast:@"Por Introduza Morada Completa" duration:3.0 position:CSToastPositionBottom];
    } else if ([self.postcode.text isEqualToString:@""]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        [self.view makeToast:@"Por Introduza Código Postal" duration:3.0 position:CSToastPositionBottom];
    }
//    }else if (![postalcode containsObject:self.postcode.text]){
//        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
//        [self.view makeToast:@"Digite o código postal válido" duration:3.0 position:CSToastPositionBottom];
//    }
    else if ([self.contact_txt.text isEqualToString:@""]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        [self.view makeToast:@"Por Introduza Telemovel" duration:3.0 position:CSToastPositionBottom];
    }
    else if ([self.taxno_txt.text isEqualToString:@""]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        [self.view makeToast:@"Por Introduza NIF" duration:3.0 position:CSToastPositionBottom];
    }
    else if ([self.pass_txt.text isEqualToString:@""]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        [self.view makeToast:@"Palavra-passe vazia" duration:3.0 position:CSToastPositionBottom];
    } else if (![pass isEqualToString:cpass]){
        //  [self alertStatus:@"por Introduza válido email" :@"" :0];
        [self.view makeToast:@"As palavras-passe não coincidem" duration:3.0 position:CSToastPositionBottom];
    }else{
    [self reg];
    }
}

-(void)reg{
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSString *path = [NSString stringWithFormat:@"%@registration", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&fullname=%@&email=%@&password=%@&contactno=%@&postalcode=%@&address=%@&taxno=%@",username_txt.text,email_txt.text,pass_txt.text,contact_txt.text,self.postcode.text,self.address_txt.text, self.taxno_txt];
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
                                                                      
//                                                                      NSDictionary *results = [userdetails valueForKey:@"userlist"];
//                                                                      NSLog(@"%@",results);
//                                                                      NSString *email_str=[results objectForKey:@"email"];
//                                                                      NSLog(@"emailll %@",email_str);
//
//                                                                      NSString *inStr = [NSString stringWithFormat: @"%@", email_str];
//                                                                      NSLog(@"key =====: %@",inStr);
//                                                                      [self sharedata:@"Login" :inStr];
//
//                                                                      NSString *mbnm = [results objectForKey:@"UserMobileNo"];
//                                                                      NSLog(@"key =====: %@",inStr);
//                                                                      [self sharedata:@"mobilenum" :mbnm];
//
//                                                                      NSString *name_str=[results objectForKey:@"UserFullName"];
//                                                                      NSLog(@"emailll %@",name_str);
//                                                                      NSString *inStr1 = [NSString stringWithFormat: @"%@", name_str];
//                                                                      NSLog(@"key =====: %@",inStr1);
//                                                                      [self sharedata:@"Name" :inStr1];
//
//                                                                      NSString *ID_str=[results objectForKey:@"id"];
//                                                                      NSLog(@"emailll %@",ID_str);
//                                                                      NSString *inStr2 = [NSString stringWithFormat: @"%@", ID_str];
//                                                                      NSLog(@"key =====: %@",inStr2);
//                                                                      [self sharedata:@"ID" :inStr2];
                                                                    //  if([successs isEqualToString:@"1"]){
//                                                                          UIStoryboard* mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//
//                                                                          SWRevealViewController *view = [mainStoryBoard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
//                                                                          [self.navigationController pushViewController:view animated:YES];
                                                                     // }
                                                                      
                                                                   //   [[AppDelegate sharedAppDelegate]login];
                                                                      [self alertStatus:message :@"" :0];
                                                                      
                                                                      Login_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
                                                                      
                                                                      //    after_reg1.data=usr1;
                                                                      [self.navigationController pushViewController:after_reg1 animated:NO];
                                                                      
   
                                                                  }
                                                                  
                                                                  
                                                                  else{
                                                                      [self alertStatus:message :@"" :0];
                                                                  }
                                                                  
                                                                  //   [table reloadData];                                                                             [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                                  
                                                              });
                                                              [HUD hide:YES];
                                                              
                                                          }
                                                          else if ([data length] == 0 && connectionError == nil){
                                                              NSLog(@"no data returned");
                                                              [self alertStatus:@"Preencha todos os campos" :@"" :0];
                                                              //no data, but tried
                                                          }
                                                          else if (connectionError != nil)
                                                          {
                                                              NSLog(@"there was a download error");
                                                              [self alertStatus:@"Verifique a conexão com a Internet" :@"" :0];
                                                              //couldn't download
                                                              
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

-(IBAction)backpress:(id)sender{
    Login_ViewController *after_reg1= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
    
    //    after_reg1.data=usr1;
    [self.navigationController pushViewController:after_reg1 animated:NO];
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    tableView.separatorColor = [UIColor clearColor];
    
    return [listary count];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 40;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    static NSString *identifier = @"PostalCell";
    PostalCell *cell = (PostalCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostalCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
   
    
    cell.lbl.text=[[listary objectAtIndex:indexPath.row]valueForKey:@"PostalCode"];
   
    cell.btn.tag=indexPath.row;
    [cell.btn addTarget:self action:@selector(btn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
    
}

-(void)btn:(UIButton *)sender{
    NSLog(@"%d",sender.tag);
    self.postcode.text=[[listary objectAtIndex:sender.tag]valueForKey:@"PostalCode"];
    table.hidden=YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"PostalCode"]);
    
 //   self.postcode.text=[[listary objectAtIndex:indexPath.row]valueForKey:@"PostalCode"];
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField ==_postcode){
    //    table.hidden=NO;
        

    }else{
         table.hidden=YES;
    }
    
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    

    if(textField == _postcode){
        
       
      
        NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        
        
        
        NSLog(@"resultString:%@",resultString);
        NSLog(@"string:%@",string);
        if ([string isEqualToString:@""]) {
            [self svalue];
               return YES;
            //  your actions for deleteBackward actions
        }else{
            if(_postcode.text.length>=8){
                return NO;
            }
            if(range.location == 3){

               _postcode.text=[NSString stringWithFormat:@"%@%@-",_postcode.text,string];
                [self svalue];
                return NO;
            }
           else if(range.location == 4){
                _postcode.text=[NSString stringWithFormat:@"%@-%@",_postcode.text,string];
               [self svalue];
                 return NO;
            }
           else{
               [self svalue];
                return YES;
           }
        }
        
    }else{
        return YES;
    }

        
    
    
    
    return NO;
}
-(void)svalue{
    NSString *searchKey = _postcode.text;
    NSLog(@"%@",searchKey);
    listary = nil;
    //searchKey = [searchKey stringByReplacingCharactersInRange:range withString:@""];
    NSLog(@"%d",searchKey.length);
    
    
    
    
    if (searchKey.length>1) {
        
        NSLog(@"d");
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"PostalCode CONTAINS[c] %@", searchKey];
        NSArray *ar1 = [searchary filteredArrayUsingPredicate:predicate];
        listary = [NSMutableArray arrayWithArray:ar1];
        
        NSLog(@"frame %f list %u ",table.frame.size.height,40*listary.count);
        
        if(listary.count ==1){
            table.frame=CGRectMake(table.frame.origin.x, postvw.frame.origin.y-50, table.frame.size.width,40);
        }else if(listary.count<6){
            table.frame=CGRectMake(table.frame.origin.x, postvw.frame.origin.y-40*listary.count, table.frame.size.width,40*listary.count);
            
        }else{
            table.frame=CGRectMake(table.frame.origin.x, postvw.frame.origin.y-250, table.frame.size.width,250);
            
        }
        
        
        //       table.hidden=NO;
        //  num=0;
        
    }
    else{
        NSLog(@"f");
        
        listary = searchary;
        table.hidden=YES;
    }
    //   NSLog(@"%@",listary);
    
    if(listary.count>0){
        
        if(searchKey.length>1){
            table.hidden=NO;
            
        }else{
            table.hidden=YES;
            
        }
    }else{
        table.hidden=YES;
        
    }
    [table reloadData];
    
    
 
}

@end
