# WordpressKit

**WordpressKit helps you to handle Wordpress [REST API](https://developer.wordpress.org/rest-api/reference/) in an elegant and composable way**. 

```swift
Wordpress(route: "https://www.xcoding.it/wp-json", namespace: .wp(v: .v2))
    .get(endpoint: .posts)
    .query(key: .page, value: "2")
    .query(key: .per_page, value: "5")
    .embed()
    .decode(type: [WordpressPost].self)
{ (result) in  

    guard let array = result.value else {
        print(result.error!.localizedDescription)
        return
    }
    
    array.forEach({ print( $0.title.rendered ) })
    
}
```

It's built on top of `URLSession` provided by the Foundation framework. 

# Usage # 

Everything starts from  `Wordpress` object which is responsible to create the `WordpressSession`. You can instantiate a Wordpress object by passing: from REST API string URL to the `route` parameter and `WordpressNamespace` case to the `namespace` parameter.

> In a normal WP configuration, the `route` of the REST API is located under `https://oursite.com/wp-json/` and the core `namespace` is `/wp/v2/`. 

So, with WordpressKit, **you can represent an instance of your Wordpress REST API by creating a `Wordpress` object like this**:

```swift
import WordpressKit

let wp = Wordpress(route: "https://oursite.com/wp-json/", namespace: .wp(v: .v2))
```

## Custom WordpressNamespace ##

This is the base form of a `Wordpress` instance creation. If your WP has another API configuration, for example you renamed the `wp-json` or you changed the default namespace, the definition of the `init` will be:

```swift
Wordpress.init(route: String, namespace: WordpressNamespace = .wp(v: .v2)) 
```

`WordpressNamespace` is an enum composed by three cases.

```swift
public enum WordpressNamespace {
    case wp(v: Version)
    case plugin(name: String, v: Version)
    case custom(path: String)
}
```

You can compose your API URL like these examples: 

```swift
// https://example.com/api/plugin/v1
Wordpress(route: "https://example.com/api", namespace: .plugin(name: "plugin", v: .v1))

// https://example.com/wp-json/plugin/v1
Wordpress(route: "https://example.com/wp-json", namespace: .custom(path: "plugin/v1"))

// https://example.com/wp-json/my-plugin/10
Wordpress(route: "https://example.com/wp-json", namespace: .plugin(name: "my-plugin", v: .custom(v: "10")))
```

## WordpressGetSession: Preparing a GET Session ##

**To perform a request with a `Wordpress` object, first you must create a `WordpressGetSession`** by invoking the `get` method and passing the `WordpressEndpoint` case to its `endpoint` parameter. 

```swift
public func get(endpoint: WordpressEndpoint) -> WordpressGetSession
```

**If you want to get posts of your website, your code will look like this:**

```swift
let wp: Wordpress = Wordpress(route: "https://www.xcoding.it/wp-json", namespace: .wp(v: .v2))
let session: WordpressGetSession = wp.get(endpoint: .posts)

// or, in a more concise way

Wordpress(route: "https://www.xcoding.it/wp-json", namespace: .wp(v: .v2))
    .get(endpoint: .posts)
```

`WordpressGetSession` internally contains a `URLSession` property that is used to manage one or more `URLRequest` based on your `query` and `ResultHandler` usage. 

For example, if you want to manage the `List` or `UITableView` pagination you can use a single `WordpressGetSession` and change the `.query(key: .page, value: "\(nextPage)")` at runtime. We will discuss about this topic in the `query` paragraph. 

### Making a Request

To start communicating with your API, and so starting a real `URLRequest`, you need to use one of the `ResultHandler` methods of your `WordpressGetSession` object:

```swift
func json(result: @escaping ResultHandler<Any>) -> Self
func string(result: @escaping ResultHandler<String>) -> Self
func data(result: @escaping ResultHandler<Data>) -> Self
func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable
```

A `ResultHandler` is an object composed by two properties: a `value: T?`and an `error: Error?`. So based on your handler method, you will obtain a different result:

```swift
wp.session(endpoint: .posts).json { result in
    guard let json = result.value else {
        print(result.error!.localizedDescription)
        return
    }
    
    print(json is NSArray) 
    print(json)
}
```

Your action defined inside the closure will be fired when the request in the session ends. 

Considering that a `ResultHandler` method returns `self`, you can combine more handler without any problems:

```swift
wp
    .session(endpoint: .posts)
    .string { result in 
        print("String Handler")
    }
    .data { result in 
       print("Data Handler")
    }
```

What will happen?

1. The `.string` method will create a `WordpressGetTask` (which is a wrapper of an `URLSessionDataTask`) that will start immediatly (with a `.resume()`).
2. If there is a `WordpressGetTask` inside the session, that is `.suspended` or `.running`, the `.data` method handler will be added to the same task. 
    1. In this case, since there is only one `WordpressGetTask` involved, both handlers will use the same `data` and `error` (before making the internal transformation of the `Data` to your chosen return value)
3. If the previous task ends, a new task will be created. Then, a new `URLSessionDataTask` will start. 

It's important to note that **everything is execute asyncronously in a background thread** (you can use the `DispatchQueue.main.async {}` to run the code on the main thread). 

## Codable Models ##

WordpressKit contains several models that are useful when you want to decode your request results. The models represent the schema described inside the [Wordpress Doc](https://developer.wordpress.org/rest-api/reference/).

Actually our framework contains the following models: `WordpressPost` and `WordpressMedia`. Both contain inner models that are used to describe nested properties. 

### WordpressPost ###

`WordpressPost` is an **open class** that is conforms to `Codable` and describes the JSON representation of a wordpress's post. 

Useful links:

- `WordpressPost` properties [here](WordpressKit/Model/WP/Post.swift).
- Official Wordpress schema [here](https://developer.wordpress.org/rest-api/reference/posts/).

You can use the `WordpressPost` model to decode a single post or an array of posts. 

#### Decode a single post ####

You can request a single post by using the `WordpressEndpoints.post(id: string)` case while creating the get session. Remember, **even if your post ID is an integer you have to pass it as a string**. 

```swift
wordpress
    .get(endpoint: .post(id: "5508442"))
    .decode(type: WordpressPost.self) 
    { (result) in
    
        guard let post = result.value else {
            print(result.error!.localizedDescription)
            return
        }

        print(post.title.rendered)
        print(post.id)
        print(post.content.rendered)
    }
```

#### Decode an array of posts #####

To decode your posts you have to use the `.posts` endpoint and the `[WordpressPost].self` type. You will find your decoded posts inside the result handler value.

```swift
wordpress
    .get(endpoint: .posts)
    .decode(type: [WordpressPost].self)
    { (result) in
        if let posts = result.value {
            for post in posts {
                print(post.title.rendered)
            }
        }
    }
```

#### Why my post is not correctly decoded ####

`WordpressKit` is built to works in a common Wordpress environment. Probably, if your post is not correctly decoded it's because there is a trouble with the the post schema itself (example: some json key are lost).

**To try to solve this problem some `WordpressPost` model properties are defined as `Optional`.** You can inspect this properties [here](WordpressKit/Model/WP/Post.swift).

If you are not sure about your schema you can ispect it with [Postman](https://www.getpostman.com).


### WordpressEndpoints ###

At this moment the available version of `WordpressEndpoint` can contain these cases: 

```swift
public enum WordpressEndpoint {
    case posts
    case post(id: String)
    case revisions
    case categories
    case tags
    case pages
    case comments
    case taxonomies
    case media
    case users
    case types
    case statuses
    case settings
    case custom(path: String)
}
```

The default names of the endpoints are taken from the [Wordpress Doc](https://developer.wordpress.org/rest-api/reference/). Actually, in this version of WordpressKit, some cases aren't covered but you can use the `.custom(path: String)` case to handle these losses. 




