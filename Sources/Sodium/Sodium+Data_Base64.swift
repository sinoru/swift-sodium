//
//  Sodium+Data_Base64.swift
//
//
//  Created by Jaehong Kang on 8/13/24.
//

import Clibsodium

extension Sodium.Data {
    @inlinable
    public init(
        base64Encoded base64String: String,
        removingPercentEncoding: Bool,
        padding: Bool
    ) throws {
        let variant: Int32
        switch (removingPercentEncoding, padding) {
        case (false, true):
            variant = sodium_base64_VARIANT_ORIGINAL
        case (false, false):
            variant = sodium_base64_VARIANT_ORIGINAL_NO_PADDING
        case (true, true):
            variant = sodium_base64_VARIANT_URLSAFE
        case (true, false):
            variant = sodium_base64_VARIANT_URLSAFE_NO_PADDING
        }

        let underestimatedCount = base64String.count / 4 * 3
        let data = try Array<UInt8>(unsafeUninitializedCapacity: base64String.count / 4 * 3) { buffer, initializedCount in
            var dataCount: Int = 0

            let result = base64String.withCString { cString in
                sodium_base642bin(buffer.baseAddress!, underestimatedCount, cString, base64String.count, nil, &dataCount, nil, variant)
            }

            guard result >= 0 else {
                throw Sodium.Error.unknown
            }

            initializedCount = dataCount
        }

        self.init(data)
    }

    @inlinable
    public func base64EncodedString(
        addingPercentEncoding: Bool,
        padding: Bool
    ) -> String {
        let variant: Int32
        switch (addingPercentEncoding, padding) {
        case (false, true):
            variant = sodium_base64_VARIANT_ORIGINAL
        case (false, false):
            variant = sodium_base64_VARIANT_ORIGINAL_NO_PADDING
        case (true, true):
            variant = sodium_base64_VARIANT_URLSAFE
        case (true, false):
            variant = sodium_base64_VARIANT_URLSAFE_NO_PADDING
        }

        let base64EstimatedCount = sodium_base64_encoded_len(count, variant)

        var data: [UInt8] = Array(self)
        let cString = Array<UInt8>(
            unsafeUninitializedCapacity: base64EstimatedCount
        ) { buffer, initializedCount in
            sodium_bin2base64(buffer.baseAddress!, base64EstimatedCount, &data, data.count, variant)
            initializedCount = base64EstimatedCount
        }

        return String(cString: cString)
    }
}
