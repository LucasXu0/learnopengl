//
//  BaseViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/8.
//  

import UIKit
import GLKit

class BaseViewController: GLKViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let context = EAGLContext(api: .openGLES2) else {
            fatalError()
        }

        (self.view as! GLKView).context = context
        EAGLContext.setCurrent(context)

        // WARNING: 千万不要这样写
        // setCurrent 的含义是设置当前上下文，如果向下面这样写相当于重新赋值，会导致一系列的错误。
        // (self.view as! GLKView).context = EAGLContext(api: .openGLES2)!
        // EAGLContext.setCurrent(EAGLContext(api: .openGLES2)!)
    }
}
