# CYZBaseModel

## Usage

Just custom your model class by inheriting CYZBaseModel and override some methods if needed.

### Dictionary to object

If the name of class attribute is the same one as the key of dictionary, then just call -initWithDict:.

If the any one of class attribute name is different from the given dictionary's key, then override the method -(NSDictionary *)attributeMapDictionary to return a dictionary for mapping. 
This dictionary use the "attribute name" as key and use "passing dictionary's key" as value.

If there is any attribute that is not basic data type, ie. custom class, Then override -setAttributesDictionary:(Nsdictionary *)adict to set the value manually.

### Object to dictionary

Call method -(NSDictionary *)dictionaryRepresentation and it will return a dictionary automatically.