#!/bin/bash

GSL_COMPAT_FILES=("compatibilitytool.vdf" "displayquery.py" "toolmanifest.vdf" "version")

GSL_BIN="/usr/bin/gamescopelauncher"
GSL_ETC_DIR="/etc/gamescopelauncher"
GSL_HOME_DIR="${HOME}/.config/gamescopelauncher"
STEAM_COMPATDIR="${HOME}/.local/share/Steam/compatibilitytools.d"
GSL_STEAM_COMPATDIR="${STEAM_COMPATDIR}/gamescopelauncher"
if [[ "$1" == "remove" || "$1" == "uninstall" || "$1" == "purge" ]]; then
    if [[ "$1" == "purge" ]]; then
        echo "Purging gamescopelauncher"
        rm -rf "${GSL_STEAM_COMPATDIR}" > /dev/null 2>&1
        rm -rf "${GSL_HOME_DIR}" > /dev/null 2>&1
        rmdir -p "${STEAM_COMPATDIR}" > /dev/null 2>&1
    else
        echo "Uninstalling gamescopelauncher"
        for i in "${GSL_COMPAT_FILES[@]}"; do
            rm "${GSL_STEAM_COMPATDIR}/${i}" > /dev/null 2>&1
        done
        rm "${GSL_STEAM_COMPATDIR}/gamescopelauncher" > /dev/null 2>&1
        rmdir "${GSL_HOME_DIR}/app" > /dev/null 2>&1
        rmdir "${GSL_HOME_DIR}" > /dev/null 2>&1
        rmdir "${GSL_STEAM_COMPATDIR}" > /dev/null 2>&1
    fi

    sudo rm "${GSL_BIN}" > /dev/null 2>&1
    sudo rm -r "${GSL_ETC_DIR}" > /dev/null 2>&1
else
    echo "Installing gamescopelauncher"
    mkdir -p "${GSL_STEAM_COMPATDIR}"
    cp -f "${GSL_COMPAT_FILES[@]}" "${GSL_STEAM_COMPATDIR}/"
    mkdir -p "${GSL_HOME_DIR}"
    sudo mkdir -p "${GSL_ETC_DIR}"
    sudo cp -r config/* "${GSL_ETC_DIR}/"
    sudo cp "gamescopelauncher" "${GSL_BIN}"
    sudo chmod a+x "${GSL_BIN}"
    ln -fs "${GSL_BIN}" "${GSL_STEAM_COMPATDIR}/gamescopelauncher"
fi
