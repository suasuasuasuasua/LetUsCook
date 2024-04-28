//
//  URL_size.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/24/24.
//

import Foundation

extension URL {
    var size: UInt64 {
        var size: UInt64 = 0
        let attributes = try? FileManager.default.attributesOfItem(
            atPath: path(percentEncoded: false)
        )
        if let attr = attributes,
           let s = attr[FileAttributeKey.size] as? UInt64
        {
            size = s
        }

        return size
    }
}

extension UInt64 {
    var B2KB: Self {
        return self / UInt64(pow(2.0, 10))
    }
}
