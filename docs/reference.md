# API References

Make sure to checkout code comments for additional details.

## glfw

[glfw](https://github.com/glfw/glfw) A multi-platform library for OpenGL, OpenGL ES, Vulkan, window and input.

**Wgl exposes underlying `glfw` APIs to `wgl.Api.glfw`.**

### Initializes the GLFW library

`glfw.init()` maps to `glfw.glfwInit()` in glfw.

### Destroys GLFW library

`glfw.terminate()` maps to `glfw.glfwTerminate()` in glfw.

### Processes All Pending Events in the Event Queue

`glfw.pollEvents()` maps to `glfw.glfwPollEvents()` in glfw.

### Creates Cross-Platform Window Instance

`glfw.createWindow()` maps to `glfw.glfwCreateWindow()` in glfw.

### Sets the Content Area Limits of a Window

`glfw.setWindowSizeLimits()` maps to `glfw.glfwSetWindowSizeLimits()` in glfw.

### Checks the Close Flag of the Specified Window

`glfw.windowShouldClose()` maps to `glfw.glfwWindowShouldClose()` in glfw.

### Destroys the Specified Window and Its Context

`glfw.destroyWindow()` maps to `glfw.glfwDestroyWindow()` in glfw.

### Makes Window Context Current on the Calling Thread

`glfw.makeContextCurrent()` maps to `glfw.glfwMakeContextCurrent()` in glfw.

### Swaps the Front and Back Buffers of the Specified Window

`glfw.swapBuffers()` maps to `glfw.glfwSwapBuffers()` in glfw.

### Sets Swap Interval for the Current OpenGL Context

`glfw.swapInterval()` maps to `glfw.glfwSwapInterval()` in glfw.

### Sets the Error Callback Function

`glfw.errorCallback()` maps to `glfw.glfwSetErrorCallback()` in glfw.

### Gets `NSWindow` of the Specified Window

`glfw.getCocoaWindow()` maps to `glfw.glfwGetCocoaWindow()` in glfw.

### Gets `HWND` of the Specified Window

`glfw.getWin32Window()` maps to `glfw.glfwGetWin32Window()` in glfw.
