#!/usr/bin/env bash


modules=( air core gaggle level2 mlearning pathway )
giturl="https://lambda.informatik.uni-tuebingen.de/gitlab/mayday"


# download sources
for i in ${modules[@]} ; do
    git clone "$giturl/$i.git"
done
git clone "$giturl/libraries.git"

# create eclipse project data
mvn eclipse:eclipse

# a few files can not be found in any repository
# -> manual add to local maven repo
cd libraries

# URL: http://sourceforge.net/projects/java-registry/
mvn install:install-file -Dfile=WinRegistry-4.5.jar \
    -DgroupId=at.jta -DartifactId=WinRegistry \
    -Dversion=4.5 -Dpackaging=jar
# Affymetrix Fusion from http://www.affymetrix.com/estore/partners_programs/programs/developer/fusion/index.affx?terms=no
mvn install:install-file -Dfile=AffxFusion-1.1.2.jar \
    -DgroupId=affymetrix -DartifactId=fusion \
    -Dversion=1.1.2 -Dpackaging=jar
# Keggs SOAP api
mvn install:install-file -Dfile=lib-kegg-0.jar \
    -DgroupId=kegg -DartifactId=lib-kegg \
    -Dversion=0 -Dpackaging=jar
# Gaggle
mvn install:install-file -Dfile=lib-goose-0.jar \
    -DgroupId=net.systemsbiology.gaggle -DartifactId=lib-goose \
    -Dversion=0 -Dpackaging=jar
# http://jung.sourceforge.net/index.html
mvn install:install-file -Dfile=lib-jung-0.jar \
    -DgroupId=jung -DartifactId=lib-jung \
    -Dversion=0 -Dpackaging=jar
# NUX from http://dst.lbl.gov/ACSSoftware/nux/nux-download/releases/
mvn install:install-file -Dfile=nux-1.6.jar \
    -DgroupId=gov.lbl.dst -DartifactId=nux \
    -Dversion=1.6 -Dpackaging=jar
# Oracles jdbc2_0-stdext
mvn install:install-file -Dfile=jdbc2_0-stdext.jar \
    -DgroupId=javax.sql -DartifactId=jdbc-stdext \
    -Dversion=2.0 -Dpackaging=jar
# Dockingframes
mvn install:install-file -Dfile=docking-frames-common-1.1.2.jar \
    -DgroupId=bibliothek.gui.dock -DartifactId=docking-frames-common \
    -Dversion=1.1.2 -Dpackaging=jar
mvn install:install-file -Dfile=docking-frames-core-1.1.2.jar \
    -DgroupId=bibliothek.gui.dock -DartifactId=docking-frames-core \
    -Dversion=1.1.2 -Dpackaging=jar
cd ..

echo "DONE."
