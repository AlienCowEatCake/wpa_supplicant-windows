cmake_minimum_required(VERSION 3.15)

project(wpa-supplicant VERSION 2.10 LANGUAGES C CXX)

option(WPAS_STATIC_RUNTIME "Use static MSVC runtime library" OFF)
set(WPAS_CTRL_IFACE "pipe" CACHE STRING "Control interface: pipe udp")
set_property(CACHE WPAS_CTRL_IFACE PROPERTY STRINGS pipe udp)

set(BASE_DIR "${CMAKE_CURRENT_LIST_DIR}/wpa_supplicant-2.10")
set(OPENSSL_DIR "${CMAKE_CURRENT_LIST_DIR}/openssl-1.1.1-x86")
set(WPDPACK_DIR "${CMAKE_CURRENT_LIST_DIR}/WpdPack")
link_directories(
    AFTER
    "${OPENSSL_DIR}/lib"
    "${WPDPACK_DIR}/Lib"
    )
include_directories(
    AFTER
    "${OPENSSL_DIR}/include"
    "${WPDPACK_DIR}/Include"
    )

include_directories(
    "${BASE_DIR}/wpa_supplicant"
    "${BASE_DIR}/src"
    "${BASE_DIR}/src/utils"
    )

set(GIT_REVISION_)
find_package(Git)
if(Git_FOUND)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" rev-parse --short HEAD
        WORKING_DIRECTORY ${CMAKE_CURRENT_LIST_DIR}
        OUTPUT_VARIABLE GIT_REVISION_
        ERROR_QUIET
        OUTPUT_STRIP_TRAILING_WHITESPACE
        ERROR_STRIP_TRAILING_WHITESPACE
        )
    message("Git revision: ${GIT_REVISION_}")
endif()

set(COMPILE_DEFINITIONS
    VERSION_STR_POSTFIX=" Windows port, iface=${WPAS_CTRL_IFACE}"
    GIT_VERSION_STR_POSTFIX=", commit=${GIT_REVISION_}"
    CONFIG_NATIVE_WINDOWS
    CONFIG_ANSI_C_EXTRA
    CONFIG_WINPCAP
    IEEE8021X_EAPOL
    PKCS12_FUNCS
    PCSC_FUNCS
    CONFIG_CTRL_IFACE
    CONFIG_DRIVER_NDIS
    CONFIG_NDIS_EVENTS_INTEGRATED
    CONFIG_DEBUG_FILE
    EAP_MD5
    EAP_TLS
    EAP_MSCHAPv2
    EAP_PEAP
    EAP_TTLS
    EAP_GTC
    EAP_OTP
    EAP_SIM
    EAP_LEAP
    EAP_PSK
    EAP_AKA
    EAP_FAST
    EAP_PAX
    EAP_TNC
    EAP_TLS_OPENSSL
    CONFIG_SHA256
    CONFIG_NO_SOCKLEN_T_TYPEDEF
    TLS_DEFAULT_CIPHERS="DEFAULT:!EXP:!LOW"
    _CRT_SECURE_NO_DEPRECATE
    CONFIG_WPS
    EAP_WSC
    EAP_PWD
    EAP_AKA_PRIME
    EAP_SAKE
    EAP_GPSK
    EAP_GPSK_SHA256
    CONFIG_ECC
    EAP_TNC
    EAP_IKEV2
    ALL_DH_GROUPS
    EAP_EKE
    CONFIG_MACSEC
    CONFIG_SMARTCARD
    CONFIG_SAE
    CONFIG_SAE_PK
    CONFIG_HMAC_SHA256_KDF
    CONFIG_BGSCAN
    CONFIG_BGSCAN_SIMPLE
    CONFIG_WEP
    )
if(WPAS_CTRL_IFACE STREQUAL "pipe")
    list(APPEND COMPILE_DEFINITIONS CONFIG_CTRL_IFACE_NAMED_PIPE)
elseif(WPAS_CTRL_IFACE STREQUAL "udp")
    list(APPEND COMPILE_DEFINITIONS CONFIG_CTRL_IFACE_UDP)
endif()
add_compile_definitions(${COMPILE_DEFINITIONS})

