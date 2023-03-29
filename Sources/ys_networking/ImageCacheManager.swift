//
//  File.swift
//  
//
//  Created by Bradley.yoon on 2023/03/28.
//

import Foundation
import UIKit


public class ImageCachedManager {
    public static let shared = NSCache<NSString, UIImage>()
    
    public init() { }
    
    
}
