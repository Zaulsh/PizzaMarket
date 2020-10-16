//
//  AddCart_ViewController.m
//  Homem De Pao
//
//  Created by Itgenesys on 11/5/16.
//  Copyright © 2016 itgenesys. All rights reserved.
//

#import "AddCart_ViewController.h"
#import "DBManager.h"
#import "ViewPager_ViewController.h"
#import "Payment_ViewController.h"
@interface AddCart_ViewController (){
    NSArray *idd;
}
@property (nonatomic, strong) DBManager *dbManager;
@property (nonatomic, strong) NSArray *arrPeopleInfo;

@property (nonatomic) int recordIDToEdit;

@end

@implementation AddCart_ViewController
@synthesize total_label;
- (void)viewDidLoad {
    [super viewDidLoad];
     // Initialize the dbManager property.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"KRCS1.sqlite"];
//    NSString *query1 = @"SELECT COUNT(*) FROM CardManager";
//    
//    // Get the results.
//    if (self.arrPeopleInfo1 != nil) {
//        // self.arrPeopleInfo = nil;
//    }
//    self.arrPeopleInfo1 = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query1]];
//    NSLog(@"queryyy %@",self.arrPeopleInfo1);

    [self.tblPeople reloadData];
    // Load the data.
     [self loadData1];
    [self loadData];
   
    NSLog(@"countttt %lu",(unsigned long)[_arrPeopleInfo count]);
    NSInteger *ff=[_arrPeopleInfo count];
    NSString *inStr = [NSString stringWithFormat: @"%ld", (long)ff];
    NSLog(@"key =====: %@",inStr);
    [self sharedata:@"noti_count" :inStr];

    // Do any additional setup after loading the view.
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

-(void)loadData{
    // Form the query.
    NSString *query = @"select * from CardManager";
    
    // Get the results.
    if (self.arrPeopleInfo != nil) {
        // self.arrPeopleInfo = nil;
    }
    self.arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    // Reload the table view.
    [self.tblPeople reloadData];
}
-(void)loadData1{
    // Form the query.
    NSString *query = @"SELECT SUM(ProQuantity*ProPrice) FROM CardManager";
    
//    // Get the results.
//    if (self.arrPeopleInfo1 != nil) {
//        // self.arrPeopleInfo = nil;
//    }
    
    NSArray * arrPeopleInfo = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"totall %@",arrPeopleInfo);
//    NSString * ssss2=[arrPeopleInfo objectAtIndex:0];
//      NSLog(@"   >>>>>>,,,,,,, >>>   str-6  parul ji testing  >> > > > > > > %@",ssss2);
//   
//    [[ssss2 stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
//     total_label.text=[NSString stringWithFormat:@"%@",ssss2];
//    NSLog(@"totallllll %@",total_label.text);
    
    for (NSDictionary *try in arrPeopleInfo) {
        NSArray * ssss2=try;
          NSLog(@"totallllll %@",ssss2);
        for (NSDictionary *trry in ssss2) {
            NSString *rtestr=trry;
            NSLog(@"hhhhh %@",rtestr);
            
            total_label.text=[NSString stringWithFormat:@"%@",rtestr];
        }
    }
   // NSString * ssss2=[arrPeopleInfo objectAtIndex:0];
  
    
      // total_label.text=[NSString stringWithFormat:@"%@",ssss2];
    // Reload the table view.
   // [self.tblPeople reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
tableView.separatorColor = [UIColor clearColor];
    return self.arrPeopleInfo.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Dequeue the cell.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"idCellRecord" forIndexPath:indexPath];
    
    NSInteger indexofPname = [self.dbManager.arrColumnNames indexOfObject:@"ProductName"];
    NSInteger indexOfPquantity = [self.dbManager.arrColumnNames indexOfObject:@"ProQuantity"];
    NSInteger indexOfImage = [self.dbManager.arrColumnNames indexOfObject:@"ProductImage"];
     NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"ProductID"];
    NSLog(@"iddddd %ld",(long)indexOfId);
//    NSInteger indexOfCount = [self.dbManager.arrColumnNames indexOfObject:@"MultiValue"];
//    NSInteger indexOfAmount = [self.dbManager.arrColumnNames indexOfObject:@"donaAmount"];
//    NSInteger indexOfCurrency = [self.dbManager.arrColumnNames indexOfObject:@"cureType"];
//   idd= [self.arrPeopleInfo  objectAtIndex:indexOfId];
//    NSLog(@"iddddddd %@",idd);
    
    // Set the loaded data to the appropriate cell labels.
    UILabel *dname=(UILabel *)[cell viewWithTag:1];
    dname.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexofPname]];
    UILabel *Cname=(UILabel *)[cell viewWithTag:2];
    Cname.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfPquantity]];
//    Count=(UILabel *)[cell viewWithTag:3];
//    Count.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCount]];
//    Amount=(UILabel *)[cell viewWithTag:4];
//    Amount.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfAmount]];
    UIImageView *img=(UIImageView *)[cell viewWithTag:5];
    NSString *ssss3=[NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfImage]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ssss3]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        img.image = [UIImage imageWithData:data];
    }];
//    UILabel *currency=(UILabel *)[cell viewWithTag:6];
//    currency.text = [NSString stringWithFormat:@"%@", [[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:indexOfCurrency]];
    return cell;
}


//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 60.0;
//}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record.
        // Find the record ID.
        int recordIDToDelete = [[[self.arrPeopleInfo objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query.
        NSString *query = [NSString stringWithFormat:@"delete from CardManager where ID=%d", recordIDToDelete];
        
        // Execute the query.
        [self.dbManager executeQuery:query];
        
        // Reload the table view.
        [self loadData1];
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    
    ViewPager_ViewController *after_login= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewPager_ViewController"];
    
    
    [self.navigationController pushViewController:after_login animated:NO];
    
    
}
-(IBAction)checkOut:(id)sender{
    
   //  NSLog(@"indexofiddd %d",indexOfId);
//     NSInteger indexOfId = [self.dbManager.arrColumnNames indexOfObject:@"ProductID"];
//       idd= [self.arrPeopleInfo  objectAtIndex:indexOfId];
//        NSLog(@"iddddddd %@",idd);
    NSString *query = @"Select ProductID from CardManager";
    
    // Get the results.
//    if (self.arrPeopleInfo != nil) {
//        // self.arrPeopleInfo = nil;
//    }
    NSArray *aa =  [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    NSLog(@"aaaaa %@",aa);
    
    NSArray * ssss2;
    for (NSDictionary *try in aa) {
         ssss2=try;
        NSLog(@"totallllll %@",ssss2);
//        
//        for (NSDictionary *trry in ssss2) {
//            NSString *rtestr=trry;
//            NSLog(@"hhhhh %@",rtestr);
//
//        }
    }
    
    Payment_ViewController *after_login= [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"Payment_ViewController"];
    after_login.pro_id=aa;
    NSLog(@"subiddd %@",idd);
    [self.navigationController pushViewController:after_login animated:NO];
    
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
