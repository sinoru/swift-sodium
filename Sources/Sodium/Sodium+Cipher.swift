//
//  Sodium+Cipher.swift
//  
//
//  Created by Jaehong Kang on 8/13/24.
//

extension Sodium {
    public protocol Cipher {
        var _storage: [ObjectIdentifier: Any] { get set }

        init()
    }

    public protocol AEADCipher: Cipher {

    }
}

extension Sodium.Cipher {
    internal func value<T>(for type: T.Type) -> T {
        guard let value = _storage[ObjectIdentifier(type)] as? T else {
            fatalError("Can't access value!")
        }
        return value
    }

    internal mutating func setValue<T>(_ value: T, for type: T.Type = T.self) {
        _storage[ObjectIdentifier(type)] = value
    }
}
