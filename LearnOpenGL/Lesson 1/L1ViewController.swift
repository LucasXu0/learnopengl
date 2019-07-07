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
        // 1. 设置当前的 View 为 GLKView
        self.view = GLKView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // 2. 设置当前 OpenGL 上下文运行的版本，这里选择的是 OpenGLES 2。
        // 至于 OpenGLES 123 之间的区别，可以自行 google。
        (self.view as! GLKView).context = EAGLContext(api: .openGLES2)!
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        // 3. 渲染我们想要的画面
        let randomColor = self.randomColor()

        // glClearColor 的命名可能会让人有点误解，实际上它的作用是设置背景颜色，并不是clear(清除)颜色。
        glClearColor(randomColor.r, randomColor.g, randomColor.b, 1)
        // glClear 的意思是清除屏幕当前颜色，将屏幕颜色还原为背景颜色(就是上面我们通过glClearColor设置的背景颜色)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
    }
}

private extension L1ViewController {
    // 随机颜色函数
    private func randomColor() -> (r: GLclampf, g: GLclampf, b: GLclampf) {
        let r = GLclampf(arc4random() % 256) / 255.0
        let g = GLclampf(arc4random() % 256) / 255.0
        let b = GLclampf(arc4random() % 256) / 255.0

        return (r, g, b)
    }
}
