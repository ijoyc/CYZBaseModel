# CYZBaseModel
==============

## Usage

Just custom your model class by inheriting `CYZBaseModel` and override some methods if needed.

### Dictionary to model

If the name of class attribute is the same one as the key of dictionary, then just call `-initWithDict:`

```objective-c
typedef enum {
kUserTypeNormal,
kUserTypeVIP
} UserType;

@interface User : CYZBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *address;
//@property (strong, nonatomic) NSArray *dogs;
@property (assign, nonatomic) UserType type;

@end

//------main------
NSDictionary *dictionary = @{@"name": @"xiaowang",
@"userID": @"45",
@"address": @"china",
@"type": @(kUserTypeVIP)};
User *userModel = [[User alloc] initWithDict:dictionary];
NSLog(@"%@", userModel);


//------output-----
name = xiaowang, userid = 45, address = china, type = 1
```

### JSONString to model

Call method initWithJsonString to initialize instance by passing a json string.

```objective-c
//----- main------
NSString *jsonString = @"{\"name\":\"xiaoli\", \"userID\":\"14\", \"address\":\"china\", \"type\":1}";
User *userModel = [[User alloc] initWithJsonString:jsonString];
NSLog(@"%@", userModel);

//-----output-----
name = xiaoli, userid = 14, address = china, type = 1
```


### Dictionary(contains other objects) to model

If there are any sub-models contained in the given dictionary, this method still works.
BUT, those models should also inherit CYZBaseModel and override some methods if necessary.

```objective-c
@class Test;

@interface Bag : CYZBaseModel

@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) CGFloat price;
@property (strong, nonatomic) Test *t;

@end

@interface Test : CYZBaseModel
@property (strong, nonatomic) NSString *name;
@end


//------main------
NSDictionary *dict = @{@"name": @"lv",
@"prive": @100.4,
@"t": @{@"name": @"testName"}};
Bag *b = [[Bag alloc] initWithDict:dict];
NSLog(@"%@", b);

//-----output-----
name = lv, price = 100.400000, t = name = testName

```

### Dictionary(contains arrays of other objects) to model

You should override method `- (NSDictionary *)objectClassesInArray`
to show what kind of objects are in array.

```objective-c
//User
@interface User : CYZBaseModel

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSArray *dogs;
@property (assign, nonatomic) UserType type;

@end


//override method
- (NSDictionary *)objectClassesInArray {
    return @{@"dogs": @"Dog"};
}



//-----main-----
NSDictionary *dict = @{@"nm": @"shangsi",
@"address": @"binhai",
@"userID": @"43",
@"dogs": @[@{@"name": @"xiaobai",
@"favour": @"chi",},
@{@"name": @"xiaohei",
@"favour": @"he",},
@{@"name": @"xiaohuang",
@"favour": @"wan",}]
};
User *user = [[User alloc] initWithDict:dict];
NSLog(@"%@", user);

//-----output-----
name = (null), userid = 43, address = binhai, type = 0, dogs = (
"name = xiaobai, favour = chi",
"name = xiaohei, favour = he",
"name = xiaohuang, favour = wan"
)

```

### Dictionary to model -- mapping property name to dictionary key

If the any one of class attribute name is different from the given dictionary's key, then override the method `-(NSDictionary *)attributeMapDictionary` to return a dictionary for mapping. 
This dictionary use the "attribute name" as key and use "passing dictionary's key" as value.

