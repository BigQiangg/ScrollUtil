//
//  ViewController.m
//  ScrollDemo
//
//  Created by zwq on 2020/5/19.
//  Copyright © 2020 zwq. All rights reserved.
//

#import "ViewController.h"
#import "LYScrollUtil.h"
#import "TestCell.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) IBOutlet UIScrollView *bgScrollView;
@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) LYScrollUtil *util;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.util = [[LYScrollUtil alloc] init];
    self.util.superScrollView = self.bgScrollView;
    self.util.childScrollView = self.tableView;
    [self.tableView registerNib:[UINib nibWithNibName:@"TestCell" bundle:nil] forCellReuseIdentifier:@"TestCell"];
}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    self.bgScrollView.contentSize = CGSizeMake(UIScreen.mainScreen.bounds.size.width, self.tableView.frame.origin.y + self.tableView.frame.size.height - 44);
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  [tableView dequeueReusableCellWithIdentifier:@"TestCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
