#!/bin/bash

set -e

RESOURCE_FILE="$1"
TARGET_FILE="$2"

#RESOURCE_LOAD_TOOL=cat
RESOURCE_LOAD_TOOL="gzip --stdout"

echo "// Generated from ${RESOURCE_FILE}" > "${TARGET_FILE}"
echo "//   on `date`" >> "${TARGET_FILE}"
echo "//   by $0" >> "${TARGET_FILE}"
echo "//" >> "${TARGET_FILE}"

# FIXME: not the zipped size!
FILE_SIZE="$(wc -c <"$RESOURCE_FILE")"

nicename="$(basename ${RESOURCE_FILE} | sed 's/\./_/g' | sed 's/\-/_/g')"

echo "  public static let raw_len_${nicename} = ${FILE_SIZE}" >> "${TARGET_FILE}"

echo -n "  public static let ${nicename} : String = \"" >> "${TARGET_FILE}"

echo -n $(gzip --stdout "${RESOURCE_FILE}" | base64) >> "${TARGET_FILE}"

echo "\"" >> "${TARGET_FILE}"
echo "  public static let data_${nicename} = Data(base64Encoded: ${nicename})!" >> "${TARGET_FILE}"
