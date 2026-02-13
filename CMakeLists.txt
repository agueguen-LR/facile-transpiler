# file: CMakeLists.txt
# version: 0.2.0

cmake_minimum_required(VERSION 3.10)

project(facile VERSION 0.2.0 LANGUAGES C)

find_package(FLEX)



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
)

add_executable(
	facile
	${FLEX_FACILE_SCANNER_OUTPUTS}
	${BISON_FACILE_PARSER_OUTPUTS}
)
target_link_libraries(facile fl)

set(CPACK_SOURCE_GENERATOR "ZIP")
set(CPACK_SOURCE_IGNORE_FILES "build;~$;${CPACK_SOURCE_IGNORE_FILES}")
set(CPACK_PACKAGE_VERSION_MAJOR ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${PROJECT_VERSION_PATCH})
include(CPack)
