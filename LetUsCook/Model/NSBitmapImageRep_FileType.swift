//
//  File.swift
//  LetUsCook
//
//  Created by Justin Hoang on 4/22/24.
//

import AppKit
import Foundation

extension NSBitmapImageRep.FileType {
    static func fromExtension(_ fileExtension: String) -> Self {
        return switch fileExtension {
        case ".png":
            Self.png
        default:
            Self.jpeg
        }
    }
}
