//
//  SubdetailController.m
//  Homem De Pao
//
//  Created by BGMacMIni2 on 24/05/18.
//  Copyright © 2018 itgenesys. All rights reserved.
//

#import "SubdetailController.h"
#import "MBProgressHUD.h"
#import "UIView+Toast.h"
#import "SubdetailCell.h"
#import "SubdescriptionController.h"
#import "StringConstants.h"

@interface SubdetailController ()<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
    NSMutableArray *listary;
    int pageno;
}

@end

@implementation SubdetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [backbtn addTarget:self action:@selector(menubtn:) forControlEvents:UIControlEventTouchUpInside];
      collection.hidden=YES;
        nolbl.hidden=YES;
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    listary=[[NSMutableArray alloc]init];
    pageno=0;
    [self show];
}

-(void)show{
    NSString *userid=[self get_shareddata:@"ID"];
   
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.labelText =@"A carregar...";
    HUD.delegate = self;
    [self.view addSubview:HUD];
    [HUD show:YES];
  
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
   
    NSString *path = [NSString stringWithFormat:@"%@orderdeliveries?", BASE_URL];
    NSLog(@"%@",path);
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:path]];
    [request setHTTPMethod:@"POST"];
    NSLog(@"%@",request);
    
    NSString *value = [NSString stringWithFormat:@"&PNO=%d&userid=%@",pageno,userid];
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
                                                                NSArray  *listary1=[userdetails valueForKey:@"orderdeliverylist"];
                                                                      
                                                                      if(listary1.count>0){
                                                                            [collection reloadData];
                                                                      
                                                                      [listary addObjectsFromArray:listary1];
                                                                      
                                                                      if(listary.count>0){
                                                                          collection.hidden=NO;
                                                                          nolbl.hidden=YES;
                                                                      }else{
                                                                          collection.hidden=YES;
                                                                          nolbl.hidden=NO;
                                                                      }
                                                                    
                                                                      }
                                                                      
                                                                  }else{
                                                                      if(listary.count>0){
                                                                          collection.hidden=NO;
                                                                          nolbl.hidden=YES;
                                                                      }else{
                                                                          collection.hidden=YES;
                                                                          nolbl.hidden=NO;
                                                                      }
                                                                    //  [self.view makeToast:message duration:3.0 position:CSToastPositionBottom];
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


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath

{
        return CGSizeMake(collection.frame.size.width/2-5, 125);
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
        return [listary count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
  
        SubdetailCell *cell = [collection dequeueReusableCellWithReuseIdentifier:@"SubdetailCell" forIndexPath:indexPath];
 //   cell.vw.layer.borderWidth = 0.5;
   // cell.vw.layer.borderColor=[UIColor lightGrayColor].CGColor;
    cell.vw.layer.cornerRadius = 5;
    cell.vw.clipsToBounds = YES;
    cell.name.text=[NSString stringWithFormat:@" Dia %ld",indexPath.row +1];
    cell.date.text=[NSString stringWithFormat:@"%@",[[listary objectAtIndex:indexPath.row]valueForKey:@"OrderDeliveryDate"]];
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    cell.lbl.text=@"Toque para ver ou atualizar";
    
    
    if (indexPath.row == [listary count]-1) {
        if (pageno<=[listary count]) {
            pageno = pageno + 1;
            
            [self show];
            
        }
    }
    
        return cell;
   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *ary=[[listary objectAtIndex:indexPath.row]valueForKey:@"datedelivery"];
    if(ary.count>0){
        SubdescriptionController *c=[self.storyboard instantiateViewControllerWithIdentifier:@"SubdescriptionController"];
        c.listary =[[listary objectAtIndex:indexPath.row]valueForKey:@"datedelivery"];
        c.count=[NSString stringWithFormat:@"%ld",indexPath.row+1];
        c.indexc=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
        [self.navigationController pushViewController:c animated:YES];
    }

    
    
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
