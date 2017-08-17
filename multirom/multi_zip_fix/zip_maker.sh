#!/bin/bash

#kernel folder yours folder
FOLDER=$HOME/android/rr/multi_zip;
cd $FOLDER;

ZIPNAME="Quark_Multi_ROM_FIX_V_1_0.zip";


cd ./multi_zip_fix/
rm -rf ./*.zip
zip -r9 Multi_temp * -x README .gitignore modules/.gitignore ZipScriptSign/* ZipScriptSign/bin/* how_to_build_this.sh
mv Multi_temp.zip ./ZipScriptSign
./ZipScriptSign/sign.sh test Multi_temp.zip
rm -rf ./ZipScriptSign/Multi_temp.zip
mv ./ZipScriptSign/Multi_temp-signed.zip ./$ZIPNAME
cd -


