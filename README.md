# WordpressKit
Wordpress API | Swift framework

WordpressKit helps you to handle Wordpress [REST API](https://developer.wordpress.org/rest-api/reference/) in an elegant and composable way. Its build on top of URLSession provided by the Foundation framework. 

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

# Usage # 

## Wordpress ##

Everything starts from  `Wordpress` object which is responsible to create the `WordpressSession`. You can instantiate a Wordpress object by passing the REST API string URL to the `route` parameter and a case of `WordpressNamespace` to the `namespace` parameter.

In a normal WP configuration, the `route` of the REST API is located under `https://oursite.com/wp-json/` and the core `namespace` is `/wp/v2/`. 

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

## Making Request ##
