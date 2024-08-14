//
//  Sodium+Data_Random.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension Sodium.Data {
    public static func random(count: Int) -> Self {
        withUnsafeTemporaryAllocation(of: UInt8.self, capacity: count) { buffer in
            randombytes_buf(
                buffer.baseAddress!,
                count
            )

            return self.init(buffer)
        }
    }
}