if(MSVC AND MSVC_TOOLSET_VERSION EQUAL 80)
    add_link_options(
        "/OPT:WIN98"
        "/MANIFEST:NO"
        )
endif()

file(GLOB_RECURSE HEADERS ${BASE_DIR} *.h)
add_library(headers INTERFACE ${HEADERS})

set(COMMON_SOURCES
    "${BASE_DIR}/src/common/dragonfly.c"
    "${BASE_DIR}/src/common/hw_features_common.c"
    "${BASE_DIR}/src/common/ieee802_11_common.c"
    "${BASE_DIR}/src/common/sae.c"
    "${BASE_DIR}/src/common/sae_pk.c"
    "${BASE_DIR}/src/common/wpa_common.c"
    "${BASE_DIR}/src/crypto/aes-ctr.c"
    "${BASE_DIR}/src/crypto/aes-ctr.c"
    "${BASE_DIR}/src/crypto/aes-eax.c"
    "${BASE_DIR}/src/crypto/aes-encblock.c"
    "${BASE_DIR}/src/crypto/aes-omac1.c"
    "${BASE_DIR}/src/crypto/aes-siv.c"
    "${BASE_DIR}/src/crypto/crypto_openssl.c"
    "${BASE_DIR}/src/crypto/dh_groups.c"
    "${BASE_DIR}/src/crypto/fips_prf_openssl.c"
    "${BASE_DIR}/src/crypto/ms_funcs.c"
    "${BASE_DIR}/src/crypto/random.c"
    "${BASE_DIR}/src/crypto/sha1-prf.c"
    "${BASE_DIR}/src/crypto/sha1-tlsprf.c"
    "${BASE_DIR}/src/crypto/sha1-tprf.c"
    "${BASE_DIR}/src/crypto/sha256-kdf.c"
    "${BASE_DIR}/src/crypto/sha256-prf.c"
    "${BASE_DIR}/src/crypto/sha256-tlsprf.c"
    "${BASE_DIR}/src/crypto/tls_openssl.c"
    "${BASE_DIR}/src/crypto/tls_openssl_ocsp.c"
    "${BASE_DIR}/src/drivers/driver_common.c"
    "${BASE_DIR}/src/drivers/driver_ndis.c"
    "${BASE_DIR}/src/drivers/driver_ndis_.c"
    "${BASE_DIR}/src/drivers/ndis_events.c"
    "${BASE_DIR}/src/eap_common/chap.c"
    "${BASE_DIR}/src/eap_common/eap_common.c"
    "${BASE_DIR}/src/eap_common/eap_eke_common.c"
    "${BASE_DIR}/src/eap_common/eap_fast_common.c"
    "${BASE_DIR}/src/eap_common/eap_gpsk_common.c"
    "${BASE_DIR}/src/eap_common/eap_ikev2_common.c"
    "${BASE_DIR}/src/eap_common/eap_pax_common.c"
    "${BASE_DIR}/src/eap_common/eap_peap_common.c"
    "${BASE_DIR}/src/eap_common/eap_psk_common.c"
    "${BASE_DIR}/src/eap_common/eap_pwd_common.c"
    "${BASE_DIR}/src/eap_common/eap_sake_common.c"
    "${BASE_DIR}/src/eap_common/eap_sim_common.c"
    "${BASE_DIR}/src/eap_common/eap_wsc_common.c"
    "${BASE_DIR}/src/eap_common/ikev2_common.c"
    "${BASE_DIR}/src/eap_peer/eap.c"
    "${BASE_DIR}/src/eap_peer/eap_aka.c"
    "${BASE_DIR}/src/eap_peer/eap_eke.c"
    "${BASE_DIR}/src/eap_peer/eap_fast.c"
    "${BASE_DIR}/src/eap_peer/eap_fast_pac.c"
    "${BASE_DIR}/src/eap_peer/eap_gpsk.c"
    "${BASE_DIR}/src/eap_peer/eap_gtc.c"
    "${BASE_DIR}/src/eap_peer/eap_ikev2.c"
    "${BASE_DIR}/src/eap_peer/eap_leap.c"
    "${BASE_DIR}/src/eap_peer/eap_md5.c"
    "${BASE_DIR}/src/eap_peer/eap_methods.c"
    "${BASE_DIR}/src/eap_peer/eap_mschapv2.c"
    "${BASE_DIR}/src/eap_peer/eap_otp.c"
    "${BASE_DIR}/src/eap_peer/eap_pax.c"
    "${BASE_DIR}/src/eap_peer/eap_peap.c"
    "${BASE_DIR}/src/eap_peer/eap_psk.c"
    "${BASE_DIR}/src/eap_peer/eap_pwd.c"
    "${BASE_DIR}/src/eap_peer/eap_sake.c"
    "${BASE_DIR}/src/eap_peer/eap_sim.c"
    "${BASE_DIR}/src/eap_peer/eap_tls.c"
    "${BASE_DIR}/src/eap_peer/eap_tls_common.c"
    "${BASE_DIR}/src/eap_peer/eap_tnc.c"
    "${BASE_DIR}/src/eap_peer/eap_tnc.c"
    "${BASE_DIR}/src/eap_peer/eap_ttls.c"
    "${BASE_DIR}/src/eap_peer/eap_wsc.c"
    "${BASE_DIR}/src/eap_peer/ikev2.c"
    "${BASE_DIR}/src/eap_peer/mschapv2.c"
    "${BASE_DIR}/src/eap_peer/tncc.c"
    "${BASE_DIR}/src/eap_peer/tncc.c"
    "${BASE_DIR}/src/eapol_supp/eapol_supp_sm.c"
    "${BASE_DIR}/src/l2_packet/l2_packet_winpcap.c"
    "${BASE_DIR}/src/pae/ieee802_1x_cp.c"
    "${BASE_DIR}/src/pae/ieee802_1x_kay.c"
    "${BASE_DIR}/src/pae/ieee802_1x_key.c"
    "${BASE_DIR}/src/pae/ieee802_1x_secy_ops.c"
    "${BASE_DIR}/src/rsn_supp/pmksa_cache.c"
    "${BASE_DIR}/src/rsn_supp/preauth.c"
    "${BASE_DIR}/src/rsn_supp/wpa.c"
    "${BASE_DIR}/src/rsn_supp/wpa_ie.c"
    "${BASE_DIR}/src/utils/base64.c"
    "${BASE_DIR}/src/utils/bitfield.c"
    "${BASE_DIR}/src/utils/common.c"
    "${BASE_DIR}/src/utils/config.c"
    "${BASE_DIR}/src/utils/crc32.c"
    "${BASE_DIR}/src/utils/eloop_win.c"
    "${BASE_DIR}/src/utils/ip_addr.c"
    "${BASE_DIR}/src/utils/os_win32.c"
    "${BASE_DIR}/src/utils/pcsc_funcs.c"
    "${BASE_DIR}/src/utils/uuid.c"
    "${BASE_DIR}/src/utils/wpa_debug.c"
    "${BASE_DIR}/src/utils/wpabuf.c"
    "${BASE_DIR}/src/wps/wps.c"
    "${BASE_DIR}/src/wps/wps_attr_build.c"
    "${BASE_DIR}/src/wps/wps_attr_parse.c"
    "${BASE_DIR}/src/wps/wps_attr_process.c"
    "${BASE_DIR}/src/wps/wps_common.c"
    "${BASE_DIR}/src/wps/wps_dev_attr.c"
    "${BASE_DIR}/src/wps/wps_enrollee.c"
    "${BASE_DIR}/src/wps/wps_registrar.c"
    "${BASE_DIR}/wpa_supplicant/bgscan.c"
    "${BASE_DIR}/wpa_supplicant/bgscan_simple.c"
    "${BASE_DIR}/wpa_supplicant/bss.c"
    "${BASE_DIR}/wpa_supplicant/bssid_ignore.c"
    "${BASE_DIR}/wpa_supplicant/config.c"
    "${BASE_DIR}/wpa_supplicant/ctrl_iface.c"
    "${BASE_DIR}/wpa_supplicant/eap_register.c"
    "${BASE_DIR}/wpa_supplicant/events.c"
    "${BASE_DIR}/wpa_supplicant/notify.c"
    "${BASE_DIR}/wpa_supplicant/op_classes.c"
    "${BASE_DIR}/wpa_supplicant/robust_av.c"
    "${BASE_DIR}/wpa_supplicant/rrm.c"
    "${BASE_DIR}/wpa_supplicant/scan.c"
    "${BASE_DIR}/wpa_supplicant/twt.c"
    "${BASE_DIR}/wpa_supplicant/wmm_ac.c"
    "${BASE_DIR}/wpa_supplicant/wpa_supplicant.c"
    "${BASE_DIR}/wpa_supplicant/wpas_glue.c"
    "${BASE_DIR}/wpa_supplicant/wpas_kay.c"
    "${BASE_DIR}/wpa_supplicant/wps_supplicant.c"
    )
