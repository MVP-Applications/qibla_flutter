package com.example.qibla_ar_finder

import android.opengl.GLES20
import android.util.Log
import java.nio.ByteBuffer
import java.nio.ByteOrder
import java.nio.FloatBuffer

/**
 * Renders the Kaaba as a 3D object in AR space
 * Uses OpenGL ES 2.0 for rendering
 */
class KaabaRenderer {
    
    private var program = 0
    private var positionHandle = 0
    private var colorHandle = 0
    private var mvpMatrixHandle = 0
    
    private lateinit var vertexBuffer: FloatBuffer
    private lateinit var colorBuffer: FloatBuffer
    private lateinit var indexBuffer: java.nio.ShortBuffer
    
    private var vertexCount = 0
    
    companion object {
        private const val TAG = "KaabaRenderer"
        private const val COORDS_PER_VERTEX = 3
        private const val VERTEX_STRIDE = COORDS_PER_VERTEX * 4 // 4 bytes per float
        
        // Vertex shader
        private const val VERTEX_SHADER = """
            uniform mat4 uMVPMatrix;
            attribute vec4 vPosition;
            attribute vec4 vColor;
            varying vec4 fragColor;
            
            void main() {
                gl_Position = uMVPMatrix * vPosition;
                fragColor = vColor;
            }
        """
        
        // Fragment shader
        private const val FRAGMENT_SHADER = """
            precision mediump float;
            varying vec4 fragColor;
            
            void main() {
                gl_FragColor = fragColor;
            }
        """
    }
    
    /**
     * Create OpenGL program
     */
    fun createProgram() {
        val vertexShader = loadShader(GLES20.GL_VERTEX_SHADER, VERTEX_SHADER)
        val fragmentShader = loadShader(GLES20.GL_FRAGMENT_SHADER, FRAGMENT_SHADER)
        
        program = GLES20.glCreateProgram().also {
            GLES20.glAttachShader(it, vertexShader)
            GLES20.glAttachShader(it, fragmentShader)
            GLES20.glLinkProgram(it)
            
            // Check linking
            val linkStatus = IntArray(1)
            GLES20.glGetProgramiv(it, GLES20.GL_LINK_STATUS, linkStatus, 0)
            if (linkStatus[0] == 0) {
                Log.e(TAG, "Could not link program: ${GLES20.glGetProgramInfoLog(it)}")
                GLES20.glDeleteProgram(it)
            }
        }
        
        positionHandle = GLES20.glGetAttribLocation(program, "vPosition")
        colorHandle = GLES20.glGetAttribLocation(program, "vColor")
        mvpMatrixHandle = GLES20.glGetUniformLocation(program, "uMVPMatrix")
        
        setupKaabaGeometry()
    }
    
    /**
     * Load and compile shader
     */
    private fun loadShader(type: Int, shaderCode: String): Int {
        return GLES20.glCreateShader(type).also { shader ->
            GLES20.glShaderSource(shader, shaderCode)
            GLES20.glCompileShader(shader)
            
            // Check compilation
            val compiled = IntArray(1)
            GLES20.glGetShaderiv(shader, GLES20.GL_COMPILE_STATUS, compiled, 0)
            if (compiled[0] == 0) {
                Log.e(TAG, "Could not compile shader $type: ${GLES20.glGetShaderInfoLog(shader)}")
                GLES20.glDeleteShader(shader)
            }
        }
    }
    
    /**
     * Setup Kaaba geometry (simple cube)
     * Dimensions: 0.3m x 0.4m x 0.3m (width x height x depth)
     */
    private fun setupKaabaGeometry() {
        val w = 0.15f  // half width
        val h = 0.2f   // half height
        val d = 0.15f  // half depth
        
        // Kaaba vertices (8 corners of a cube)
        val vertices = floatArrayOf(
            // Front face
            -w, -h, d,   // 0
            w, -h, d,    // 1
            w, h, d,     // 2
            -w, h, d,    // 3
            
            // Back face
            -w, -h, -d,  // 4
            w, -h, -d,   // 5
            w, h, -d,    // 6
            -w, h, -d    // 7
        )
        
        // Kaaba colors (black with slight variation)
        val colors = floatArrayOf(
            // Front face - dark gray
            0.1f, 0.1f, 0.1f, 1f,
            0.1f, 0.1f, 0.1f, 1f,
            0.15f, 0.15f, 0.15f, 1f,
            0.15f, 0.15f, 0.15f, 1f,
            
            // Back face - darker
            0.05f, 0.05f, 0.05f, 1f,
            0.05f, 0.05f, 0.05f, 1f,
            0.1f, 0.1f, 0.1f, 1f,
            0.1f, 0.1f, 0.1f, 1f
        )
        
        // Indices for cube faces
        val indices = shortArrayOf(
            // Front
            0, 1, 2,
            0, 2, 3,
            // Back
            5, 4, 7,
            5, 7, 6,
            // Left
            4, 0, 3,
            4, 3, 7,
            // Right
            1, 5, 6,
            1, 6, 2,
            // Top
            3, 2, 6,
            3, 6, 7,
            // Bottom
            4, 5, 1,
            4, 1, 0
        )
        
        vertexCount = indices.size
        
        // Create vertex buffer
        vertexBuffer = ByteBuffer.allocateDirect(vertices.size * 4).run {
            order(ByteOrder.nativeOrder())
            asFloatBuffer().apply {
                put(vertices)
                position(0)
            }
        }
        
        // Create color buffer
        colorBuffer = ByteBuffer.allocateDirect(colors.size * 4).run {
            order(ByteOrder.nativeOrder())
            asFloatBuffer().apply {
                put(colors)
                position(0)
            }
        }
        
        // Create index buffer
        indexBuffer = ByteBuffer.allocateDirect(indices.size * 2).run {
            order(ByteOrder.nativeOrder())
            asShortBuffer().apply {
                put(indices)
                position(0)
            }
        }
    }
    
    /**
     * Render the Kaaba
     */
    fun render(mvpMatrix: FloatArray) {
        GLES20.glUseProgram(program)
        
        // Set MVP matrix
        GLES20.glUniformMatrix4fv(mvpMatrixHandle, 1, false, mvpMatrix, 0)
        
        // Enable vertex attributes
        GLES20.glEnableVertexAttribArray(positionHandle)
        GLES20.glEnableVertexAttribArray(colorHandle)
        
        // Set vertex position
        vertexBuffer.position(0)
        GLES20.glVertexAttribPointer(
            positionHandle,
            COORDS_PER_VERTEX,
            GLES20.GL_FLOAT,
            false,
            VERTEX_STRIDE,
            vertexBuffer
        )
        
        // Set vertex color
        colorBuffer.position(0)
        GLES20.glVertexAttribPointer(
            colorHandle,
            4,
            GLES20.GL_FLOAT,
            false,
            16,
            colorBuffer
        )
        
        // Draw
        indexBuffer.position(0)
        GLES20.glDrawElements(
            GLES20.GL_TRIANGLES,
            vertexCount,
            GLES20.GL_UNSIGNED_SHORT,
            indexBuffer
        )
        
        // Disable vertex attributes
        GLES20.glDisableVertexAttribArray(positionHandle)
        GLES20.glDisableVertexAttribArray(colorHandle)
    }
}
