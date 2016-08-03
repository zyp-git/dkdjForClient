//
//  FileController.m
//  Faneat4iPhone
//
//  Created by OS Mac on 12-7-5.
//  Copyright (c) 2012年 HangJing. All rights reserved.
//

#ifndef kOrderListFile
#define kOrderListFile @"ShopCart.plist"
#endif
#import "FileController.h"

@implementation FileController

+(NSString *)documentsPath 
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	return [paths objectAtIndex:0];
}

+(NSString *)fullpathOfFilename:(NSString *)filename 
{
	NSString *documentsPath = [self documentsPath];
    
	return [documentsPath stringByAppendingPathComponent:filename];
}

+(void)saveShopCart:(NSMutableDictionary *)shopcartDict 
{
	NSString *f = [self fullpathOfFilename:kOrderListFile];
    
	[shopcartDict writeToFile:f atomically:YES];
    
    [self loadShopCart];
}

+(NSMutableDictionary *)loadShopCart
{
    NSString *f = [self fullpathOfFilename:kOrderListFile];
    
    NSMutableDictionary *list = [[[NSMutableDictionary alloc] initWithContentsOfFile:f] autorelease];
 
    if(list == nil){	//omg! double =
        NSLog(@"loadShopCart list == nil");
		list = [NSMutableDictionary dictionary];
	}
    
    return list;
}

+(void)saveOrderList:(NSDictionary *)list {
	NSString *f = [self fullpathOfFilename:kOrderListFile];
	[list writeToFile:f atomically:YES];
}

+(NSDictionary *)loadOrderList {
    //	NSArray *list = [NSArray arrayWithContentsOfFile:[self fullpathOfFilename:kOrderListFile]];
	NSString *f = [self fullpathOfFilename:kOrderListFile];
	NSDictionary *list = [[[NSDictionary alloc] initWithContentsOfFile:f] autorelease];
	if(list == nil){	//omg! double =
		list = [NSDictionary dictionary];
	}
	//NSDictionary *oneRow = [NSDictionary dictionaryWithObject:@"listValue" forKey:@"listKey"];
	//list = [NSDictionary dictionaryWithObject:oneRow forKey:@"0"];
	return list;
}

+(NSUInteger)addOneToRow:(NSUInteger)row {
	
	NSUInteger count = 1;
	
	NSMutableDictionary *listDict = [[NSMutableDictionary alloc] initWithDictionary:[self loadOrderList]];	//[NSMutableDictionary dictionaryWithContentsOfFile:[self fullpathOfFilename:kOrderListFile]];
	if(listDict == nil) listDict = [NSMutableDictionary dictionary];
    
	NSDictionary *d = [listDict objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
	NSLog(@"d:%@",d);
	if(d == nil){
		count  = 1;
	}else {
		count = [[d valueForKey:@"count"] intValue] + 1;
	}
	NSLog(@"count:%lu",(unsigned long)count);

	NSDictionary *newRow = [[NSDictionary alloc] initWithObjectsAndKeys:@(row),@"row",@(count),@"count",nil];
	[listDict setObject:newRow forKey:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
	[newRow release];
	
	[self saveOrderList:listDict];
	return count;
}

+(NSUInteger)deleteOneFomRow:(NSUInteger)row {

	NSUInteger count = 1;
	
	NSMutableDictionary *listDict = [NSMutableDictionary dictionaryWithContentsOfFile:[self fullpathOfFilename:kOrderListFile]];
	if(listDict == nil) listDict = [NSMutableDictionary dictionary];
	
	NSDictionary *d = [listDict objectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
	if(d == nil){
		count = 0;
	}else{
		count = [[d valueForKey:@"count"] intValue];
		if(count == 1){
			[listDict removeObjectForKey:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
			count --;
		}else {
			count --;
			NSLog(@"count:%lu",(unsigned long)count);
			NSDictionary *newRow = [[NSDictionary alloc] initWithObjectsAndKeys:@(row),@"row",@(count),@"count",nil];
			[listDict setObject:newRow forKey:[NSString stringWithFormat:@"%lu",(unsigned long)row]];
			[newRow release];			
		}
		[self saveOrderList:listDict];
	}
	return count;	
}

+(NSDictionary *)readRow:(NSUInteger)row {
	NSString *key = [NSString stringWithFormat:@"%lu",(unsigned long)row];
	return [[self loadOrderList] valueForKey:key];
}

- (void)dealloc {
    [super dealloc];
}

@end
