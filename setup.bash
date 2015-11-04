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


# update classpath files
path=$(pwd)
for i in ${modules[@]} ; do
    # Remove unwanted entries from project classpath file
    grep -v "M2_REPO/mayday" $i/.classpath | \
            grep -v "</classpath>" \
            > $i/.classpath_tmp
    # Add each library jar
    for lib in libraries/*.jar ; do
        echo "<classpathentry kind=\"lib\" path=\"$path/$lib\"/>" \
                >> $i/.classpath_tmp
    done
    # Add correct closing tag
    echo "</classpath>" >> $i/.classpath_tmp
    # 'save' changes
    mv $i/.classpath_tmp $i/.classpath
done

echo "DONE."
