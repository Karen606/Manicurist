//
//  Font.swift
//  Manicurist
//
//  Created by Karen Khachatryan on 27.09.24.
//

import UIKit

extension UIFont {
    static func regular(size: CFloat) -> UIFont? {
        return UIFont(name: .regular, size: CGFloat(size))
    }
    
    static func medium(size: CFloat) -> UIFont? {
        return UIFont(name: .medium, size: CGFloat(size))
    }
    
    static func semibold(size: CFloat) -> UIFont? {
        return UIFont(name: .semibold, size: CGFloat(size))
    }
    
    static func bold(size: CFloat) -> UIFont? {
        return UIFont(name: .bold, size: CGFloat(size))
    }
    
    static func italicMedium(size: CFloat) -> UIFont? {
        return UIFont(name: .italicMedium, size: CGFloat(size))
    }
    
    static func displayRegular(size: CFloat) -> UIFont? {
        return UIFont(name: .displayRegular, size: CGFloat(size))
    }
    
    static func modernoMedium(size: CFloat) -> UIFont? {
        return UIFont(name: .MuseoModernoMedium, size: CGFloat(size))
    }
    
    static func modernoRegular(size: CFloat) -> UIFont? {
        return UIFont(name: .MuseoModernoRegular, size: CGFloat(size))
    }
    
    static func modernoBold(size: CFloat) -> UIFont? {
        return UIFont(name: .MuseoModernoBold, size: CGFloat(size))
    }
}
