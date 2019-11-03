# WordpressKit
Wordpress API | Swift framework

WordpressKit helps you to handle Wordpress REST API in an elegant and composable way. Its build on top of URLSession provided by the Foundation framework. 

Actually, WordpressKit covers only the GET HTTP method of the basic endpoints described by [REST API Handbooks](https://developer.wordpress.org/rest-api/reference/)

## Wordpress ##

Everything starts from the `Wordpress` object that is responsible to create the `WordpressSession`. You can create a Wordpress object by defining the REST API `domain` and the relative `namespace`

## Making Request ##
