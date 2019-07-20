//
//  L6BaseEffect.swift
//  LearnOpenGL
//
//  Created by xurunkang on 2019/7/10.
//  

import Foundation
import GLKit

class L6BaseEffect {

    private var texture: GLuint?
    private var textureUniform: Int32 = 0

    var modelMatrix: GLKMatrix4?
    private var modelMatrixUniform: Int32 = 0

    var viewMatrix: GLKMatrix4?
    private var viewMatrixUniform: Int32 = 0

    var projectionMatrix: GLKMatrix4?
    private var projectionMatrixUniform: Int32 = 0

    private var program: GLuint = 0

    init(_ vertexShaderName: String, _ fragmentShaderName: String) {
        self.compile(vertexShaderName, fragmentShaderName)
    }

    func prepareToDraw() {
        glUseProgram(program)

        if let texture = texture {
            // 其实 GL_TEXTURE0 是默认开启的
            glActiveTexture(GLenum(GL_TEXTURE0))
            // 绑定纹理
            glBindTexture(GLenum(GL_TEXTURE_2D), texture)
            // 给片段着色器采样器变量 Sample2D 赋值
            // 其实就是告诉采样器从哪个 TEXTURE 中读取信息
            glUniform1i(textureUniform, 0)
        }

        transfer(matrix: modelMatrix, for: modelMatrixUniform)
        transfer(matrix: viewMatrix, for: viewMatrixUniform)
        transfer(matrix: projectionMatrix, for: projectionMatrixUniform)
    }

    func setTexture(_ resource: String) {
        texture = loadTexture(resource)
    }
}

private extension L6BaseEffect {
    private func transfer(matrix: GLKMatrix4?, for uniform: Int32) {
        if let matrix = matrix {
            let array = (0..<16).map { matrix[$0] }
            glUniformMatrix4fv(
                uniform,
                1,
                GLboolean(GL_FALSE),
                array
            )
        }
    }

    private func loadTexture(_ resource: String) -> GLuint? {
        guard
            let path = Bundle.main.path(forResource: resource, ofType: nil),
            let info = try? GLKTextureLoader.texture(
                withContentsOfFile: path,
                options: [GLKTextureLoaderOriginBottomLeft: true]
            ) else
        {
            print("[Load Texture Error]")
            return nil
        }

        return info.name
    }

    private func compile(_ vertexShaderName: String, _ fragmentShaderName: String) {
        guard
            let vertexShader = compileShader(vertexShaderName, with: GLenum(GL_VERTEX_SHADER)),
            let fragmentShader = compileShader(fragmentShaderName, with: GLenum(GL_FRAGMENT_SHADER))
            else {
                print("[Link Program Error]: Could Not Compile Shader")
                return
        }

        // 创建着色器程序
        program = glCreateProgram()

        // 将着色器对象附加到着色器程序
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)

        // 绑定顶点着色器的顶点属性
        glBindAttribLocation(program, VertexAttrib.position.rawValue, "a_position")
        glBindAttribLocation(program, VertexAttrib.color.rawValue, "a_color")
        glBindAttribLocation(program, VertexAttrib.textureCoordinate.rawValue, "a_texCoord")

        // 链接程序
        glLinkProgram(program)

        // 查询 uniform 信息
        textureUniform = glGetUniformLocation(program, "u_texture")
        modelMatrixUniform = glGetUniformLocation(program, "model_matrix")
        viewMatrixUniform = glGetUniformLocation(program, "view_matrix")
        projectionMatrixUniform = glGetUniformLocation(program, "projection_matrix")

        var success = GLint()

        // 获取链接结果
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &success)

        if success == GL_FALSE {
            // 输出错误信息
            var message: [GLchar] = []
            glGetShaderInfoLog(program, GLsizei(MemoryLayout<GLchar>.size * 512), nil, &message)
            let messageStr = String(cString: message, encoding: .utf8)
            print("[Link Program Error]: \(String(describing: messageStr))")
        }
    }

    private func compileShader(_ shaderName: String, with type: GLenum) -> GLuint? {
        guard
            let shaderPath = Bundle.main.path(forResource: shaderName, ofType: nil),
            let shaderStr = try? String(contentsOfFile: shaderPath, encoding: .utf8)
            else {
                print("[Compile Shader Error]: Could Not Load The Shader")
                return nil
        }

        // 根据传入的 type 创建着色器对象
        // 这里的参数只能是 GL_VERTEX_SHADER 或 GL_FRAGMENT_SHADER，分别代表顶点着色器和片段着色器
        let shader = glCreateShader(type)

        // 将传入的 GLSL 代码转换为 glShaderSource 能识别的参数
        let cShaderStr = shaderStr.cString(using: .utf8)
        var cShaderCount = GLint(Int32(cShaderStr!.count))
        var shaderSource = UnsafePointer<GLchar>(cShaderStr)

        // 关联着色器对象和着色器代码
        // 实际上就是关于 GLSL 代码的字符串到 shader 上
        glShaderSource(
            shader, // 需要关联的 shader
            1, // GLSL 代码字符串个数，一般就是 1 个
            &shaderSource, // GLSL 代码字符串
            &cShaderCount // GLSL 代码字符串长度
        )

        // 编译 shader
        glCompileShader(shader)

        var success = GLint()

        // 获取编译结果
        glGetShaderiv(shader, GLenum(GL_COMPILE_STATUS), &success)

        guard success != GL_FALSE else {
            // 输出错误信息
            var message: [GLchar] = []
            glGetShaderInfoLog(shader, GLsizei(MemoryLayout<GLchar>.size * 512), nil, &message)
            let messageStr = String(cString: message, encoding: .utf8)
            print("[Compile Shader Error]: \(String(describing: messageStr))")
            return nil
        }

        return shader
    }
}

