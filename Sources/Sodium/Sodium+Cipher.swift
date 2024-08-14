//
//  Sodium+Cipher.swift
//  
//
//  Created by Jaehong Kang on 8/13/24.
//

extension Sodium {
    public protocol Cipher: Sendable {

        init()
    }

    public protocol AEADCipher: Cipher {

    }
}
