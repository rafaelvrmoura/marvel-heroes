# iOS app to consume Marvel API using Moya.

This project is an iOS app that consumes Marvel API using Moya framework.

## Instructions
  To consme Marvel API you must have both private and public keys. 
  This project expects that you to create an `APIKeys.plis` file into app's bundle.

This file must have two elements in the root dictionary: 

`key: private_key, value: your private key`

`key: public_key, value: your public key`
  
If you don't have these credentials yet, please access [Marvel API](https://developer.marvel.com) and request one. 
  
## Dependences

* RxSwift
* RxCocoa
* Moya
* Kingfisher
  
