//
//  Sodium+Data_Random.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension Sodium.Data {
    public static func random(count: Int) -> Self {
        let data = Array<UInt8>(
            unsafeUninitializedCapacity: count
        ) { buffer, initializedCount in
            randombytes_buf(
                buffer.baseAddress!, count
            )
        }

        return self.init(data)
    }
}
