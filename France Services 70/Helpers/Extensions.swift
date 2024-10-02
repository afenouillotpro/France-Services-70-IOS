//
//  Extensions.swift
//  France Services 70
//
//  Created by antoine fenouillot on 09/08/2024.
//
import Foundation
import UIKit

//MARK: - IMAGE EXTENSION

extension UIImage {
  func resizeImage(size: CGSize) -> UIImage {
    let originalSize = self.size
    let ratio: CGFloat = {
        return originalSize.width > originalSize.height ? 1 / (size.width / originalSize.width) :
                                                          1 / (size.height / originalSize.height)
    }()

    return UIImage(cgImage: self.cgImage!, scale: self.scale * ratio, orientation: self.imageOrientation)
  }
}

//MARK: - STRING EXTENSION

extension Optional where Wrapped == String {
var nilIfEmpty: String? {
    guard let strongSelf = self else {
        return nil
    }
    return strongSelf.isEmpty ? nil : strongSelf
}
}

//MARK: CONTAINER
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

//MARK: DATE
extension Date {
    var millisecondsSince1970:Double {
        //Double((self.timeIntervalSince1970 * 1000.0).rounded())
        Double((self.timeIntervalSince1970).rounded())
    }
    
    /*init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }*/
}


