# @file: CMakeLists.txt
# @author agueguen-LR <agueguen@proton.me>
# @date 2026

cmake_minimum_required(VERSION 3.10)

project(facile LANGUAGES C)

find_package(FLEX)

find_package(PkgConfig REQUIRED)
pkg_check_modules(GLIB2 REQUIRED glib-2.0)
include_directories(${GLIB2_INCLUDE_DIRS})
link_directories(${GLIB2_LIBRARY_DIRS})
add_definitions(${GLIB2_CFLAGS_OTHER})

flex_target(
	FACILE_SCANNER
	"${CMAKE_SOURCE_DIR}/src/facile.lex"
	"${CMAKE_CURRENT_BINARY_DIR}/facile.lex.c"
)

find_package(BISON)
bison_target(
	FACILE_PARSER
	"${CMAKE_SOURCE_DIR}/src/facile.y"
	"${CMAKE_CURRENT_BINARY_DIR}/facile.y.c"
	COMPILE_FLAGS "-Wcounterexamples"
)

add_executable(
	facile
	${FLEX_FACILE_SCANNER_OUTPUTS}
	${BISON_FACILE_PARSER_OUTPUTS}
)
target_link_libraries(facile fl)
target_link_libraries(facile ${GLIB2_LIBRARIES})

set(CPACK_SOURCE_GENERATOR "ZIP")
set(CPACK_SOURCE_IGNORE_FILES "build;~$;${CPACK_SOURCE_IGNORE_FILES}")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
include(CPack)
