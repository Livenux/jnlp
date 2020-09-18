FROM jnlp/

ENV TZ=Asia/Shanghai
RUN apt-get update && apt-get install -y tzdata apt-transport-https \
    ca-certificates \
    curl git openjdk-11-jre sudo \
    gnupg-agent \
    software-properties-common && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add - && \
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add - && \
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable" && \
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
    tee -a /etc/apt/sources.list.d/kubernetes.list && \ 
    apt-get update && apt-get install -y docker-ce-cli kubectl && \
    rm -rf /var/lib/apt/lists/*  && \
    useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -d /home/jenkins jenkins && \
    usermod -aG docker jenkins && \
    sed -i '/^root/a\jenkins    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers && \ 
    mkdir -p  /home/jenkins/.jenkins /home/jenkins/agent /usr/share/jenkins /root/.kube 

COPY  agent.jar /usr/share/jenkins/   
COPY jenkins-agent /usr/bin/

USER root
WORKDIR /home/jenkins

ENTRYPOINT ["jenkins-agent"]
