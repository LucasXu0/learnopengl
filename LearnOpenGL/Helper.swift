//
//  Array+Extension.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/8.
//  

import Foundation

extension Array {
    var elementsSize: Int {
        return MemoryLayout<Element>.size * self.count
    }
}
