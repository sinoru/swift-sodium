//
//  Sodium+Error.swift
//
//
//  Created by Jaehong Kang on 8/12/24.
//

extension Sodium {
    public enum Error: Swift.Error {
        case unknown
        case cannotInitialize
        case invalidMessageLength
        case invalidData
    }
}
