CPPFLAGS="${CPPFLAGS:-} -I${PWD}/src/include"
CFLAGS="${CFLAGS:-} -ffunction-sections -fdata-sections"
LDFLAGS="-L${DEST}/lib -L${DEPS}/lib -Wl,--gc-sections"

### INCRON ###
_build_incron() {
local VERSION="0.5.10"
local FOLDER="incron-${VERSION}"
local FILE="${FOLDER}.tar.gz"
local URL="http://inotify.aiken.cz/download/incron/${FILE}"

_download_tgz "${FILE}" "${URL}" "${FOLDER}"
pushd "target/${FOLDER}"
make PREFIX="${DEST}" CFGDIR="${DEST}/etc" SYSDATADIR="${DEST}/etc/incron.d" USERDATADIR="${DEST}/var/incron.d" CXX="${CXX}" CXXFLAGS="${CXXFLAGS} -Wall -pipe" USER="${USER}" install
"${STRIP}" -s -R .comment -R .note -R .note.ABI-tag "${DEST}/sbin/incrond" "${DEST}/bin/incrontab"
popd
}

_build_rootfs() {
# /bin/incrontab
# /sbin/incrond
  return 0
}

_build() {
  _build_incron
  _package
}
