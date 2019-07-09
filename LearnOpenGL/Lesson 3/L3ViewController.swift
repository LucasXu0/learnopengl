//
//  L3ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/9.
//  

import Foundation
import GLKit

class L3ViewController: BaseViewController {

    // 注意: effect 的初始化需要在设置 EAGLContext.setCurrent 后
    private lazy var effect: L3BaseEffect = L3BaseEffect("l3vertex.vsh", "l3fragment.fsh")

    // vertex buffer object
    private var VBO: GLuint = 0

    // 顶点数组
    private let vertices: [L3Vertex] = [
        // 三角形
        L3Vertex(position: (0, 0.5, 0), color: (0, 0, 0, 1)),
        L3Vertex(position: (-0.5, -0.5, 0), color: (0, 0, 0, 1)),
        L3Vertex(position: (0.5, -0.5, 0), color: (0, 0, 0, 1))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBuffer()
        setupVertexAttributes()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {

        glClearColor(1, 1, 1, 1)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        effect.prepareToDraw()

        glDrawArrays(GLenum(GL_TRIANGLES), 0, GLsizei(vertices.count))
    }
}

private extension L3ViewController {
    private func setupBuffer() {

        // 再次三部曲
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            vertices.elementsSize,
            vertices,
            GLenum(GL_STATIC_DRAW)
        )
    }

    private func setupVertexAttributes() {

        // 这里需要注意，因为我们已经切换为自定义的 BaseEffect，所以对应的顶点属性指也记得要修改
        glEnableVertexAttribArray(L3VertexAttrib.position.rawValue)

        // 传输坐标
        glVertexAttribPointer(
            L3VertexAttrib.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<L3Vertex>.stride),
            UnsafeRawPointer(bitPattern: 0)
        )

        glEnableVertexAttribArray(L3VertexAttrib.color.rawValue)

        // 传输颜色
        glVertexAttribPointer(
            L3VertexAttrib.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<L3Vertex>.stride),
            UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size)
        )
    }
}
