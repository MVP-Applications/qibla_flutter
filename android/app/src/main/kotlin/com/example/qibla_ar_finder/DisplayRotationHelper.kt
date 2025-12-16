package com.example.qibla_ar_finder

import android.content.Context
import android.hardware.display.DisplayManager
import android.view.Display
import android.view.Surface
import com.google.ar.core.Session
import kotlin.math.abs

/**
 * Helper class to manage display rotation for ARCore
 * Ensures proper camera orientation handling
 */
class DisplayRotationHelper(context: Context) : DisplayManager.DisplayListener {
    
    private val displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
    private var display: Display? = null
    private var viewportWidth = 0
    private var viewportHeight = 0
    private var isPortraitMode = true
    
    init {
        displayManager.registerDisplayListener(this, null)
    }
    
    /**
     * Called when surface changes
     */
    fun onSurfaceChanged(width: Int, height: Int) {
        viewportWidth = width
        viewportHeight = height
        isPortraitMode = width < height
    }
    
    /**
     * Called when display rotation changes
     */
    fun onDisplayRotationChanged(rotation: Int) {
        // Update display reference
    }
    
    /**
     * Update session if display rotation changed
     */
    fun updateSessionIfNeeded(session: Session) {
        val displayRotation = display?.rotation ?: Surface.ROTATION_0
        
        if (displayRotation != session.displayRotation) {
            session.setDisplayGeometry(displayRotation, viewportWidth, viewportHeight)
        }
    }
    
    override fun onDisplayAdded(displayId: Int) {}
    
    override fun onDisplayRemoved(displayId: Int) {}
    
    override fun onDisplayChanged(displayId: Int) {
        // Handle display changes
    }
    
    /**
     * Cleanup
     */
    fun cleanup() {
        displayManager.unregisterDisplayListener(this)
    }
}
