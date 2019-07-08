//
//  L2ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/8.
//  

import UIKit
import GLKit

class L2_1ViewController: BaseViewController {

    // vertex buffer object
    private var VBO: GLuint = 0

    // 顶点数组
    private let vertices: [L2Vertex] = [
        L2Vertex(position: (0, 0.7, 0)), // 点

        L2Vertex(position: (-1, 0.5, 0)), // 线
        L2Vertex(position: (1, 0.5, 0)), // 线

        // 三角形
        L2Vertex(position: (0, 0.5, 0)),
        L2Vertex(position: (-0.5, -0.5, 0)),
        L2Vertex(position: (0.5, -0.5, 0)),

        // 长方形
        L2Vertex(position: (0.5, -0.6, 0)),
        L2Vertex(position: (0.5, -0.8, 0)),
        L2Vertex(position: (-0.5, -0.6, 0)),

        L2Vertex(position: (0.5, -0.8, 0)),
        L2Vertex(position: (-0.5, -0.6, 0)),
        L2Vertex(position: (-0.5, -0.8, 0)),
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

        // 绘制所需要的物体
        // 第一个参数是: 绘制的图元类型
        // 第二个参数是: 顶点数组的起始索引
        // 第三个参数是：打算绘制的顶点个数
        glDrawArrays(GLenum(GL_POINTS), 0, 1)
        glDrawArrays(GLenum(GL_LINES), 1, 2)
        glDrawArrays(GLenum(GL_TRIANGLES), 3, 3)

        // 绘制长方形
        glDrawArrays(GLenum(GL_TRIANGLES), 6, 6)
    }
}

private extension L2_1ViewController {
    private func setupBuffer() {
        // 创建缓冲区对象
        glGenBuffers(1, &VBO)

        // 将上面生成的缓存区对象设置为当前缓冲区对象
        // 提示: OpenGL 自身就是一个状态机
        // GL_ARRAY_BUFFER 指顶点数组缓冲区对象
        // GL_ELEMENT_ARRAY_BUFFER 指索引缓冲区对象
        // 目前我们先使用 GL_ARRAY_BUFFER。
        // 后面会当顶点出现重复后，我们会使用 GL_ELEMENT_ARRAY_BUFFER 来减少顶点数据传输量。
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), VBO)

        // 为缓冲区申请内存空间，并进行初始化
        //
        // 提示: 之前我很疑惑 glBufferData 是怎么知道把 vertices 数据赋值到 VBO 里面的。
        //      因为 API 并没有传入 VBO 参数，直到我理解上面的提示: OpenGL 自身就是一个状态机。
        //      glBindBuffer 其实已经把 VBO 设置为当前缓冲区对象了。所以下面的所有操作都是基于 VBO。
        //
        // vertices.elementsSize 表示初始化的大小
        // vertices 则是初始化元素
        glBufferData(
            GLenum(GL_ARRAY_BUFFER),
            vertices.elementsSize,
            vertices,
            GLenum(GL_STATIC_DRAW)
        )
    }

    private func setupVertexAttributes() {
        // 着色器属性
        let position = GLuint(GLKVertexAttrib.position.rawValue)

        // 开启顶点着色器属性
        // 出于性能考虑，所有顶点着色器的属性都是关闭的。
        glEnableVertexAttribArray(position)

        // 传输顶点着色器属性
        // 这一步是将数据从 CPU 传送到 GPU
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
