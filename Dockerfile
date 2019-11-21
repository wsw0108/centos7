FROM centos:centos7.2.1511

ARG user=wsw

LABEL "maintainer"="wsw0108@qq.com"

# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

RUN yum update -y && \
yum install -y \
which less file unzip lftp sudo openssl \
make \
gcc gcc-c++ \
glibc-devel libstdc++-devel libstdc++-static \
glibc-devel.i686 libstdc++-devel.i686 libstdc++-static.i686 \
java-11-openjdk java-11-openjdk-devel \
cairo cairo-devel libjpeg-turbo-devel pango pango-devel giflib-devel && \
curl -sL https://rpm.nodesource.com/setup_8.x | bash - && \
yum install -y nodejs && \
yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-WANdisco && \
yum install -y git && \
yum install -y epel-release && \
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 && \
yum install -y patchelf && \
yum clean all

COPY gitconfig /etc/gitconfig

# install yarn & node-gyp
RUN npm install -g yarn
RUN yarn global add node-gyp

RUN mkdir -p /opt/goroot && \
curl -sL https://dl.google.com/go/go1.13.4.linux-amd64.tar.gz -o /tmp/go1.13.4.linux-amd64.tar.gz && \
tar xf /tmp/go1.13.4.linux-amd64.tar.gz -C /opt/goroot && \
rm -f /tmp/go1.13.4.linux-amd64.tar.gz

RUN useradd -r -m -G wheel -p "$(openssl passwd -1 ' ')" $user

USER $user

# RUN npm config set registry https://registry.npm.taobao.org/

# Set environment variables.
ENV HOME /home/$user
ENV PATH="/opt/goroot/go/bin:${PATH}"

# Define working directory.
WORKDIR $HOME

#VOLUME ["$HOME/projects", "$HOME/.npm", "$HOME/.m2"]
VOLUME ["$HOME/projects"]

# Define default command.
CMD ["bash"]
