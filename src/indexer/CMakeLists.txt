set(KATEHIGHLIGHTINGINDEXER_EXECUTABLE "" CACHE FILEPATH "Host katehighlightingindexer executable for cross-compilation")

if(CMAKE_CROSSCOMPILING)
    if(NOT KATEHIGHLIGHTINGINDEXER_EXECUTABLE)
        message(FATAL_ERROR "Cross-compiling requires KATEHIGHLIGHTINGINDEXER_EXECUTABLE to point to a host katehighlightingindexer built from the same sources.")
    endif()
    add_executable(katehighlightingindexer IMPORTED GLOBAL)
    set_target_properties(katehighlightingindexer PROPERTIES
        IMPORTED_LOCATION "${KATEHIGHLIGHTINGINDEXER_EXECUTABLE}"
    )
else()
    add_executable(katehighlightingindexer katehighlightingindexer.cpp ../lib/worddelimiters.cpp)
    target_compile_features(katehighlightingindexer PRIVATE cxx_std_20)
    set_target_properties(katehighlightingindexer PROPERTIES WIN32_EXECUTABLE OFF MACOSX_BUNDLE OFF)
    target_link_libraries(katehighlightingindexer PRIVATE Qt6::Core)

    find_package(XercesC QUIET)
    if(XercesC_FOUND)
        target_compile_definitions(katehighlightingindexer PRIVATE HAS_XERCESC)
        target_compile_options(katehighlightingindexer PRIVATE
            $<$<CXX_COMPILER_ID:MSVC>:/EHsc>
            $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-fexceptions>
        )
        target_link_libraries(katehighlightingindexer PRIVATE XercesC::XercesC)
    endif()
endif()
