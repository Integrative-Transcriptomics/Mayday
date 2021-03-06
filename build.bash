# Configuration
# These parameters are passed to maven with '-Dargname=value' and are
# accessible from within a pom by '${argname}'

# The URL where webstart will be deployed to
JNLP_CODEBASE="http://example.com/path"
# Restrict Re-Deployment to these domains
#JAR_CODEBASE='*.uni-tuebingen.de'
JAR_CODEBASE='*'

# Java keystore, must be absolute path
KEYSTORE="/abs/pathto/myKeystore"
STOREPASS=123456
# The identity which should be used
ALIAS=myself
KEYPASS=123456

# Build order according to dependencies between modules
BUILDORDER=(core level2 mlearning pathway air gaggle)

# Compile/Build jars and push them into local repository
# + Create webstart folder, which conveniently also contains all dependencies
for i in ${BUILDORDER[@]} ; do
    cd $i
    # build + push to repo
    mvn install || exit -1
    # create webstart
    mvn webstart:jnlp -Dcodebase="$JNLP_CODEBASE" || exit -1
    cd ..
done

# Merge all Jnlp folders into one
mkdir -p target/jnlp
# Iterate over reversed BUILDORDER
for (( idx=${#BUILDORDER[@]}-1 ; idx>=0 ; idx-- )) ; do
    # reversed buildorder to prevent overwriting jars with older versions
    i="${BUILDORDER[idx]}"
    cp -R $i/target/jnlp/* target/jnlp
done

# Add jnlp to link plugins
# make $CODEBASE save for sed use
CODE2=$(echo "$JNLP_CODEBASE" | sed -e 's/[\/&]/\\&/g')
sed "s/CODEBASE/$CODE2/" core/src/main/jnlp/plugins.jnlp > target/jnlp/plugins.jnlp

# Adjust security related manifest entries in all jars + dependencies
cd target/jnlp/jars

# The attributes to change
cat > manifestupdate.txt << EOF
Permissions: all-permissions
Codebase: $JAR_CODEBASE
Caller-Allowable-Codebase: $JAR_CODEBASE
Application-Library-Allowable-Codebase: $JAR_CODEBASE
Trusted-Library: true
Trusted-Only: true
Application-Name: Mayday
EOF

# Update manifests
for i in *.jar ; do
    jar umf manifestupdate.txt $i 2>&1 1>/dev/null
done

# Mayday requires explicit lists of Plugins and Resources
for i in ${BUILDORDER[@]} ; do
    JAR=${i}*.jar
    echo "Bewitching $JAR"
    # Scan jar for plugins and resources
    java -cp core-*.jar mayday.core.pluma.buildsystem.PrepareJar $JAR . 1>/dev/null
    # Update manifest and add resource list
    jar umf plugins.mf $JAR resources_list.txt 2>&1 1>/dev/null || exit -1
    # Remove for next iteration
    rm plugins.mf
    rm resources_list.txt
done

# Clean up the folder
rm manifestupdate.txt
cd ../../..


# Sign jars in jnlp folders
mvn jarsigner:sign -Dkeystore="$KEYSTORE" -Dalias=$ALIAS -Dkeypass=$KEYPASS -Dstorepass=$STOREPASS || exit -1

# add images
IMG_PATH="core/src/main/resources/mayday/images/"
cp ${IMG_PATH}/splash.png target/jnlp/
cp ${IMG_PATH}/icon32.gif target/jnlp/


# Bundle jars together for a standalone version
mkdir -p target/jnlp/Mayday
cd target/jnlp/Mayday
cp -R ../jars plugins
# Make 'executables'
for i in 6 8 16 ; do
cat > mayday_${i}.bat << EOF
@ECHO OFF
start java -Xms512m -Xmx${i}G -jar plugins/core-*.jar
EOF

cat > mayday_${i}.sh << EOF
#!/bin/bash
java -Xms512m -Xmx${i}G -jar plugins/core-*.jar
EOF
done

# zip up
cd ..
zip -r Mayday Mayday
rm -rf Mayday
#back to workspace
cd ../..

echo "Deploy the content of the folder target/jnlp to ${JNLP_CODEBASE}"
echo "(most likely with the scp command)"

echo "DONE."
echo "Have a nice day!"
