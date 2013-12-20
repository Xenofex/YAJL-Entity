/*
 * Copyright (c) 2012 Eli Wang
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to
 * deal in the Software without restriction, including without limitation the
 * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
 * sell copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

#import "NSObject+YAJLizable.h"
#import "NSObject+Properties.h"
#import "NSString+CaseExt.h"

int EWPropNameUpperCaseFirstChar = 0;

@interface NSObject(YAJLizablePrivate)

- (NSMutableDictionary *)newDictionaryOfPropertiesWithPredicate:(NSPredicate *)predicate asClass:(Class) aClass option:(EWPropDictOption)option;

@end

@implementation NSObject(YAJLizable)


- (NSDictionary *)newDictionaryOfPropertiesWithPredicate:(NSPredicate *)predicate option:(EWPropDictOption)option
{
    Class superClass = [self class];
    NSMutableDictionary *dict = [self newDictionaryOfPropertiesWithPredicate:predicate asClass:[self class] option:option];
    
    while ((superClass = [superClass superclass])) {
        // TEST if the current superClass is NSObject. If it's true, break;
        if ([superClass superclass] != nil) {
            NSMutableDictionary *superDict = [self newDictionaryOfPropertiesWithPredicate:predicate asClass:superClass option:option];
            [dict addEntriesFromDictionary:superDict];
            [superDict release];
        } else {
            break;
        }
    }
    
    NSDictionary *ret = [[NSDictionary alloc] initWithDictionary:dict];
    [dict release];
    
    return ret;
}

- (NSDictionary *)dictionaryOfPropertiesWithPredicate:(NSPredicate *)predicate option:(EWPropDictOption)option
{
    return [[self newDictionaryOfPropertiesWithPredicate:predicate option:option] autorelease];
}

- (NSDictionary *)newDictionaryOfPropertiesWithOption:(EWPropDictOption)option
{
    return [self newDictionaryOfPropertiesWithPredicate:nil option:option];
}

- (NSDictionary *)dictionaryOfPropertiesWithOption:(EWPropDictOption)option
{
    return [[self newDictionaryOfPropertiesWithOption:option] autorelease];
}

- (NSDictionary *)newDictionaryOfProperties
{
    return [self newDictionaryOfPropertiesWithOption:EWPropDictOptionNone];
}

- (NSDictionary *)dictionaryOfProperties
{
	return [[self newDictionaryOfProperties] autorelease];
}

- (id)initForYAJL
{
	return [self init];
}

- (NSMutableDictionary *)newDictionaryOfPropertiesWithPredicate:(NSPredicate *)predicate asClass:(Class)aClass option:(EWPropDictOption)option
{
	NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    NSArray *propertyNames = [aClass propertyNames];
    if (predicate) {
        propertyNames = [propertyNames filteredArrayUsingPredicate:predicate];
    }
    
	NSString *propName;
	NSString *dictKey = nil;
	for (propName in propertyNames) {
        if (option & EWPropDictSnakecase) {
            dictKey = [propName snakecaseString];
        } else if (EWPropNameUpperCaseFirstChar) {
			dictKey = [propName stringByUppercaseFirstChar];
		} else {
			dictKey = propName;
        }
        
		[dic setValue:[self valueForKey:propName] forKey:dictKey];
	}
	
	return dic;
}

@end
