//
//  L2_1ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/8.
//

import UIKit
import GLKit

class L2_2ViewController: BaseViewController {

    // vertex buffer object
    private var VBO: GLuint = 0
    // element buffer object
    private var EBO: GLuint = 0

    // 顶点数组
    private let vertices: [L2Vertex] = [
        // 长方形
        L2Vertex(position: (0.5, -0.6, 0)),
        L2Vertex(position: (0.5, -0.8, 0)),
        L2Vertex(position: (-0.5, -0.6, 0)),
        L2Vertex(position: (-0.5, -0.8, 0)),
    ]

    // 索引数组
    private let indices: [GLubyte] = [
        0, 1, 2,
        1, 2, 3
    ]

    private let effect: GLKBaseEffect = GLKBaseEffect()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupBuffer()
        setupVertexAttributes()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0, 0, 0, 1)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        // 调用执行的着色器
        effect.prepareToDraw()

        // 绘制长方形
        glDrawElements(
            GLenum(GL_TRIANGLES),
            GLsizei(indices.count),
            GLenum(GL_UNSIGNED_BYTE),
            nil
        )
    }
}

private extension L2_2ViewController {
    private func setupBuffer() {
        // 设置 VAO 数据
        glGenBuffers(1, &VBO)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            vertices.elementsSize,
            vertices,
            GLenum(GL_STATIC_DRAW)
        )

        // 设置 VBO 数据
        // 还是按照三部曲走
        glGenBuffers(1, &EBO)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER),
            indices.elementsSize,
            indices,
            GLenum(GL_STATIC_DRAW)
        )
    }

    private func setupVertexAttributes() {
        let position = GLuint(GLKVertexAttrib.position.rawValue)

        glEnableVertexAttribArray(position)
        glVertexAttribPointer(
            position, // 传输的顶点属性
            3, // 顶点属性的参数个数，这里是 (x, y, z)，所以是 3 个。
            GLenum(GL_FLOAT), // 参数类型 -> GLfloat
            GLboolean(GL_FALSE), // 是否标准化 01 坐标系
            GLsizei(MemoryLayout<L2Vertex>.stride), // 步长, 相邻顶点属性间的间距
            nil
        )
    }
}
