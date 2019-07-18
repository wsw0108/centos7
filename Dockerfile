FROM centos:centos7.2.1511

ARG user=wsw

LABEL "maintainer"="wsw0108@qq.com"

# RUN curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

RUN yum update -y && \
yum install -y \
which less file unzip \
make \
gcc gcc-c++ \
glibc-devel libstdc++-devel libstdc++-static \
glibc-devel.i686 libstdc++-devel.i686 libstdc++-static.i686 \
java-11-openjdk java-11-openjdk-devel \
maven \
cairo cairo-devel libjpeg-turbo-devel pango pango-devel giflib-devel && \
rpm --import https://mirror.go-repo.io/centos/RPM-GPG-KEY-GO-REPO && \
curl -s https://mirror.go-repo.io/centos/go-repo.repo | tee /etc/yum.repos.d/go-repo.repo && \
yum install -y golang && \
curl -sL https://rpm.nodesource.com/setup_8.x | bash - && \
yum install -y nodejs && \
yum install -y http://opensource.wandisco.com/centos/7/git/x86_64/wandisco-git-release-7-2.noarch.rpm && \
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-WANdisco && \
yum install -y git && \
yum clean all

COPY gitconfig /etc/gitconfig

# install yarn & node-gyp
RUN npm install -g yarn
RUN yarn global add node-gyp

RUN useradd -m $user

USER $user

# RUN npm config set registry https://registry.npm.taobao.org/

# Set environment variables.
ENV HOME /home/$user

# Define working directory.
WORKDIR $HOME/projects

VOLUME ["$HOME/projects", "$HOME/.m2", "$HOME/.npm"]

# Define default command.
CMD ["bash"]
