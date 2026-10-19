# Maintainer-only: regenerate the checked-in XMLs after updating their inputs or generators.
# Normal builds consume data/syntax directly and must not include this script.
cmake_minimum_required(VERSION 3.21)
find_package(Perl REQUIRED)

set(syntax_dir "${CMAKE_CURRENT_LIST_DIR}/../syntax")

function(generate_syntax_definition generator targetFile srcFile)
    execute_process(
        COMMAND "${PERL_EXECUTABLE}" "./${generator}"
                "${syntax_dir}/${srcFile}" "${syntax_dir}/${targetFile}"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        COMMAND_ERROR_IS_FATAL ANY
    )
    # Perl's text output uses CRLF on Windows; keep checked-in results platform-independent.
    execute_process(
        COMMAND "${PERL_EXECUTABLE}" -pi -e "binmode ARGVOUT; s/\\r\\n/\\n/g;"
                "${syntax_dir}/${targetFile}"
        COMMAND_ERROR_IS_FATAL ANY
    )
endfunction()

foreach(syntax html css javascript javascript-react typescript mustache)
    generate_syntax_definition(generate-html.pl "${syntax}-php.xml" "${syntax}.xml")
endforeach()
foreach(syntax html css javascript javascript-react typescript)
    generate_syntax_definition(generate-html.pl "${syntax}-twig.xml" "${syntax}.xml")
endforeach()
generate_syntax_definition(generate-doxygenlua.pl doxygenlua.xml doxygen.xml)
generate_syntax_definition(generate-xslt.pl xslt.xml xml.xml)
generate_syntax_definition(generate-jsonc.pl jsonc.xml json.xml)
