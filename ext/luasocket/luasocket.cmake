# SPDX-License-Identifier: GPL-3.0-only

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_FLAGS "-Wall -Wextra")

include(${CMAKE_SOURCE_DIR}/balltze-cpplib/balltze.cmake)

add_definitions(-DWINVER=0x0501 -DLUASOCKET_DEBUG)

include_directories(${CMAKE_SOURCE_DIR}/balltze-cpplib/include/lua)

set(LUASOCKET_SRC ${CMAKE_SOURCE_DIR}/ext/luasocket/src)

add_library(socket MODULE
    ${LUASOCKET_SRC}/luasocket.c
    ${LUASOCKET_SRC}/timeout.c
    ${LUASOCKET_SRC}/buffer.c
    ${LUASOCKET_SRC}/io.c
    ${LUASOCKET_SRC}/auxiliar.c
    ${LUASOCKET_SRC}/options.c
    ${LUASOCKET_SRC}/inet.c
    ${LUASOCKET_SRC}/except.c
    ${LUASOCKET_SRC}/select.c
    ${LUASOCKET_SRC}/tcp.c
    ${LUASOCKET_SRC}/udp.c
    ${LUASOCKET_SRC}/compat.c
    ${LUASOCKET_SRC}/wsocket.c
)

add_library(mime MODULE
    ${LUASOCKET_SRC}/mime.c
    ${LUASOCKET_SRC}/compat.c
)

target_link_libraries(socket ws2_32 balltze)
target_link_libraries(mime balltze)

# Create output folders
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/lua_modules/mime")
file(MAKE_DIRECTORY "${CMAKE_SOURCE_DIR}/lua_modules/socket")

# Copy the built libraries to the output folders
install(FILES $<TARGET_FILE:socket> DESTINATION "${CMAKE_SOURCE_DIR}/lua_modules/socket" RENAME core.dll)
install(FILES $<TARGET_FILE:mime> DESTINATION "${CMAKE_SOURCE_DIR}/lua_modules/mime" RENAME core.dll)
