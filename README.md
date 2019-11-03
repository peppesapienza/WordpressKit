# WordpressKit
Wordpress API | Swift framework

WordpressKit helps you to handle Wordpress [REST API](https://developer.wordpress.org/rest-api/reference/) in an elegant and composable way. Its build on top of URLSession provided by the Foundation framework. 

## Wordpress ##

Everything starts from  `Wordpress` object which is responsible to create the `WordpressSession`. You can instantiate a Wordpress object by passing the REST API string URL to the `route` parameter and a case of `WordpressNamespace` to the `namespace` parameter.

In a normal WP configuration, the `route` of the REST API is located under `https://oursite.com/wp-json/` and the core `namespace` is `/wp/v2/`. So, with WordpressKit, you can represent an instance of your Wordpress REST API by creating a `Wordpress` object like that:

```swift
import WordpressKit

let wp = Wordpress(route: "https://oursite.com/wp-json/", namespace: .wp(v: .v2))
```

## Making Request ##
