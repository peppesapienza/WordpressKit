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

Its build on top of `URLSession` provided by the Foundation framework. 

# Usage # 

## Wordpress ##

Everything starts from  `Wordpress` object which is responsible to create the `WordpressSession`. You can instantiate a Wordpress object by passing: the REST API string URL to the `route` parameter and `WordpressNamespace` case to the `namespace` parameter.

> In a normal WP configuration, the `route` of the REST API is located under `https://oursite.com/wp-json/` and the core `namespace` is `/wp/v2/`. 

So, with WordpressKit, **you can represent an instance of your Wordpress REST API by creating a `Wordpress` object like that**:

```swift
import WordpressKit

let wp = Wordpress(route: "https://oursite.com/wp-json/", namespace: .wp(v: .v2))
```

### Custom WordpressNamespace ###

This is the base form of a `Wordpress` instance creation. If your WP has another API configuration, for example you renamed the `wp-json` or you changed the default namespace, this is the definition of the `init`:

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

So you can compose your API URL like these examples: 

```swift
// https://example.com/api/plugin/v1
Wordpress(route: "https://example.com/api", namespace: .plugin(name: "plugin", v: .v1))

// https://example.com/wp-json/plugin/v1
Wordpress(route: "https://example.com/wp-json", namespace: .custom(path: "plugin/v1"))

// https://example.com/wp-json/my-plugin/10
Wordpress(route: "https://example.com/wp-json", namespace: .plugin(name: "my-plugin", v: .custom(v: "10")))
```

## WordpressGetSession: Preparing a GET Session ##

**To perform a request with a `Wordpress` object first you must create a `WordpressGetSession`** by passing to the `get` method a `WordpressEndpoint` case. 

```swift
public func get(endpoint: WordpressEndpoint) -> WordpressGetSession
```

So, **if you want to get the posts of your website your code would look like this:**

```swift
let wp: Wordpress = Wordpress(route: "https://www.xcoding.it/wp-json", namespace: .wp(v: .v2))
let session: WordpressGetSession = wp.get(endpoint: .posts)

// or, in a more concise way

Wordpress(route: "https://www.xcoding.it/wp-json", namespace: .wp(v: .v2))
    .get(endpoint: .posts)
```

`WordpressGetSession` internally contains a `URLSession` property that is used to manage one or more `URLRequest` based on your `query` and `ResultHandler` usage. 

For example, if you want to manage the `List` or `UITableView` pagination you can use a single `WordpressGetSession` and change the `.query(key: .page, value: "\(nextPage)")` at runtime. We will discuss this topic in the `query` paragraph. 

### Making a Request ###

To start the communication with your api, and so starting a real `URLRequest`, you need to use one of the `ResultHandler` methods of your `WordpressGetSession` object:

```swift
func json(result: @escaping ResultHandler<Any>) -> Self
func string(result: @escaping ResultHandler<String>) -> Self
func data(result: @escaping ResultHandler<Data>) -> Self
func decode<T>(type: T.Type, result: @escaping ResultHandler<T>) -> Self where T: Decodable
```


### WordpressEndpoints ###

At the moment the avaiable `WordpressEndpoints` are: 

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
The default names of the endpoints are taken from the [Wordpress Doc](https://developer.wordpress.org/rest-api/reference/). Actually, in this version of WordpressKit, some cases aren't covered but you can use the `.custom(path: String)` case to handle these missing. 


