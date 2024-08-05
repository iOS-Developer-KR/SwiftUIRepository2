import UIKit


var components = URLComponents(string: "https://api.themoviedb.org/3/movie/157336")
let apiKey = URLQueryItem(name: "api_key", value: "examplekeytogetmovie")

components?.queryItems = [apiKey]

components?.url

components?.fragment

components?.host

components?.password

components?.path

components?.port

components?.query

components?.queryItems

components?.scheme

components?.user

var urlComponents = URLComponents(string: "https://api.themoviedb.org")

urlComponents?.path = "/3/movie/157336"//endPoint.path
urlComponents?.queryItems = [URLQueryItem(name: "api", value: "examplekeytogetmovie")]

urlComponents?.url
