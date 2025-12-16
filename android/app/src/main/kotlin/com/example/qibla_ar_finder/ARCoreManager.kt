chat        package com.example.qibla_ar_finder

import android.content.Context
import android.opengl.GLES20
import android.opengl.GLSurfaceView
import android.opengl.Matrix
import android.util.Log
import com.google.ar.core.*
import com.google.ar.core.exceptions.*
import javax.microedition.khronos.egl.EGLConfig
import javax.microedition.khronos.opengles.GL10
import kotlin.math.*

/**
 * ARCore Manager handles all AR session management and rendering
 * Manages world-anchored Kaaba placement at Qibla direction
 */
class ARCoreManager(private val context: Context) : GLSurfaceView.Renderer {
    
    private var arSession: Session? = null
    private var displayRotationHelper: DisplayRotationHelper? = null
    
    // Kaaba anchor and rendering
    private var kaabaAnchor: Anchor? = null
    private var kaabaRenderer: KaabaRenderer? = null
    
    // Camera and projection matrices
    private val projectionMatrix = FloatArray(16)
    private val viewMatrix = FloatArray(16)
    private val modelMatrix = FloatArray(16)
    private val mvpMatrix = FloatArray(16)
    
    // Qibla direction (bearing in degrees)
    private var qiblaBearing = 0f
    
    // Callbacks
    var onSessionCreated: (() -> Unit)? = null
    var onPlaneDetected: (() -> Unit)? = null
    var onKaabaPlaced: (() -> Unit)? = null
    var onError: ((String) -> Unit)? = null
    
    companion object {
        private const val TAG = "ARCoreManager"
        private const val KAABA_DISTANCE = 5f // 5 meters in front of user
    }
    
    /**
     * Initialize ARCore session
     */
    fun initializeARSession() {
        try {
            if (arSession == null) {
                arSession = Session(context)
                
                // Configure session
                val config = Config(arSession!!)
                config.focusMode = Config.FocusMode.AUTO
                config.planeFindingMode = Config.PlaneFindingMode.HORIZONTAL
                config.updateMode = Config.UpdateMode.LATEST_CAMERA_IMAGE
                
                arSession!!.configure(config)
                
                displayRotationHelper = DisplayRotationHelper(context)
                kaabaRenderer = KaabaRenderer()
                
                onSessionCreated?.invoke()
                Log.d(TAG, "ARCore session initialized successfully")
            }
        } catch (e: UnavailableException) {
            Log.e(TAG, "ARCore unavailable: ${e.message}")
            onError?.invoke("ARCore is not available on this device")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to initialize ARCore: ${e.message}")
            onError?.invoke("Failed to initialize AR: ${e.message}")
        }
    }
    
    /**
     * Set Qibla bearing and place Kaaba anchor
     */
    fun setQiblaBearingAndPlaceKaaba(bearing: Float) {
        qiblaBearing = bearing
        Log.d(TAG, "Qibla bearing set to: $bearing°")
    }
    
    /**
     * Place Kaaba at Qibla direction in world space
     * This creates a world anchor that stays fixed regardless of phone movement
     */
    private fun placeKaabaAnchor(frame: Frame) {
        if (kaabaAnchor != null) {
            return // Already placed
        }
        
        try {
            // Get camera pose
            val cameraPose = frame.camera.displayOrientedPose
            
            // Calculate Kaaba position relative to camera
            // Convert bearing to radians
            val bearingRad = Math.toRadians(qiblaBearing.toDouble())
            
            // Position: KAABA_DISTANCE meters in front, at Qibla direction
            // X: East-West (positive = East)
            // Y: Up-Down (0 = ground level)
            // Z: North-South (negative = North, positive = South)
            val x = (KAABA_DISTANCE * sin(bearingRad)).toFloat()
            val y = -0.5f // Slightly below eye level
            val z = -(KAABA_DISTANCE * cos(bearingRad)).toFloat()
            
            // Create anchor at calculated position
            val anchorPose = cameraPose.compose(Pose(floatArrayOf(x, y, z), floatArrayOf(0f, 0f, 0f, 1f)))
            kaabaAnchor = arSession!!.createAnchor(anchorPose)
            
            Log.d(TAG, "Kaaba anchor placed at: x=$x, y=$y, z=$z")
            onKaabaPlaced?.invoke()
            
        } catch (e: DeadlineExceededException) {
            Log.e(TAG, "Deadline exceeded while placing anchor: ${e.message}")
        } catch (e: NotTrackingException) {
            Log.e(TAG, "Not tracking - cannot place anchor yet: ${e.message}")
        } catch (e: Exception) {
            Log.e(TAG, "Failed to place Kaaba anchor: ${e.message}")
            onError?.invoke("Failed to place Kaaba: ${e.message}")
        }
    }
    