if(WPAS_CTRL_IFACE STREQUAL "pipe")
    list(APPEND COMMON_SOURCES "${BASE_DIR}/wpa_supplicant/ctrl_iface_named_pipe.c")
elseif(WPAS_CTRL_IFACE STREQUAL "udp")
    list(APPEND COMMON_SOURCES "${BASE_DIR}/wpa_supplicant/ctrl_iface_udp.c")
endif()

add_executable(
    win_if_list
    "${BASE_DIR}/wpa_supplicant/win_if_list.c"
    )
target_link_libraries(
    win_if_list
    PRIVATE
    wpcap
    )
add_dependencies(win_if_list headers)
set_property(
    TARGET
    win_if_list
    PROPERTY
    MSVC_RUNTIME_LIBRARY
    "MultiThreaded$<$<CONFIG:Debug>:Debug>"
    )

add_executable(
    wpa_cli
    "${BASE_DIR}/src/common/cli.c"
    "${BASE_DIR}/src/common/wpa_ctrl.c"
    "${BASE_DIR}/src/utils/common.c"
    "${BASE_DIR}/src/utils/edit_simple.c"
    "${BASE_DIR}/src/utils/eloop_win.c"
    "${BASE_DIR}/src/utils/os_win32.c"
    "${BASE_DIR}/src/utils/wpa_debug.c"
    "${BASE_DIR}/wpa_supplicant/wpa_cli.c"
    )
