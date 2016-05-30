//
//  MZLanguagesPickerCollectionController.h
//  Memz
//
//  Created by Bastien Falcou on 1/30/16.
//  Copyright © 2016 Falcou. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MZLanguagesPickerCollectionControllerDelegate;

@interface MZLanguagesPickerCollectionController : NSObject

@property (nonatomic, weak, readonly) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<NSNumber *> *collectionViewData;	// update data does not call reloadData

@property (nonatomic, assign, readonly) BOOL isAnimating;	 // returns YES if currently animating

@property (nonatomic, strong) id<MZLanguagesPickerCollectionControllerDelegate> delegate;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;
+ (instancetype)languageCollectionControllerWithCollectionView:(UICollectionView *)collectionView;

- (void)reloadData;  // not animated, cancelled if already animating
- (void)reloadDataAnimated:(BOOL)animated completionHandler:(void(^)(void))completionHandler;	 // cancelled if already animating

- (void)dropAllCellsAnimated:(BOOL)animated completionHandler:(void(^)(void))completionHandler;  // depopulates, sets collectionViewData nil

@end

@protocol MZLanguagesPickerCollectionControllerDelegate <NSObject>

@optional

- (void)languagesPickerCollectionController:(MZLanguagesPickerCollectionController *)collectionController
													didSelectLanguage:(MZLanguage)language;

@end
