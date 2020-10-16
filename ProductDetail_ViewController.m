//
//  ProductDetail_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 10/21/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "ProductDetail_ViewController.h"
#import "ViewPager_ViewController.h"
#import "SWRevealViewController.h"
#import "DBManager.h"
#import "AddCart_ViewController.h"
#import "Payment_ViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "Login_ViewController.h"


@interface ProductDetail_ViewController (){
    NSInteger counter;
    NSString *cartacount_str;
    NSMutableArray *newArray,*newArray1;
   
}
@property (nonatomic, strong) DBManager *dbManager;

@end

@implementation ProductDetail_ViewController
@synthesize priceLabel,desLabel,nameLabel,proImage,proPrice_str,btnCount_label,cart_label,proID_str;
- (void)viewDidLoad {
    [super viewDidLoad];
    //add button in toolbar
//    UIButton *settingsBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
//    [settingsBtn setImage:[UIImage imageNamed:@"filter-filled-tool-symbol.png"] forState:UIControlStateNormal];
//    //[settingsBtn addTarget:self action:@selector(settings) forControlEvents:UIControlEventTouchUpInside];
//    [settingsBtn setFrame:CGRectMake(44, 0, 32, 32)];
//    [self.navigationController.navigationBar addSubview:settingsBtn];
    counter = 0;
 //   cartacount_str=[self get_shareddata:@"noti_count"];
   // cart_label.text=cartacount_str;
    NSLog(@"carttt %@",cartacount_str);
    cart_label.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];

//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_proImage_str]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
//        proImage.image = [UIImage imageWithData:data];
//    }];
    
    
    
    NSString *ssss3=[NSString stringWithFormat:@"%@",_proImage_str];
    NSLog(@"img %@",ssss3);
    ssss3  = [ssss3 stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    ssss3= [ssss3 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [proImage sd_setImageWithURL:[NSURL URLWithString:ssss3] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"bread_images.jpg"]]];
    
    
    
    NSLog(@"price %@",proPrice_str);
    NSLog(@"description %@",_proName_str);
    NSLog(@"name %@",_proDescrip_str);
    NSLog(@"image %@",_proImage_str);
     NSLog(@"idddddd %@",proID_str);
    
    NSString *str=self.proDescrip_str;
    nameLabel.text=_proName_str;
    toplbl.text=_proName_str;
  //  desLabel.text=_proDescrip_str;
    CGSize labelSize = [str sizeWithFont:[UIFont fontWithName:@"Oswald-Regular" size:15]
                       constrainedToSize:CGSizeMake(vw.frame.size.width - 15, CGFLOAT_MAX) // - 40 For cell padding
                           lineBreakMode:NSLineBreakByWordWrapping];
    desLabel.text =str;
    desLabel.frame=CGRectMake(desLabel.frame.origin.x, desLabel.frame.origin.y, desLabel.frame.size.width, labelSize.height);
    plusvw.frame=CGRectMake(plusvw.frame.origin.x, desLabel.frame.origin.y+desLabel.frame.size.height+10, plusvw.frame.size.width, plusvw.frame.size.height);
     plusvw.frame=CGRectMake(plusvw.frame.origin.x, desLabel.frame.origin.y+desLabel.frame.size.height+10, plusvw.frame.size.width, plusvw.frame.size.height);
     addcartbtn.frame=CGRectMake(addcartbtn.frame.origin.x, plusvw.frame.origin.y+plusvw.frame.size.height+10, addcartbtn.frame.size.width, plusvw.frame.size.height);

    vw.frame=CGRectMake(vw.frame.origin.x, vw.frame.origin.y, vw.frame.size.width,addcartbtn.frame.size.height+addcartbtn.frame.origin.y);
    scroll.contentSize=CGSizeMake(scroll.frame.size.width, vw.frame.size.height+scroll.frame.origin.y);
    
   
  //  priceLabel.text=[NSString stringWithFormat:@"preço: %@€",proPrice_str];;
    
    NSString *feestr =[NSString stringWithFormat:@"preço : %@€",proPrice_str] ;
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:feestr];
    NSRange range = [feestr rangeOfString:@"preço"];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor  lightGrayColor] range:range];
    priceLabel.attributedText = attString;
    
    SWRevealViewController *revealViewController = self.revealViewController;
    
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];
//    if (self.recordIDToEdit != -1) {
//        // Load the record with the specific ID from the database.
//        [self loadInfoToEdit];
//    }
   // priceLabel.text=proPrice_str;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadData];
    
    
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