```objective-c
@interface Student : CYZBaseModel

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *desc;
@property (copy, nonatomic) NSString *nowName;
@property (copy, nonatomic) NSString *oldName;
@property (copy, nonatomic) NSString *nameChangedTime;
@property (strong, nonatomic) Bag *bag;

@end

//override method
- (NSDictionary *)attributeMapDictionary {
    return @{
        @"ID" : @"id",
        @"desc" : @"desciption",
        @"oldName" : @"name.oldName",
        @"nowName" : @"name.newName",
        @"nameChangedTime" : @"name.info.nameChangedTime",
        @"bag" : @"other.bag"
    };
}

//-----main-----
NSDictionary *testMappingDictionary = @{
    @"id" : @"20",
    @"desciption" : @"kids",
    @"name" : @{
        @"newName" : @"lufy",
        @"oldName" : @"kitty",
        @"info" : @{
            @"nameChangedTime" : @"2013-08"
        }
    },
    @"other" : @{
        @"bag" : @{
            @"name" : @"a red bag",
            @"price" : @100.7
        }
    }
};
Student *s = [[Student alloc] initWithDict:testMappingDictionary];
NSLog(@"s = %@", s);

//-----output-----
s = id = 20, desc = kids, oldname = kitty, nowname = lufy, namechangedtime = 2013-08, bag = name = a red bag, price = 100.700000, t = (null)
```

### Dictionary to model -- an example
Basic data type, enum, NSDictionary, NSNumber, other objects...no matter what kind of property, 
method `- (id)initWithDict:` will work properly. 
Just remember to override `-(NSDictionary *)attributeMapDictionary` and `- (NSDictionary *)objectClassesInArray` to fit the passing dictionary.

```objective-c
//-----model-----
@interface Weibo : CYZBaseModel

@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) int weiboID;
@property (assign, nonatomic) NSNumber *numberWeiboID;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSDictionary *userDictionary;

@end

//-----main-----
NSDictionary *dict = @{@"nm": @"zhangsan",
                    @"weiboID": @123,
                    @"numberWeiboID": @123,
                    @"time": @"today",
                    @"user": @{@"nm": @"shangsi",
                            @"address": @"binhai",
                            @"userID": @"43",
                            @"dogs": @[@{@"name": @"xiaobai",
                                        @"favour": @"chi",},
                                        @{@"name": @"xiaohei",
                                        @"favour": @"he",},
                                        @{@"name": @"xiaohuang",
                                        @"favour": @"wan",}]
                    },
                    @"userDictionary": @{@"testKey1": @"testValue1",
                                        @"testKey2": @"testValue2"}
};
Weibo *w = [[Weibo alloc] initWithDict:dict];
NSLog(@"%@", w);


//-----output-----
name = zhangsan, weiboid = 123, numberWeiboID = 123, time = today, user = name = (null), userid = 43, address = binhai, type = 0, dogs = (
    "name = xiaobai, favour = chi",
    "name = xiaohei, favour = he",
    "name = xiaohuang, favour = wan"
), userDictionary = {
    testKey1 = testValue1;
    testKey2 = testValue2;
}

```


### Array to models

Use class method `+ (NSArray *)objectArrayWithJsonArray:(NSArray *)jsonArray;` 
to create an array of models using a json array

```objective-c

//-----main-----
NSArray *dictArray = @[@{@"name": @"lv", @"price": @14.4}, @{@"name": @"shuihuo", @"price": @1}];
NSArray *bags = [Bag objectArrayWithJsonArray:dictArray];
NSLog(@"bags = %@", bags);

//-----output-----
bags = (
    "name = lv, price = 14.400000, t = (null)",
    "name = shuihuo, price = 1.000000, t = (null)"
)

```

### Model to dictionary

Call method `-(NSDictionary *)dictionaryRepresentation` and it will return a dictionary automatically.

Basic data type, NSNumber will be distinguished correctly.
If there are any properties that you don't set a value on, it will be NSNull in dictionary.
Property name and dictionary key mapping by `-(NSDictionary *)attributeMapDictionary` still works here.

```objective-c

//-----main-----
Weibo *weibo = [[Weibo alloc] init];
weibo.name = @"n";
weibo.weiboID = 12;
weibo.numberWeiboID = @1;
NSDictionary *wd = [weibo dictionaryRepresentation];
NSLog(@"%@", wd);

//-----output-----
{
    nm = n;
    numberWeiboID = 1;
    time = "<null>";
    user = "<null>";
    userDictionary = "<null>";
    weiboID = 12;
}

```

Another more complex example:

