#!/bin/bash

cat >hellogt.cpp <<EOF
// hellogt.cpp
// manual: http://www.gnu.org/software/gettext/manual/gettext.html
#include <locale.h>
#include <stdio.h>
#include <libintl.h>
#define _(String) gettext(String)
int main (){
    setlocale(LC_ALL, "");
    bindtextdomain("hellogt", "./i18n");
    textdomain( "hellogt");
    //printf("%s\n", _("hello, world!") ); //error
    printf("%s\n", gettext("hello, world!") );
}
EOF
gcc -o hellogt hellogt.cpp
xgettext --package-name hellogt --package-version 1.2 --default-domain hellogt --output hellogt.pot *.cpp
msginit --no-translator --locale es_MX --output-file hellogt_spanish.po --input hellogt.pot
msginit --no-translator --locale ru_RU.UTF-8 --output-file hellogt_rus.po --input hellogt.pot
sed --in-place hellogt_spanish.po --expression='/"hello, world!"/,/#: / s/""/"hola mundo"/'
sed --in-place hellogt_rus.po --expression='/"hello, world!"/,/#: / s/""/"привет мир"/'
mkdir --parents ./i18n/es_MX.utf8/LC_MESSAGES
mkdir --parents ./i18n/ru_RU.utf8/LC_MESSAGES
msgfmt --check --verbose --output-file ./i18n/es_MX.utf8/LC_MESSAGES/hellogt.mo hellogt_spanish.po
msgfmt --check --verbose --output-file ./i18n/ru_RU.utf8/LC_MESSAGES/hellogt.mo hellogt_rus.po
LANGUAGE=es_MX.utf8 ./hellogt
LANGUAGE=ru_RU.utf8 ./hellogt