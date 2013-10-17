//
//  YAJL_EntityTests.m
//  YAJL-EntityTests
//
//  Created by Eli Wang on 13-10-17.
//
//

#import <XCTest/XCTest.h>
#import "YAJLParser.h"
#import "YAJL-Entity.h"
#import "MyEntity.h"
#import "MyAddress.h"
#import "NSString+CaseExt.h"

@interface YAJL_EntityTests : XCTestCase

- (NSData *)loadData:(NSString *)name;
- (NSString *)loadString:(NSString *)name;
- (NSString *)directoryWithPath:(NSString *)path;

@end

@implementation YAJL_EntityTests


- (NSData *)loadData:(NSString *)name {
    NSBundle *testBundle = nil;
    
    for (NSBundle *bundle in [NSBundle allBundles]) {
        if ([[bundle bundlePath] hasSuffix:@"YAJL-EntityTests.xctest"]) {
            testBundle = bundle;
            break;
        }
    }
    
    XCTAssertNotNil(testBundle, @"testBundle should not be nil");
    
    NSString *path = [testBundle pathForResource:name ofType:@"json"];
    XCTAssertNotNil(path, @"Invalid name for load data");
    return [NSData dataWithContentsOfFile:path options:NSUncachedRead error:nil];
}

- (NSString *)loadString:(NSString *)name {
    return [[NSString alloc] initWithData:[self loadData:name] encoding:NSUTF8StringEncoding];
}

- (NSString *)directoryWithPath:(NSString *)path {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *fullPath = [[paths lastObject] stringByAppendingPathComponent:path];
    NSLog(@"Using path: %@", fullPath);
    return fullPath;
}


- (void)parserDidStartDictionary:(YAJLParser *)parser { NSLog(@"{"); }
- (void)parserDidEndDictionary:(YAJLParser *)parser { NSLog(@"}"); }

- (void)parserDidStartArray:(YAJLParser *)parser { NSLog(@"["); }
- (void)parserDidEndArray:(YAJLParser *)parser { NSLog(@"]"); }

- (void)parser:(YAJLParser *)parser didMapKey:(NSString *)key { NSLog(@"'%@':", key); }
- (void)parser:(YAJLParser *)parser didAdd:(id)value { NSLog(@"%@", [value description]); }

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSData *data = [self loadData:@"my-entity"];
    
    MyEntity *entity = [data objectFromJSONOfType:[MyEntity class]];
    
    XCTAssertEqualObjects(entity.name, @"the entity name", @"");
    XCTAssertEqual(entity.value, 100, @"");
    NSArray *followers = [NSArray arrayWithObjects:[NSNumber numberWithInt:200],
                          [NSNumber numberWithInt:201],
                          [NSNumber numberWithInt:202],
                          [NSNumber numberWithInt:205], nil];
    XCTAssertEqualObjects(entity.followers, followers, @"");
    XCTAssertEqual([entity.addresses count], (NSUInteger)2, @"");
    
    MyAddress *a1 = [entity.addresses objectAtIndex:0];
    MyAddress *a2 = [entity.addresses objectAtIndex:1];
    
    XCTAssertEqualObjects(a1.city, @"Shanghai", @"");
    XCTAssertEqual(a1.zipcode, 200000, @"");
    XCTAssertEqualObjects(a2.city, @"Beijing", @"");
    XCTAssertEqual(a2.zipcode, 100000, @"");
    
    XCTAssertTrue(entity.isNew, @"");
    XCTAssertTrue(entity.outdated, @"");
    
    XCTAssertNotNil(entity.parent, @"");
    XCTAssertEqualObjects(entity.parent.name, @"the inner entity name", @"");
    XCTAssertEqual(entity.parent.value, 0, @"");
    XCTAssertEqual([entity.parent.addresses count], (NSUInteger)2, @"");
    
    a1 = [entity.parent.addresses objectAtIndex:0];
    a2 = [entity.parent.addresses objectAtIndex:1];
    
    XCTAssertEqualObjects(a1.city, @"Shanghai inner", @"");
    XCTAssertEqual(a1.zipcode, 200000, @"");
    XCTAssertEqualObjects(a2.city, @"Beijing inner", @"");
    XCTAssertEqual(a2.zipcode, 100000, @"");
    
    XCTAssertNil(entity.parent.parent, @"");
}

@end
