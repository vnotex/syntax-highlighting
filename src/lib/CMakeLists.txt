add_library(VSyntaxHighlighting)

set_target_properties(VSyntaxHighlighting PROPERTIES
    VERSION ${PROJECT_VERSION}
    SOVERSION ${PROJECT_VERSION_MAJOR}
    DEFINE_SYMBOL KSYNTAXHIGHLIGHTING_LIBRARY
    AUTOMOC ON
    AUTORCC ON
    POSITION_INDEPENDENT_CODE ON
)
target_compile_features(VSyntaxHighlighting PUBLIC cxx_std_17)
# Upstream uses QChar concatenation provided by QStringBuilder.
target_compile_definitions(VSyntaxHighlighting PRIVATE QT_USE_QSTRINGBUILDER)

get_target_property(library_type VSyntaxHighlighting TYPE)
if(library_type STREQUAL "STATIC_LIBRARY")
    target_compile_definitions(VSyntaxHighlighting PUBLIC KSYNTAXHIGHLIGHTING_STATIC_DEFINE)
endif()
if(QRC_SYNTAX)
    target_compile_definitions(VSyntaxHighlighting PRIVATE HAS_SYNTAX_RESOURCE)
endif()
if(NO_STANDARD_PATHS)
    target_compile_definitions(VSyntaxHighlighting PRIVATE NO_STANDARD_PATHS)
endif()

generate_export_header(VSyntaxHighlighting
    BASE_NAME KSyntaxHighlighting
    EXPORT_FILE_NAME "${CMAKE_CURRENT_BINARY_DIR}/ksyntaxhighlighting_export.h"
    STATIC_DEFINE KSYNTAXHIGHLIGHTING_STATIC_DEFINE
)

file(CONFIGURE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ksyntaxhighlighting_version.h" CONTENT [=[
#ifndef KSYNTAXHIGHLIGHTING_VERSION_H
#define KSYNTAXHIGHLIGHTING_VERSION_H

#define KSYNTAXHIGHLIGHTING_VERSION_STRING "@PROJECT_VERSION@"
#define KSYNTAXHIGHLIGHTING_VERSION_MAJOR @PROJECT_VERSION_MAJOR@
#define KSYNTAXHIGHLIGHTING_VERSION_MINOR @PROJECT_VERSION_MINOR@
#define KSYNTAXHIGHLIGHTING_VERSION_PATCH @PROJECT_VERSION_PATCH@
#define KSYNTAXHIGHLIGHTING_VERSION ((KSYNTAXHIGHLIGHTING_VERSION_MAJOR << 16) | (KSYNTAXHIGHLIGHTING_VERSION_MINOR << 8) | KSYNTAXHIGHLIGHTING_VERSION_PATCH)

#endif
]=] @ONLY)

file(CONFIGURE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ksyntaxhighlighting_logging.h" CONTENT [=[
#pragma once
#include <QLoggingCategory>

namespace KSyntaxHighlighting
{
Q_DECLARE_LOGGING_CATEGORY(Log)
}
]=] @ONLY)
file(CONFIGURE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/ksyntaxhighlighting_logging.cpp" CONTENT [=[
#include "ksyntaxhighlighting_logging.h"

namespace KSyntaxHighlighting
{
Q_LOGGING_CATEGORY(Log, "kf.syntaxhighlighting", QtWarningMsg)
}
]=] @ONLY)

target_sources(VSyntaxHighlighting PRIVATE
    abstracthighlighter.cpp
    context.cpp
    contextswitch.cpp
    definitiondownloader.cpp
    highlightingdata.cpp
    foldingregion.cpp
    format.cpp
    htmlhighlighter.cpp
    ansihighlighter.cpp
    keywordlist.cpp
    rule.cpp
    definition.cpp
    repository.cpp
    state.cpp
    syntaxhighlighter.cpp
    theme.cpp
    wildcardmatcher.cpp
    themedata.cpp
    themepreviewicon.cpp
    worddelimiters.cpp
    "${CMAKE_CURRENT_BINARY_DIR}/ksyntaxhighlighting_logging.cpp"
    $<TARGET_OBJECTS:SyntaxHighlightingData>
)

target_link_libraries(VSyntaxHighlighting
    PUBLIC
        Qt6::Core
        Qt6::Gui
    PRIVATE
        Qt6::Network
)

set(Forwarding_Header_Names
    AbstractHighlighter
    Definition
    DefinitionDownloader
    FoldingRegion
    Format
    Repository
    State
    SyntaxHighlighter
    Theme
    WildcardMatcher
)

file(MAKE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/KSyntaxHighlighting")
foreach(header IN LISTS Forwarding_Header_Names)
    string(TOLOWER "${header}" source_header)
    file(CONFIGURE OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/KSyntaxHighlighting/${header}"
        CONTENT [=[#include "@source_header@.h"
]=] @ONLY)
    target_sources(VSyntaxHighlighting PRIVATE "${source_header}.h")
endforeach()

target_include_directories(VSyntaxHighlighting PUBLIC
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>"
    "$<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/KSyntaxHighlighting>"
)
