//
//  L2_3ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/9.
//  

import UIKit
import GLKit

class L2_3ViewController: BaseViewController {

    // vertex buffer object
    private var VBO1: GLuint = 0
    // element buffer object
    private var EBO1: GLuint = 0
    // vertex array object
    private var VAO1: GLuint = 0

    // vertex buffer object
    private var VBO2: GLuint = 0
    // element buffer object
    private var EBO2: GLuint = 0
    // vertex array object
    private var VAO2: GLuint = 0

    private let rectangleVertices: [L2Vertex] = [
        // 长方形
        L2Vertex(position: (0.5, 0, 0)),
        L2Vertex(position: (-0.5, 0, 0)),
        L2Vertex(position: (-0.5, -0.5, 0)),
        L2Vertex(position: (0.5, -0.5, 0)),
    ]

    // 索引数组
    private let rectangleIndices: [GLubyte] = [
        0, 1, 2,
        2, 3, 0
    ]

    private let triganleVertices: [L2Vertex] = [
        // 三角形
        L2Vertex(position: (1, 0, 0)),
        L2Vertex(position: (0, 0.5, 0)),
        L2Vertex(position: (-1, 0, 0)),
    ]

    private let triganleIndices: [GLubyte] = [
        0, 1, 2,
    ]

    private var curVertices: [L2Vertex] = []
    private var curIndices: [GLubyte] = []

    private let effect: GLKBaseEffect = GLKBaseEffect()

    private var count = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        //        setupBuffer()
        simpleSetupBuffer()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        //        originDraw()
        simpleDraw()
    }

    private func originDraw() {
        glClearColor(0, 0, 0, 1)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        // 调用执行的着色器
        effect.prepareToDraw()

        // 切换缓冲区
        if count % 2 == 0 {
            curIndices = rectangleIndices
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO1)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO1)
        } else {
            curIndices = triganleIndices
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO2)
            glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO2)
        }

        count += 1

        // 重传数据
        setupVertexAttributes()

        // 绘制
        glDrawElements(
            GLenum(GL_TRIANGLES),
            GLsizei(curIndices.count),
            GLenum(GL_UNSIGNED_BYTE),
            nil
        )
    }

    private func simpleDraw() {
        glClearColor(0, 0, 0, 1)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        // 调用执行的着色器
        effect.prepareToDraw()

        // 切换缓冲区
        if count % 2 == 0 {
            curIndices = rectangleIndices
            glBindVertexArrayOES(VAO1)
        } else {
            curIndices = triganleIndices
            glBindVertexArrayOES(VAO2)
        }

        count += 1

        // 绘制
        glDrawElements(
            GLenum(GL_TRIANGLES),
            GLsizei(curIndices.count),
            GLenum(GL_UNSIGNED_BYTE),
            nil
        )

        glBindVertexArrayOES(0)
    }
}

private extension L2_3ViewController {
    private func setupBuffer() {

        glGenBuffers(1, &VBO1)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO1)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            rectangleVertices.elementsSize,
            rectangleVertices,
            GLenum(GL_STATIC_DRAW)
        )

        glGenBuffers(1, &EBO1)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO1)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER),
            rectangleIndices.elementsSize,
            rectangleIndices,
            GLenum(GL_STATIC_DRAW)
        )

        glGenBuffers(1, &VBO2)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO2)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            triganleVertices.elementsSize,
            triganleVertices,
            GLenum(GL_STATIC_DRAW)
        )

        glGenBuffers(1, &EBO2)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO2)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER),
            triganleIndices.elementsSize,
            triganleIndices,
            GLenum(GL_STATIC_DRAW)
        )
    }

    private func simpleSetupBuffer() {

        glGenVertexArraysOES(1, &VAO1)
        glBindVertexArrayOES(VAO1)

        glGenBuffers(1, &VBO1)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO1)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            rectangleVertices.elementsSize,
            rectangleVertices,
            GLenum(GL_STATIC_DRAW)
        )

        glGenBuffers(1, &EBO1)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO1)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER),
            rectangleIndices.elementsSize,
            rectangleIndices,
            GLenum(GL_STATIC_DRAW)
        )

        setupVertexAttributes()

        glBindVertexArrayOES(0)

        glGenVertexArraysOES(1, &VAO2)
        glBindVertexArrayOES(VAO2)

        glGenBuffers(1, &VBO2)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO2)
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            triganleVertices.elementsSize,
            triganleVertices,
            GLenum(GL_STATIC_DRAW)
        )

        glGenBuffers(1, &EBO2)
        glBindBuffer(GLenum(GL_ELEMENT_ARRAY_BUFFER), EBO2)
        glBufferData(
            GLenum(GL_ELEMENT_ARRAY_BUFFER),
            triganleIndices.elementsSize,
            triganleIndices,
            GLenum(GL_STATIC_DRAW)
        )

        setupVertexAttributes()

        glBindVertexArrayOES(0)
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
