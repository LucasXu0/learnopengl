//
//  L1ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/7.
//  

import UIKit
import GLKit

class L1ViewController: GLKViewController {

    override func loadView() {
        self.view = GLKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        (self.view as! GLKView).context = EAGLContext(api: .openGLES2)!
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        let randomColor = self.randomColor()
        glClearColor(randomColor.r, randomColor.g, randomColor.b, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
}

private extension L1ViewController {
    private func randomColor() -> (r: GLclampf, g: GLclampf, b: GLclampf) {
        let r = GLclampf(arc4random() % 256) / 255.0
        let g = GLclampf(arc4random() % 256) / 255.0
        let b = GLclampf(arc4random() % 256) / 255.0

        return (r, g, b)
    }
}
