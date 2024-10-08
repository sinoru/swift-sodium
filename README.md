# Swift Sodium

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsinoru%2Fswift-sodium%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/sinoru/swift-sodium)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fsinoru%2Fswift-sodium%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/sinoru/swift-sodium)

**Swift Sodium** is an open-source package of [libsodium][libsodium] implementations for the Swift programming language.

[libsodium]: https://libsodium.org

## Contents

The package currently provides the following implementations:

- [`SecretBox`][SecretBox]

- [`SecretStream`][SecretStream]

[SecretBox]: Sources/SodiumSecretBox
[SecretStream]: Sources/SodiumSecretStream

## Example

### SecretBox

```swift
import SodiumSecretBox

let secretBox = try SecretBox<XSalsa20Poly1305>()

// This is generated key for you.
// If you want, you can supply it manually on init.
secretBox.key 

let originalData: Array<UInt8> = .init("text".utf8)
let encryptedData = try secretBox.seal(Array("text".utf8))
let decryptedData = try secretBox.open(encryptedData.data, nonce: encryptedData.nonce)
```

### SecretStream

```swift
import SodiumSecretStream

let encryptionSecretStream = try SecretStream<XChaCha20Poly1305>()

// This is generated key for you.
// If you want, you can supply it manually on init.
encryptionSecretStream.key

let messagePart1: Array<UInt8> = .init("Arbitrary data to encrypt".utf8)
let messagePart2: Array<UInt8> = .init("split into".utf8)
let messagePart3: Array<UInt8> = .init("three messages".utf8)

var encryptionSecretStream = try SecretStream<XChaCha20Poly1305>()
let cipherTextPart1 = try encryptionSecretStream.push(messagePart1)
let cipherTextPart2 = try encryptionSecretStream.push(messagePart2)
let cipherTextPart3 = try encryptionSecretStream.push(messagePart3, tag: .final)

var decryptionSecretStream = SecretStream<XChaCha20Poly1305>(
    key: encryptionSecretStream.key,
    header: encryptionSecretStream.header
)

let decryptedMessagePart1 = try decryptionSecretStream.pull(cipherTextPart1)
let decryptedMessagePart2 = try decryptionSecretStream.pull(cipherTextPart2)
let decryptedMessagePart3 = try decryptionSecretStream.pull(cipherTextPart3)
```
