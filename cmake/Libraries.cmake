# Set CMAKE_PREFIX_PATH with toolchain directory

# see https://public.kitware.com/Bug/view.php?id=15409
IF(MINGW)
	SET(CMAKE_FIND_LIBRARY_SUFFIXES ".dll.a" ".a" ".lib")
ENDIF()

SET(MIN_QT_VERSION 5.10)
FIND_PACKAGE(Qt5Core ${MIN_QT_VERSION} REQUIRED)
FIND_PACKAGE(Qt5Concurrent ${MIN_QT_VERSION} REQUIRED)
FIND_PACKAGE(Qt5Network ${MIN_QT_VERSION} REQUIRED)
FIND_PACKAGE(Qt5Svg ${MIN_QT_VERSION} REQUIRED)
FIND_PACKAGE(Qt5LinguistTools ${MIN_QT_VERSION} REQUIRED)
FIND_PACKAGE(Qt5WebSockets ${MIN_QT_VERSION} REQUIRED)

IF(NOT DESKTOP AND NOT ANDROID_BUILD_AAR OR "${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
	FIND_PACKAGE(Qt5Qml ${MIN_QT_VERSION} REQUIRED)
	FIND_PACKAGE(Qt5Quick ${MIN_QT_VERSION} REQUIRED)
	FIND_PACKAGE(Qt5QuickControls2 ${MIN_QT_VERSION} REQUIRED)
ENDIF()

IF(DESKTOP)
	FIND_PACKAGE(Qt5Widgets ${MIN_QT_VERSION} REQUIRED)

	IF(WIN32)
		FIND_PACKAGE(Qt5WinExtras ${MIN_QT_VERSION} REQUIRED)
	ENDIF()
ENDIF()

IF(ANDROID OR IOS OR WINDOWS_STORE OR "${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
	FIND_PACKAGE(Qt5Bluetooth ${MIN_QT_VERSION} REQUIRED)
	FIND_PACKAGE(Qt5Nfc ${MIN_QT_VERSION} REQUIRED)
ENDIF()

IF(ANDROID)
	FIND_PACKAGE(Qt5AndroidExtras ${MIN_QT_VERSION} REQUIRED)
ENDIF()

SET(QT_HOST_PREFIX ${_qt5Core_install_prefix})
FOREACH(dest "" "share/qt" "share/qt5")
	IF(EXISTS "${QT_HOST_PREFIX}/${dest}/translations")
		SET(QT_TRANSLATIONS_DIR ${QT_HOST_PREFIX}/${dest}/translations)
	ENDIF()
ENDFOREACH()

IF(NOT QT_TRANSLATIONS_DIR)
	QUERY_QMAKE(QT_TRANSLATIONS_DIR QT_INSTALL_TRANSLATIONS)
ENDIF()

MESSAGE(STATUS "QT_HOST_PREFIX: ${QT_HOST_PREFIX}")
MESSAGE(STATUS "QT_TRANSLATIONS_DIR: ${QT_TRANSLATIONS_DIR}")

SET(QT_VENDOR_FILE "${QT_HOST_PREFIX}/mkspecs/qt_vendor_governikus")
IF(EXISTS "${QT_VENDOR_FILE}")
	SET(QT_VENDOR "Governikus")
	MESSAGE(STATUS "QT_VENDOR: ${QT_VENDOR}")
ENDIF()

IF(NOT DEFINED QT_TRANSLATIONS_DIR)
	MESSAGE(FATAL_ERROR "Cannot detect QT_TRANSLATIONS_DIR")
ENDIF()


IF(MINGW AND NOT CMAKE_CROSSCOMPILING)
	SET(tmp_crosscompile_enabled TRUE)
	SET(CMAKE_CROSSCOMPILING ON)
ENDIF()
IF(QT_VENDOR STREQUAL "Governikus" OR FORCE_LEGACY_OPENSSL)
	FIND_PACKAGE(OpenSSL 1.0.2 REQUIRED) # see openssl_rsa_psk.patch
ELSE()
	FIND_PACKAGE(OpenSSL 1.1 REQUIRED)
ENDIF()
IF(tmp_crosscompile_enabled)
	SET(CMAKE_CROSSCOMPILING OFF)
ENDIF()


IF(MINGW)
	SET(PCSC_LIBRARIES -lwinscard)
	SET(WIN_DEFAULT_LIBS "-lAdvapi32" "-lKernel32" "-lOle32" "-lSetupapi" "-lVersion" "-lws2_32")
ELSEIF(MSVC)
	SET(PCSC_LIBRARIES winscard.lib)
	SET(WIN_DEFAULT_LIBS setupapi.lib version.lib Ws2_32.lib)
ELSEIF(ANDROID)

ELSEIF(IOS)
	FIND_LIBRARY(IOS_ASSETSLIBRARY AssetsLibrary)
	FIND_LIBRARY(IOS_UIKIT UIKit)
	FIND_LIBRARY(IOS_MOBILECORESERVICES MobileCoreServices)
	FIND_LIBRARY(IOS_COREBLUETOOTH CoreBluetooth)
	FIND_LIBRARY(IOS_COREFOUNDATION CoreFoundation)
	FIND_LIBRARY(IOS_OPENGLES OpenGLES)
	FIND_LIBRARY(IOS_FOUNDATION Foundation)
	FIND_LIBRARY(IOS_QUARTZCORE QuartzCore)
	FIND_LIBRARY(IOS_CORETEXT CoreText)
	FIND_LIBRARY(IOS_COREGRAPHICS CoreGraphics)
	FIND_LIBRARY(IOS_SECURITY Security)
	FIND_LIBRARY(IOS_SYSTEMCONFIGURATION SystemConfiguration)
	FIND_LIBRARY(IOS_AUDIOTOOLBOX AudioToolbox)
	FIND_LIBRARY(IOS_IMAGEIO ImageIO)
ELSEIF(MAC)
	FIND_PATH(PCSC_INCLUDE_DIRS WinSCard.h)
	FIND_LIBRARY(PCSC_LIBRARIES NAMES PCSC WinSCard)

	FIND_LIBRARY(OSX_APPKIT AppKit)
	FIND_LIBRARY(IOKIT NAMES IOKit)
	FIND_LIBRARY(OSX_SECURITY Security)
	FIND_LIBRARY(OSX_FOUNDATION Foundation)
	FIND_LIBRARY(OSX_SERVICEMANAGEMENT ServiceManagement)
ELSEIF(UNIX)
	IF(LINUX)
		FIND_LIBRARY(LIBUDEV NAMES udev ludev libudev)
	ENDIF()

	FIND_PACKAGE(PkgConfig REQUIRED)
	pkg_check_modules(PCSC REQUIRED libpcsclite)
	LINK_DIRECTORIES("${PCSC_LIBRARY_DIRS}")
ENDIF()


IF("${CMAKE_BUILD_TYPE}" STREQUAL "DEBUG")
	FIND_PACKAGE(Qt5Test ${MIN_QT_VERSION} REQUIRED)
	FIND_PACKAGE(Qt5QuickTest ${MIN_QT_VERSION} REQUIRED)
ENDIF()
