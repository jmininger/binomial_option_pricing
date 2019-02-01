cmake_minimum_required(VERSION 2.8.2)

project(OptionPricing)

set (CMAKE_CXX_STANDARD 11)

add_definitions(-x c++)

include_directories(include) 

# Add json compilation database
SET(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(src)


# Download and unpack googletest at configure time
configure_file(CMakeLists.txt.in googletest-download/CMakeLists.txt)
execute_process(COMMAND ${CMAKE_COMMAND} -G "${CMAKE_GENERATOR}" .
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download )
if(result)
  message(FATAL_ERROR "CMake step for googletest failed: ${result}")
endif()
execute_process(COMMAND ${CMAKE_COMMAND} --build .
  RESULT_VARIABLE result
  WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/googletest-download )
if(result)
  message(FATAL_ERROR "Build step for googletest failed: ${result}")
endif()

# Add googletest directly to our build. This defines
# the gtest and gtest_main targets.
add_subdirectory(${CMAKE_BINARY_DIR}/googletest-src
                   ${CMAKE_BINARY_DIR}/googletest-build
                    EXCLUDE_FROM_ALL)


# The gtest/gtest_main targets carry header search path
# dependencies automatically when using CMake 2.8.11 or
# later. Otherwise we have to add them here ourselves.
if (CMAKE_VERSION VERSION_LESS 2.8.11)
  include_directories("${gtest_SOURCE_DIR}/include"
    "${gmock_SOURCE_DIR}/include")
endif()

enable_testing()
  # Now simply link against gtest or gtest_main as needed. Eg
add_executable(binomial_model_test tests/binomial_model_test.cpp)
target_link_libraries(binomial_model_test pricing gtest_main)
add_test(NAME binomial_model_test COMMAND binomial)

add_executable(playground src/playground.cpp)
target_link_libraries(playground pricing)

add_executable(benchmark src/benchmarking.cpp)
target_link_libraries(benchmark pricing)
