FROM debian

ENV TZ=Asia/Shanghai
RUN sed -i 's/deb.debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list && \
    sed -i 's/security.debian.org/mirrors.cloud.tencent.com/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y tzdata apt-transport-https \
    ca-certificates \
    curl git openjdk-11-jre sudo \
    gnupg-agent \
    software-properties-common && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    curl -fsSL https://mirrors.cloud.tencent.com/docker-ce/linux/debian/gpg | sudo apt-key add - && \
    curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://mirrors.cloud.tencent.com/docker-ce/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    echo "deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main" | \
    tee -a /etc/apt/sources.list.d/kubernetes.list && \ 
    apt-get update && apt-get install -y docker-ce-cli kubectl && \
    rm -rf /var/lib/apt/lists/*  && \
    useradd -c "Jenkins user" -d /home/jenkins jenkins && \
    sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers && \ 
    mkdir -p  /home/jenkins/.jenkins /home/jenkins/agent /usr/share/jenkins /root/.kube 

COPY  agent.jar /usr/share/jenkins/   
COPY jenkins-agent /usr/bin/

USER root
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-agent"]
