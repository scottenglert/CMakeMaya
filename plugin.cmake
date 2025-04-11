
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})
find_package(Maya REQUIRED)

if (NOT ${MAYA_FOUND})
    message(FATAL_ERROR "Could not find Maya libraries!")
endif()

if(WIN32)
    set(PLUGIN_DEFINITIONS "NT_PLUGIN CRT_SECURE_NO_DEPRECATE _HAS_ITERATOR_DEBUGGING=0 _CRT_SECURE_NO_WARNINGS")
    set(PLUGIN_EXT ".mll")
    set(PLUGIN_LINK_FLAGS " ")
elseif(APPLE)
    set(PLUGIN_DEFINITIONS "MAC_PLUGIN OSMac_")
    set(PLUGIN_EXT ".bundle")
    set(CMAKE_XCODE_ATTRIBUTE_CLANG_CXX_LIBRARY "libc++")
    set(PLUGIN_LINK_FLAGS " ")
else()
    set(PLUGIN_DEFINITIONS "")
    set(PLUGIN_EXT ".so")
    set(PLUGIN_LINK_FLAGS " ")
endif()

set(CMAKE_CXX_VISIBILITY_PRESET hidden)
set(CMAKE_VISIBILITY_INLINES_HIDDEN ON)


function(add_plugin
            target)

    add_library(${target} SHARED ${ARGN})
    
    target_compile_features(${target} PRIVATE cxx_std_17)

    if(MSVC)
        target_compile_options(${target} PRIVATE /wd4996)
    elseif(APPLE)
        set_target_properties(${PROJECT_NAME} PROPERTIES
            OSX_ARCHITECTURES "x86_64;arm64")
    endif()

    set_target_properties(${target} PROPERTIES
        LINK_FLAGS ${PLUGIN_LINK_FLAGS}
        PREFIX ""
        SUFFIX ${PLUGIN_EXT}
        )

    target_compile_definitions(${target} PRIVATE ${PLUGIN_DEFINITIONS})

    target_link_libraries(${target} PRIVATE
                            Maya::Foundation
                            Maya::OpenMaya
                            Maya::OpenMayaRender
                            Maya::OpenMayaUI
                            Maya::OpenMayaAnim
                            Maya::OpenMayaFX
                            Maya::tbb
                            Maya::clew
                        )
endfunction()
