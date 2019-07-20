//
//  L6ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/10.
//  

import Foundation
import GLKit

private let scale = GLfloat((UIScreen.main.bounds.width / (2.0 * UIScreen.main.bounds.height)))

class L6ViewController: BaseViewController {

    // 注意: effect 的初始化需要在设置 EAGLContext.setCurrent 后
    private lazy var effect: L6BaseEffect = {
        let effect = L6BaseEffect("l6vertex.vsh", "l6fragment.fsh")
        effect.setTexture("L6.png")
        return effect
    }()

    // vertex buffer object
    private var VBO: GLuint = 0

    // 顶点数组
    private let vertices: [L6Vertex] = [

        L6Vertex(position: (-0.5, -scale, 0), color: (1, 0, 0, 1), texCoord: (0, 0)),
        L6Vertex(position: (0.5, -scale, 0), color: (0, 1, 0, 1), texCoord: (1, 0)),
        L6Vertex(position: (0.5, scale, 0), color: (0, 0, 1, 1), texCoord: (1, 1)),
        L6Vertex(position: (-0.5, scale, 0), color: (0, 1, 0, 1), texCoord: (0, 1)),
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
        setupBuffer()
        setupVertexAttributes()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {

        glClearColor(1, 1, 1, 1)
        glClear(GLenum(GL_COLOR_BUFFER_BIT))

        effect.prepareToDraw()

        // 传入变换矩阵
        effect.modelMatrix = GLKMatrix4Identity
        effect.viewMatrix = GLKMatrix4Identity
        effect.projectionMatrix = GLKMatrix4Identity

        glDrawArrays(GLenum(GL_TRIANGLE_FAN), 0, GLsizei(vertices.count))
    }
}

private extension L6ViewController {
    private func setupSlider() {

        let x: CGFloat = 50
        let y: CGFloat = 100
        let width: CGFloat = UIScreen.main.bounds.size.width - 2 * x
        let height: CGFloat = 20

        let frame = CGRect(x: x, y: y, width: width, height: height)
        let slider = UISlider(frame: frame)
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(slider)
    }

    @objc
    private func sliderValueChanged(_ slider: UISlider) {
        print(slider.value)
    }

    private func modelMatrix() -> GLKMatrix4 {
        var modelMatrix = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Translate(modelMatrix, 0.5, -0.5, 0) // 平移
        modelMatrix = GLKMatrix4Scale(modelMatrix, 0.5, 0.5, 1) // 缩放
        let radians = linearRadians()
        modelMatrix = GLKMatrix4Rotate(modelMatrix, radians, 0, 1, 0) // 旋转, 沿 Y 轴旋转 45°
        return modelMatrix
    }

    private func linearRadians() -> Float {
        return sinf(Float(CACurrentMediaTime())/2.0) * Float.pi
    }

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
        glEnableVertexAttribArray(VertexAttrib.position.rawValue)

        // 传输坐标
        glVertexAttribPointer(
            VertexAttrib.position.rawValue,
            3,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<L6Vertex>.stride),
            UnsafeRawPointer(bitPattern: 0)
        )

        glEnableVertexAttribArray(VertexAttrib.color.rawValue)

        // 传输颜色
        glVertexAttribPointer(
            VertexAttrib.color.rawValue,
            4,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<L6Vertex>.stride),
            UnsafeRawPointer(bitPattern: 3 * MemoryLayout<GLfloat>.size)
        )

        glEnableVertexAttribArray(VertexAttrib.textureCoordinate.rawValue)

        // 传输纹理坐标
        glVertexAttribPointer(
            VertexAttrib.textureCoordinate.rawValue,
            2,
            GLenum(GL_FLOAT),
            GLboolean(GL_FALSE),
            GLsizei(MemoryLayout<L6Vertex>.stride),
            UnsafeRawPointer(bitPattern: (3 + 4) * MemoryLayout<GLfloat>.size)
        )
    }
}

