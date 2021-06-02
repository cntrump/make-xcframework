#!/usr/bin/env zsh

set -e

name=$1
if [ ! -d "${name}.framework" ]; then
    echo "${name}.framework not found."
    exit -1
fi

archs=($(lipo -archs ${name}.framework/${name}))

[ -d iphoneos ] && rm -rf iphoneos
[ -d iphonesimulator ] && rm -rf iphonesimulator
[ -d "${name}.xcframework" ] && rm -rf "${name}.xcframework"

mkdir iphoneos iphonesimulator

cp -r "${name}.framework" "iphoneos/"
cp -r "${name}.framework" "iphonesimulator/"

for arch in ${archs}
do
    if [[ "${arch}" =~ ^arm ]]; then
        input="iphonesimulator/${name}.framework/${name}"
        output="iphonesimulator/${name}.framework/${name}.out"
    else # simulator
        input="iphoneos/${name}.framework/${name}"
        output="iphoneos/${name}.framework/${name}.out"
    fi

    lipo -remove ${arch} "${input}" -output "${output}"
    mv "${output}" "${input}"
done

xcodebuild -create-xcframework \
           -framework "iphoneos/${name}.framework" \
           -framework "iphonesimulator/${name}.framework" \
           -output "${name}.xcframework"

rm -rf iphone*

tar czvf "${name}.xcframework.tar.gz" "${name}.xcframework"

echo "${name}.xcframework.tar.gz archived."