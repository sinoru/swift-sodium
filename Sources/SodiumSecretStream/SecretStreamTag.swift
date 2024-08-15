//
//  SecretStreamTag.swift
//
//
//  Created by Jaehong Kang on 8/15/24.
//

public protocol SecretStreamTag: RawRepresentable where RawValue == UInt8 {
    static var message: Self { get }
    static var final: Self { get }
    static var push: Self { get }
    static var rekey: Self { get }
}
