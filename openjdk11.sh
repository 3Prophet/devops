!#/bin/bash
#yum update -y
yum install unzip -y

TEMP_DIR="/home/vagrant/temp_openjdk"
INSTALL_DIR="/usr/local"
PROFILE="/etc/profile.d/jdk11.sh"
DISTRO="/vagrant/software"
FJDK="jdk-11.0.2"
FJFX="javafx-sdk-11.0.2"
FJDK_ARCH="open${FJDK}_linux-x64_bin.tar.gz"
FJFX_ARCH="openjfx-11.0.2_linux-x64_bin-sdk.zip"
BUILDER_RPM="scenebuilder-11.0.0-1.x86_64.rpm"
ECLIPSE="eclipse-java-2019-03-R-linux-gtk-x86_64.tar.gz"

# Creating temporary directory and moving there software archives from the distro
mkdir $TEMP_DIR

for FILE in $FJDK_ARCH $FJFX_ARCH $BUILDER_RPM $ECLIPSE
do
    cp $DISTRO/$FILE $TEMP_DIR
done

cd $TEMP_DIR

yum --nogpgcheck localinstall $BUILDER_RPM -y

#curl -O https://download.java.net/java/GA/jdk11/13/GPL/openjdk-11.0.1_linux-x64_bin.tar.gz
# Unarchiving open JDK 11, installing it and setting the paths
tar zxvf $FJDK_ARCH
mv $FJDK $INSTALL_DIR
touch $PROFILE
echo "export JAVA_HOME=${INSTALL_DIR}/${FJDK}" >> $PROFILE
echo 'export PATH=$PATH:$JAVA_HOME/bin' >> $PROFILE

# Unarchiving open JFX 11, installing it and setting the path
unzip $FJFX_ARCH
mv $FJFX $INSTALL_DIR
echo "export PATH_TO_FX=${INSTALL_DIR}/${FJFX}/lib" >> $PROFILE

# Updating environment variables
source $PROFILE

#yum --nogpgcheck localinstall $BUILDER_RPM -y

tar zxvf $ECLIPSE

# Deleting temporary directory
#rm -rf $TEMP_DIR

yum install maven -y

git config --global user.name "Dmitry Logvinovich"
git config --global user.email dlogvinovich@yahoo.com



#--module-path /opt/java/javafx-sdk-11.0.2/lib
#--add-modules=javafx.controls,javafx.fxml
