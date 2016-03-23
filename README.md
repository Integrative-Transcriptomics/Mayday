# Welcome to Mayday

Mayday is THE workbench for visualization, analysis, and storage of microarray
data. Thank you for your interest in our code basis.

## Requirements

Besides **java>=1.7** and you favorite IDE/editor, you need

1. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. [maven](https://maven.apache.org/install.html)

## Source download directions

        git clone https://lambda.informatik.uni-tuebingen.de/gitlab/mayday/Mayday.git
        cd Mayday
        ./setup.bash

This will create a new folder *Mayday* at your current working directory.

## Import into an IDE

### IntelliJ

Choose the **Create new Project from existing source** option, and
select the file **pom.xml** within the *Mayday* folder.
When running Mayday from the IDE, please set the *classpath from module*
option in the run configurations, because the additional dependencies or a module
would not be loaded.

### Eclipse

1. Open/Create Workspace at the *Mayday* folder
2. File > Import
3. General > Existing Projects into Workspace
4. Choose the *Mayday* as the **root directory**
5. Finish import dialog
