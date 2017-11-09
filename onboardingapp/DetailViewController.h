//
//  DetailViewController.h
//  onboardingapp
//
//  Created by Ben Marten on 11/8/17.
//  Copyright © 2017 Leanplum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) NSDate *detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

