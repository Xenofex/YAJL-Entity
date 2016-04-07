A JSON framework that deserialize the JSON string/data directly into Objective-C objects, as opposed to NSDictionary and NSArray in others.

Unlike [RestKit](https://github.com/RestKit/RestKit), which requires the declaration of the [Object Mapping](https://github.com/RestKit/RestKit/wiki/Object-mapping), YAJL-Entity requires no such configuration. Property names are automatically mapped, with the snake-cased and camel-cased conversion. The type of the nested object is determined by the declared type of the property in the ObjC class. For the array, additional configuration is required, which is fairly simple. See the Short Demo section.

I've been using this for 3 years, in a bunch of different projects, most of which are in-house apps. It was an extension of the yajl-objc library, but the author didn't accept the pull request. So I make this as a separate project.

# Installation

[CocoaPods](https://github.com/cocoapods/cocoapods) preferred now. In your `Podfile`:

```ruby
pod 'YAJL-Entity'
```

# A Brief Demo

Checkout the tests in this project. In `YAJL_EntityTest.m`:


```objective-c
NSString *path = [[NSBundle mainBundle] pathForResource:@"my-entity.json" ofType:nil];
NSData *data = [NSData dataWithContentsOfFile:path];

// Deserialization
MyEntity *entity = [data objectFromJSONOfType:[MyEntity class]];

// Serialization.
// You have to implement - (id)JSON method in your entity class. This is easy to do. See the next section.
NSString *jsonString = [entity yajl_JSONString];
```

In `MyEntity.m`, the following code:

```objective-c
// A informal protocol. By default it simply calls [self init
// Override this only if your class has properties to be deserialzed which are NSArray or NSMutableArray
- (id)initForYAJL
{
    if ((self = [super initForYAJL])) {
	// Assign the class object to the array property as a hint.
	// It will be safely removed after the deserialization process. 
        self.addresses = (NSArray *)[MyAddress class];
    }
    
    return self;
}
```
is required to make the array work. 

By looking into the defination of the class MyEntity you can find that it has 2 array properties, one of which contains custom objects while the other contains primitives, and one property of other model class. So this is enough for most of the situations.

# Convention over Configuration

Conventionally the names in Objective-C are camel-cased. Snake-cased names from other languages can be automatically converted.

In order to support serializing an object to JSON string, you have to implement `- (id)JSON` method. Here is a sample which you can add to your common superclass of your entities.

```objective-c
- (id)JSON
{
    return [self dictionaryOfProperyties];
}
```

the `- (id)JSON` method is required by the YAJL framework to serialize the object. It should return the json reprensentation of itself in `NSArray` or `NSDictionary`. The `- (NSDictionary *)dictionaryOfProperty` method is provided by YAJL-Entity which can make a `NSDictionary` containing all the properies and values of this project. Usually, you can have this method in the common parent class of all your models.

For the generated names of the json string's properties, they are same as the ones in the ObjC class. If you want it snake-cased, you can use `- (NSDictionary *)dictionaryOfProperytiesWithOption:` instead.

# Limitation

Currently YAJL-Entity doesn't support nested arrays. Fortunately this is not commonly used.