    /**
     * Update display rotation (call when device orientation changes)
     */
    fun updateDisplayRotation(rotation: Int) {
        displayRotationHelper?.onDisplayRotationChanged(rotation)
    }
    
    /**
     * GLSurfaceView.Renderer implementation
     */
    override fun onSurfaceCreated(gl: GL10?, config: EGLConfig?) {
        GLES20.glClearColor(0f, 0f, 0f, 1f)
        GLES20.glEnable(GLES20.GL_DEPTH_TEST)
        GLES20.glEnable(GLES20.GL_CULL_FACE)
        
        kaabaRenderer?.createProgram()
    }
    
    override fun onSurfaceChanged(gl: GL10?, width: Int, height: Int) {
        GLES20.glViewport(0, 0, width, height)
        displayRotationHelper?.onSurfaceChanged(width, height)
    }
    
    override fun onDrawFrame(gl: GL10?) {
        try {
            val session = arSession ?: return
            
            // Update display rotation
            displayRotationHelper?.updateSessionIfNeeded(session)
            
            // Get current frame
            val frame = session.update()
            val camera = frame.camera
            
            // Check camera tracking state
            if (camera.trackingState != TrackingState.TRACKING) {
                return
            }
            
            // Get camera matrices
            camera.getProjectionMatrix(projectionMatrix, 0, 0.1f, 100f)
            camera.getViewMatrix(viewMatrix, 0)
            
            // Detect planes and place Kaaba if not already placed
            if (kaabaAnchor == null) {
                for (plane in frame.getUpdatedTrackables(Plane::class.java)) {
                    if (plane.trackingState == TrackingState.TRACKING) {
                        onPlaneDetected?.invoke()
                        placeKaabaAnchor(frame)
                        break
                    }
                }
            }
            
            // Clear screen
            GLES20.glClear(GLES20.GL_COLOR_BUFFER_BIT or GLES20.GL_DEPTH_BUFFER_BIT)
            
            // Render Kaaba if anchor exists
            if (kaabaAnchor != null && kaabaAnchor!!.trackingState == TrackingState.TRACKING) {
                val anchorMatrix = FloatArray(16)
                kaabaAnchor!!.pose.toMatrix(anchorMatrix, 0)
                
                // Calculate MVP matrix
                val tempMatrix = FloatArray(16)
                Matrix.multiplyMM(tempMatrix, 0, viewMatrix, 0, anchorMatrix)
                Matrix.multiplyMM(mvpMatrix, 0, projectionMatrix, 0, tempMatrix)
                
                // Render Kaaba
                kaabaRenderer?.render(mvpMatrix)
            }
            
        } catch (e: CameraNotAvailableException) {
            Log.e(TAG, "Camera not available: ${e.message}")
        } catch (e: Exception) {
            Log.e(TAG, "Error in onDrawFrame: ${e.message}")
        }
    }
    
    /**
     * Pause AR session
     */
    fun pauseSession() {
        try {
            arSession?.pause()
        } catch (e: Exception) {
            Log.e(TAG, "Error pausing session: ${e.message}")
        }
    }
    
    /**
     * Resume AR session
     */
    fun resumeSession() {
        try {
            if (arSession == null) {
                initializeARSession()
            } else {
                arSession?.resume()
            }
        } catch (e: CameraNotAvailableException) {
            Log.e(TAG, "Camera not available: ${e.message}")
            onError?.invoke("Camera not available")
        } catch (e: Exception) {
            Log.e(TAG, "Error resuming session: ${e.message}")
        }
    }
    
    /**
     * Clean up resources
     */
    fun cleanup() {
        try {
            arSession?.close()
            arSession = null
            kaabaAnchor = null
            kaabaRenderer = null
        } catch (e: Exception) {
            Log.e(TAG, "Error during cleanup: ${e.message}")
        }
    }
}
