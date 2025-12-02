#!/usr/bin/env bash
# SPDX-License-Identifier: AGPL-3.0-or-later

declare _Blue
declare _creset

vite.help() {
    cat <<EOF
vite.:  .. to be done ..
  simple.:
    build: build static files of the simple theme
    fix:   run prettiers on simple theme
    lint:  run linters on simple theme
    dev:   start development server
EOF
}

VITE_SIMPLE_THEME="${REPO_ROOT}/client/comboom.sucht"

# ToDo: vite server is not implemented yet / will be done in a follow up PR
#
# vite.cbps.dev() {
#     (   set -e
#         build_msg SIMPLE "start server for FE development of: ${VITE_SIMPLE_THEME}"
#         pushd "${VITE_SIMPLE_THEME}"
#         npm install
#         npm exec -- vite
#         popd &> /dev/null
#     )
# }

vite.cbps.build() {
    (
        set -e
        templates.cbps.pygments

        node.env
        build_msg SIMPLE "run build of theme from: ${VITE_SIMPLE_THEME}"

        pushd "${VITE_SIMPLE_THEME}"
        npm install
        npm run build
        popd &>/dev/null
    )
}

vite.cbps.analyze() {
    (
        set -e
        templates.cbps.pygments

        node.env
        build_msg SIMPLE "run analyze of theme from: ${VITE_SIMPLE_THEME}"

        pushd "${VITE_SIMPLE_THEME}"
        npm install
        VITE_BUNDLE_ANALYZE=true npm run build
        popd &>/dev/null
    )
}

vite.cbps.fix() {
    (
        set -e
        node.env
        npm --prefix client/comboom.sucht run fix
    )
}

vite.cbps.lint() {
    (
        set -e
        node.env
        npm --prefix client/comboom.sucht run lint
    )
}

templates.cbps.pygments() {
    build_msg PYGMENTS "searxng_extra/update/update_pygments.py"
    pyenv.cmd python searxng_extra/update/update_pygments.py |
        prefix_stdout "${_Blue}PYGMENTS ${_creset} "
    if [ "${PIPESTATUS[0]}" -ne "0" ]; then
        build_msg PYGMENTS "building LESS files for pygments failed"
        return 1
    fi
    return 0
}
