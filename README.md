# CMakeMaya
This is a CMake module to easily include in your Maya plugin projects to build for Windows, Mac, and Linux.

## How to use

### Including to your project
From within your plugin's CMakeLists.txt, include the `plugin.cmake` file from this project:

```cmake
include(path/to/plugin.cmake)
```

Next, all you need to do is call the `add_plugin` function with the name of the target and the
list of source files to build:

```cmake
set(SOURCE_FILES
    "pluginMain.cpp"
    "nodeA.cpp"
    "nodeB.cpp"
    "utils.cpp")

add_plugin(myPluginName ${SOURCE_FILES})
```

The `add_plugin` function will create the plugin target and add all the Maya libraries and includes. You can
add additional libraries and dependencies to the target if needed.

### Setting variables
There are two variables that are needed to be set. The `MAYA_VERSION` and `MAYA_DEVKIT_ROOT`.

Set the `MAYA_VERSION` to the major version of Maya you are building for. Ex: `2026`.

Set the `MAYA_DEVKIT_ROOT` to the full path to the root of the devkit. Which has the `lib` and `include` directories under it.

## Building
You can pass the above variables in while calling cmake to build your project:

`cmake -B ./build -DMAYA_VERSION=2026 -DMAYA_DEVKIT_ROOT="/path/to/devkit/"`

Or set them _before_ including the `plugin.cmake` file.