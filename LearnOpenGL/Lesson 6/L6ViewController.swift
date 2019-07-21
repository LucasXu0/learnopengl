//
//  L6ViewController.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/10.
//  

import Foundation
import GLKit

private let scale = GLfloat(UIScreen.main.bounds.width / UIScreen.main.bounds.height) // 屏幕缩放比例

class L6ViewController: BaseViewController {

    private let label = UILabel()

    // 注意: effect 的初始化需要在设置 EAGLContext.setCurrent 后
    private lazy var effect: L6BaseEffect = {
        let effect = L6BaseEffect("l6vertex.vsh", "l6fragment.fsh")
        effect.setTexture("L6.png")
        return effect
    }()

    // vertex buffer object
    private var VBO: GLuint = 0
    // element buffer object
    private var EBO: GLuint = 0

    // 顶点数组
    private let vertices: [L6Vertex] = [

        // Front
        L6Vertex(position: (1, -scale, 1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 0
        L6Vertex(position: (1, scale, 1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 0
        L6Vertex(position: (-1, scale, 1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 0
        L6Vertex(position: (-1, -scale, 1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 0

        // Back
        L6Vertex(position: (-1, -scale, -1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 0
        L6Vertex(position: (-1, scale, -1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 1
        L6Vertex(position: (1, scale, -1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 2
        L6Vertex(position: (1, -scale, -1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 3

        // Left
        L6Vertex(position: (-1, -scale, 1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 4
        L6Vertex(position: (-1, scale, 1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 5
        L6Vertex(position: (-1, scale, -1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 6
        L6Vertex(position: (-1, -scale, -1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 7

        // Right
        L6Vertex(position: (1, -scale, -1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 8
        L6Vertex(position: (1, scale, -1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 9
        L6Vertex(position: (1, scale, 1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 10
        L6Vertex(position: (1, -scale, 1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 11

        // Top
        L6Vertex(position: (1, scale, 1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 12
        L6Vertex(position: (1, scale, -1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 13
        L6Vertex(position: (-1, scale, -1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 14
        L6Vertex(position: (-1, scale, 1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 15

        // Bottom
        L6Vertex(position: (1, -scale, -1), color: (1, 0, 0, 1), texCoord: (1, 0)), // 16
        L6Vertex(position: (1, -scale, 1), color: (0, 1, 0, 1), texCoord: (1, 1)), // 17
        L6Vertex(position: (-1, -scale, 1), color: (0, 0, 1, 1), texCoord: (0, 1)), // 18
        L6Vertex(position: (-1, -scale, -1), color: (0, 0, 0, 1), texCoord: (0, 0)), // 19
    ]

    // 索引数组
    private let indices: [GLubyte] = [
        // Front
        0, 1, 2,
        2, 3, 0,

        // Back
        4, 5, 6,
        6, 7, 4,

        // Left
        8, 9, 10,
        10, 11, 8,

        // Right
        12, 13, 14,
        14, 15, 12,

        // Top
        16, 17, 18,
        18, 19, 16,

        // Bottom
        20, 21, 22,
        22, 23, 20
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSlider()
        setupBuffer()
        setupVertexAttributes()
    }

    override func glkView(_ view: GLKView, drawIn rect: CGRect) {

        glEnable(GLenum(GL_CULL_FACE))
        glEnable(GLenum(GL_DEPTH_TEST))
        glClearColor(1, 1, 1, 1)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT) | GLbitfield(GL_DEPTH_BUFFER_BIT))

        effect.prepareToDraw()

        var modelMatrix = GLKMatrix4Identity
        modelMatrix = GLKMatrix4Scale(modelMatrix, 0.2, 0.2, 0.2) // 缩小 0.2 倍
        effect.modelMatrix = modelMatrix

//        effect.projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0),
//                                                             GLfloat(1),
//                                                             0,
//                                                             100)

        glDrawElements(
            GLenum(GL_TRIANGLES),
            GLsizei(indices.count),
            GLenum(GL_UNSIGNED_BYTE),
            nil
        )
    }
}

private extension L6ViewController {
    private func setupSlider() {

        let x: CGFloat = 50
        let y: CGFloat = 100
        let width: CGFloat = UIScreen.main.bounds.size.width - 2 * x
        let height: CGFloat = 20
        let padding: CGFloat = 20

        for i in 0..<3 {
            let frame = CGRect(x: x, y: y + CGFloat(i) * (height + padding), width: width, height: height)
            let slider = UISlider(frame: frame)
            slider.value = 0.5
            slider.tag = i + 10000
            slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
            view.addSubview(slider)
        }

        label.frame = CGRect.init(x: x, y: UIScreen.main.bounds.size.height - 50, width: width, height: 30)
        view.addSubview(label)
    }

    @objc
    private func sliderValueChanged(_ slider: UISlider) {

        var tx: Float = 0.0
        var ty: Float = 0.0
        var tz: Float = 0.0
        for i in 0..<3 {
            let slider = view.viewWithTag(i + 10000) as! UISlider
            let result = Float((slider.value - 0.5) * 2)
            if i == 0 {
                tx = result
            } else if i == 1 {
                ty = result
            } else if i == 2 {
                tz = result
            }
        }

        effect.viewMatrix = GLKMatrix4MakeLookAt(tx, ty, tz, 0, 0, 0, 0, 1, 0)

        label.text = "x: \(tx) y: \(ty), z: \(tz)"
    }

    private func modelMatrix() -> GLKMatrix4 {
        var modelMatrix = GLKMatrix4Identity
        let radians = linearRadians()
        modelMatrix = GLKMatrix4Rotate(modelMatrix, radians, 0, 1, 0) // 旋转, 沿 Y 轴旋转
        return modelMatrix
    }

    private func linearRadians() -> Float {
        return Float(CACurrentMediaTime() / 3.0)
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

