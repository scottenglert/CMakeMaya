set(MAYA_INCLUDE_DIR "${MAYA_DEVKIT_ROOT}/include")
set(MAYA_LIB_DIR "${MAYA_DEVKIT_ROOT}/lib")
set(LIBRARY_NAMES 
        Foundation
        OpenMaya
        OpenMayaRender
        OpenMayaUI
        OpenMayaAnim
        OpenMayaFX
        clew
    )

if (${MAYA_VERSION} VERSION_GREATER_EQUAL "2026")
    set(TBB_NAMES
        tbb12.lib
        libtbb.12.dynlib
        libtbb.so.12    
        )
else()
    set(TBB_NAMES tbb)
endif()
find_library(TBB_PATH NAMES ${TBB_NAMES} PATHS ${MAYA_LIB_DIR} NO_DEFAULT_PATH REQUIRED)

add_library(Maya::tbb SHARED IMPORTED)
set_target_properties(Maya::tbb PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${MAYA_INCLUDE_DIR}
    IMPORTED_IMPLIB ${TBB_PATH}
)      
if(NOT WIN32)
    get_filename_component(LIBRARY_FILE ${TBB_PATH} NAME)
    set_target_properties(Maya::tbb PROPERTIES
        IMPORTED_SONAME ${LIBRARY_FILE}
        IMPORTED_LOCATION ${TBB_PATH}
    )
endif()

foreach(LIBRARY ${LIBRARY_NAMES})
    find_library(${LIBRARY}_PATH ${LIBRARY} PATHS ${MAYA_LIB_DIR} NO_DEFAULT_PATH REQUIRED)

    add_library(Maya::${LIBRARY} SHARED IMPORTED)
    set_target_properties(Maya::${LIBRARY} PROPERTIES
        INTERFACE_INCLUDE_DIRECTORIES ${MAYA_INCLUDE_DIR}
        IMPORTED_IMPLIB ${${LIBRARY}_PATH}
        )
            
    if(NOT WIN32)
        get_filename_component(LIBRARY_FILE ${${LIBRARY}_PATH} NAME)
        set_target_properties(Maya::${LIBRARY} PROPERTIES
            IMPORTED_SONAME ${LIBRARY_FILE}
            IMPORTED_LOCATION ${${LIBRARY}_PATH}
        )
    endif()
endforeach()

set(MAYA_FOUND TRUE)