-(IBAction) addQuantity
{
    [self loadInfoToEdit];
    if (counter > 9 )
        return;
    [btnCount_label setText:[NSString stringWithFormat:@"%ld",(long)++counter]];
}

-(IBAction) minusQuantity
{
    if (counter < 1 )
        return;
    [btnCount_label setText:[NSString stringWithFormat:@"%ld",(long)--counter]];
}
- (IBAction)saveInfo:(id)sender {
    [self loadData1];
    [self loadData];

    NSString *s1= proID_str;
    BOOL isTheObjectThere = [newArray containsObject:proID_str];
    NSLog(@"bool %s", isTheObjectThere ? "true" : "false");
   
    
    NSString *query;
    if (isTheObjectThere == false) {
        query = [NSString stringWithFormat:@"insert into CardManager values(null, '%@', '%@', '%@', '%@', '%@')", proID_str,_proName_str,_proImage_str,btnCount_label.text,proPrice_str];
        
    }
    else{
        NSString *count=[NSString stringWithFormat:@"SELECT ProQuantity FROM CardManager WHERE ProductID ='%@'",proID_str];
        [self.dbManager executeQuery:count];
         NSArray   *info = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:count]];
        NSLog(@"%@",info);
        int num=0;
        for (NSDictionary *result in info) {
            NSArray *aa=result;
            NSLog(@"reultttt %@",aa);
            for (int i=0;i<[aa count];i++){
                
                NSString *tmpObject=[NSString stringWithFormat:@"%@",
                                     [aa objectAtIndex:i]] ;
                NSLog(@"temp%@",tmpObject);
                int j=[tmpObject intValue];
                num=num+j;
                [newArray1 addObject:tmpObject];
                tmpObject=nil;
            }
            NSLog(@"newww %lu",(unsigned long)newArray1.count);
            
        }
        NSString *quan=[NSString stringWithFormat:@"%@",btnCount_label.text];
        int c=num+[quan intValue];

        query = [NSString stringWithFormat:@"update CardManager set ProQuantity='%d' where ProductID='%@'",c,proID_str];
        NSLog(@"%@",query);
    }
    
    
    // Execute the query.
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller.
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        
    }
    else{
        NSLog(@"Could not execute the query.");
        
    }
    [self loadData];
   
   
    [btnCount_label setText:@"1"];

    
   
    
    
}

-(void)loadData1{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];
    newArray=[[NSMutableArray alloc]init];
    NSString *query = @"select ProductID from CardManager";
    
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
            [newArray addObject: tmpObject];
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray.count);
        
    }
    
    
    // Reload the table view.
}
-(void)loadData{
    // Form the query.
    NSArray *arrPeopleInfo=[[NSArray alloc]init];

    int count = 0;
    newArray1=[[NSMutableArray alloc]init];
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
                                  [aa objectAtIndex:i]] ;
            NSLog(@"temp%@",tmpObject);
            int j=[tmpObject intValue];
            count=count+j;
            [newArray1 addObject:tmpObject];
            tmpObject=nil;
        }
        NSLog(@"newww %lu",(unsigned long)newArray1.count);
        
    }
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"addquant"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    cart_label.text=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"addquant"]];
    
    // Reload the table view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)loadInfoToEdit{
    NSString *query;
    
    
    [self.dbManager executeQuery:query];
    
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query.");
        
    }

}

- (IBAction)back:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(IBAction)cartView:(id)sender{
    if([[NSUserDefaults standardUserDefaults] valueForKey:@"ID"]){
        Payment_ViewController *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
    }else{
        Login_ViewController  *event= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Login_ViewController"];
        [self.navigationController pushViewController:event animated:NO];
    }
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
