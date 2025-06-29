cmake_minimum_required(VERSION 3.16)
project(Kurva)
option(BUILD_PLUGIN "Build the plugin" OFF)
option(INSTALL_PLASMOID "Install plasmoid" OFF)
option(PACKAGE_PLASMOID "Package plasmoid" OFF)
set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "6.0.0")
set(KDE_COMPILERSETTINGS_LEVEL "5.82")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS 1)
set(CMAKE_CXX_FLAGS "-fdiagnostics-color=always -g -ggdb -pedantic-errors -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion")
# Use Extra CMake Modules (ECM) for common functionality.
# See http://api.kde.org/ecm/manual/ecm.7.html
# and http://api.kde.org/ecm/manual/ecm-kde-modules.7.html
find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)

# Needed by find_package() below.
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

# Get id and version from metadata
file(READ ${CMAKE_CURRENT_SOURCE_DIR}/package/metadata.json METADATA)
string(JSON PLUGIN_ID GET ${METADATA} KPlugin Id)
string(JSON CUR_VERSION GET ${METADATA} KPlugin Version)
message("Plugin Id: ${PLUGIN_ID}")
message("Version: ${CUR_VERSION}")

if(INSTALL_PLASMOID)
    # Locate plasma_install_package macro.
    find_package(Plasma REQUIRED)
    plasma_install_package(package ${PLUGIN_ID})
endif()

if(PACKAGE_PLASMOID)
    # generate plasmoid file
    set(PLASMOID_FILE ${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}-v${CUR_VERSION}.plasmoid)
    add_custom_target(plasmoid ALL
        COMMAND rm -rf "${PLASMOID_FILE}"
        COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_SOURCE_DIR}/package zip -r ${PLASMOID_FILE} ./
        COMMENT "Generating ${PLASMOID_FILE}"
    )
endif()

if(BUILD_PLUGIN)
    add_subdirectory(plugin)
endif()