```objective-c

//-----main-----
Student *stu = [[Student alloc] init];
stu.nowName = @"chen";
stu.oldName = @"yi";
stu.nameChangedTime = @"1";

Bag *b = [[Bag alloc] init];
b.name = @"fake lv";
b.price = 1.1;

Test *t = [[Test alloc] init];
t.name = @"test";

b.t = t;
stu.bag = b;

NSDictionary *studict = [stu dictionaryRepresentation];
NSLog(@"studict = %@", studict);

//-----output-----
studict = {
    desciption = "<null>";
    id = "<null>";
    "name.info.nameChangedTime" = 1;
    "name.newName" = chen;
    "name.oldName" = yi;
    "other.bag" =     {
        name = "fake lv";
        price = "1.1";
        t =         {
            name = test;
        };
    };
}

```

### Model array to json array & json string

The main point is that model array must contains only ONE type of model,
then you can call the class method `+ (NSArray *)jsonArrayWithObjectArray:(NSArray *)objectArray;`
and `+ (NSString *)jsonStringWithObjectArray:(NSArray *)objectArray;` 
to get the json array or json string respectively

```objective-c

//-----main-----
Bag *b1 = [[Bag alloc] init];
b1.name = @"bag1";
b1.price = 2.2;

Bag *b2 = [[Bag alloc] init];
b2.name = @"bag2";
b2.price = 3.3;

NSArray *bagArray = @[b1, b2];
NSArray *jsonArray = [Bag jsonArrayWithObjectArray:bagArray];
NSLog(@"%@", jsonArray);

NSString *bagJsonString = [Bag jsonStringWithObjectArray:bagArray];
NSLog(@"%@", bagJsonString);

//-----output-----
2015-05-14 12:39:34.317 ModelAndDictionary[12599:573276] (
    {
        name = bag1;
        price = "2.2";
        t = "<null>";
    },
    {
        name = bag2;
        price = "3.3";
        t = "<null>";
    }
)
2015-05-14 12:39:34.319 ModelAndDictionary[12599:573276] [
    {
        "name" : "bag1",
        "price" : 2.2,
        "t" : null
    },
    {
        "name" : "bag2",
        "price" : 3.3,
        "t" : null
    }
]

```


###Encoding & Decoding

All subclass inherited from CYZBaseModel will automatically be able to encode and decode with all properties.
Just wirte `[NSKeyedArchiver archiveRootObject:toFile:]` to  encode object and
`[NSKeyedUnarchiver unarchiverObjectWithFile:]` to decode object.

```objective-c

//-----main-----
Bag *b2 = [[Bag alloc] init];
b2.name = @"bag2";
b2.price = 3.3;

NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"test.plist"];
NSLog(@"path = %@", path);
[NSKeyedArchiver archiveRootObject:b2 toFile:path];

Bag *unarchivedBag = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
NSLog(@"%@", unarchivedBag);

//-----output-----
name = bag2, price = 3.300000, t = (null)

```

### Automatically convert NSNull to proper value

If server gives you a nil object, in OC you will get a NSNull instance. However you may always want to convert it to its original type with a proper empty value. By using `CYZBaseModel` you can free your day from converting. So any code likes these:
```
if (aDict[@"buildingPortrait"] == [NSNull null]) {
    self.buildingPortrait = @"";
}
if (aDict[@"openingTime"] == [NSNull null]) {
    self.openingTime = @"";
}
if (aDict[@"purchaseNote"] == [NSNull null]) {
    self.purchaseNote = @"";
}
if (aDict[@"videoLink"] == [NSNull null]) {
    self.videoLink = @"";
}
```
can be deleted :]
`CYZBaseModel` will consider the type of given key and do these mapping:
    `NSString` ~> `@""`,
    `NSArray` ~> `[NSArray array]`,
    `NSDictionary` ~> `[NSDictionary dictionary]`,
    `NSNumber` ~> `@0`,
    other ~> `[NSNull null]`

UNLESS you override `- (NSArray *)attributesWithoutConvertNull;` to tell `CYZBasemodel`: "Hi guy, these value should not be converted!".

### Pretty NSLog

In short, you can use `NSLog(@"%@", myObject)` to print all of the world :].