target_link_libraries(
    wpa_cli
    PRIVATE
    ws2_32
    )
add_dependencies(wpa_cli headers)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        wpa_cli
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

add_executable(
    wpa_passphrase
    "${BASE_DIR}/src/crypto/crypto_openssl.c"
    "${BASE_DIR}/src/utils/common.c"
    "${BASE_DIR}/src/utils/os_win32.c"
    "${BASE_DIR}/src/utils/wpa_debug.c"
    "${BASE_DIR}/src/utils/wpabuf.c"
    "${BASE_DIR}/wpa_supplicant/wpa_passphrase.c"
    )
target_link_libraries(
    wpa_passphrase
    PRIVATE
    ws2_32
    libcrypto
    crypt32
    )
add_dependencies(wpa_passphrase headers)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        wpa_passphrase
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

add_executable(
    wpa_supplicant
    ${COMMON_SOURCES}
    "${BASE_DIR}/src/drivers/drivers.c"
    "${BASE_DIR}/wpa_supplicant/config_file.c"
    "${BASE_DIR}/wpa_supplicant/main.c"
    )
target_link_libraries(
    wpa_supplicant
    PRIVATE
    wbemuuid
    ws2_32
    libcrypto
    packet
    wpcap
    libssl
    crypt32
    )
add_dependencies(wpa_supplicant headers)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        wpa_supplicant
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

add_executable(
    wpasvc
    ${COMMON_SOURCES}
    "${BASE_DIR}/src/drivers/drivers.c"
    "${BASE_DIR}/wpa_supplicant/config_winreg.c"
    "${BASE_DIR}/wpa_supplicant/main_winsvc.c"
    )
target_link_libraries(
    wpasvc
    PRIVATE
    wbemuuid
    ws2_32
    libcrypto
    packet
    wpcap
    libssl
    crypt32
    )
