//
//  AuthCoordinator.h
//  qtum wallet
//
//  Created by Никита Федоренко on 21.02.17.
//  Copyright © 2017 Designsters. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCoordinator.h"

@protocol AuthCoordinatorDelegate <NSObject>

-(void)didCreatedWalletName:(NSString*)name;
-(void)didEnteredFirstTimePass:(NSString*)pass;
-(void)didEnteredSecondTimePass:(NSString*)pass;
-(void)didRestorePressedWithWords:(NSArray*)words;
-(void)didCreateWalletPressedFromRestore;
-(void)cancelCreateWallet;
-(void)restoreWalletCancelDidPressed;
-(void)didCreateWallet;
-(void)didRestoreWallet;
-(void)restoreButtonPressed;
-(void)createNewButtonPressed;
-(void)didExportWallet;

@end

@protocol ApplicationCoordinatorDelegate;

@interface AuthCoordinator : BaseCoordinator <Coordinatorable,AuthCoordinatorDelegate>

@property (weak,nonatomic) id <ApplicationCoordinatorDelegate> delegate;

-(instancetype)initWithNavigationViewController:(UINavigationController*)navigationController;

@end