add_dependencies(wpasvc headers)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        wpasvc
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

add_executable(
    eapol_test
    ${COMMON_SOURCES}
    "${BASE_DIR}/src/radius/radius.c"
    "${BASE_DIR}/src/radius/radius_client.c"
    "${BASE_DIR}/wpa_supplicant/config_file.c"
    "${BASE_DIR}/wpa_supplicant/eapol_test.c"
    )
target_link_libraries(
    eapol_test
    PRIVATE
    wbemuuid
    ws2_32
    libcrypto
    packet
    wpcap
    libssl
    crypt32
    )
add_dependencies(eapol_test headers)
set_target_properties(eapol_test PROPERTIES EXCLUDE_FROM_ALL TRUE)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        eapol_test
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

add_executable(
    preauth_test
    ${COMMON_SOURCES}
    "${BASE_DIR}/wpa_supplicant/config_file.c"
    "${BASE_DIR}/wpa_supplicant/preauth_test.c"
    )
target_link_libraries(
    preauth_test
    PRIVATE
    wbemuuid
    ws2_32
    libcrypto
    packet
    wpcap
    libssl
    crypt32
    )
add_dependencies(preauth_test headers)
set_target_properties(preauth_test PROPERTIES EXCLUDE_FROM_ALL TRUE)
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        preauth_test
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_INCLUDE_CURRENT_DIR ON)
find_package(Qt4 4.4.0 REQUIRED QtGui)
QT4_ADD_TRANSLATION(
    QM_FILES
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/lang/wpa_gui_de.ts"
    )
add_executable(
    wpa_gui
    WIN32
    "${BASE_DIR}/src/common/wpa_ctrl.c"
    "${BASE_DIR}/src/utils/common.c"
    "${BASE_DIR}/src/utils/os_win32.c"
    "${BASE_DIR}/src/utils/wpa_debug.c"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/wpamsg.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/wpagui.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/eventhistory.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/scanresults.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/scanresultsitem.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/signalbar.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/userdatarequest.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/networkconfig.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/addinterface.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/peers.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/stringquery.h"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/main.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/wpagui.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/eventhistory.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/scanresults.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/scanresultsitem.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/signalbar.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/userdatarequest.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/networkconfig.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/addinterface.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/peers.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/stringquery.cpp"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/icons.qrc"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/icons_png.qrc"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/icons_status.qrc"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/wpagui.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/eventhistory.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/scanresults.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/userdatarequest.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/networkconfig.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/peers.ui"
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4/wpa_gui.rc"
    ${QM_FILES}
    )
target_compile_definitions(
    wpa_gui
    PRIVATE
    NOMINMAX
    )
target_include_directories(
    wpa_gui
    PRIVATE
    "${BASE_DIR}/wpa_supplicant/wpa_gui-qt4"
    )
target_link_libraries(
    wpa_gui
    PRIVATE
    Qt4::QtGui
    ws2_32
    crypt32
    gdi32
    advapi32
    user32
    winmm
    imm32
    )
if(WPAS_STATIC_RUNTIME)
    set_property(
        TARGET
        wpa_gui
        PROPERTY
        MSVC_RUNTIME_LIBRARY
        "MultiThreaded$<$<CONFIG:Debug>:Debug>"
        )
endif()

install(
    TARGETS
    win_if_list
    wpa_cli
    wpa_gui
    wpa_passphrase
    wpa_supplicant
    wpasvc
    RUNTIME DESTINATION .
    )
install(
    FILES
    "${BASE_DIR}/COPYING"
    "${BASE_DIR}/wpa_supplicant/README"
    "${BASE_DIR}/wpa_supplicant/README-Windows.txt"
    "${BASE_DIR}/wpa_supplicant/win_example.reg"
    "${BASE_DIR}/wpa_supplicant/wpa_supplicant.conf"
    ${QM_FILES}
    DESTINATION .
    )

set(CPACK_GENERATOR "ZIP")
set(CPACK_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-windows-bin-${CMAKE_PROJECT_VERSION}-${WPAS_CTRL_IFACE}")
set(CPACK_STRIP_FILES TRUE)
include(CPack)