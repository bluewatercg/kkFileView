# 构建阶段：编译 KKFileView 4.4.0
FROM maven:3.8.6-openjdk-8 AS builder
WORKDIR /app
RUN git clone https://github.com/kekingcn/kkFileView.git . && \
    git checkout v4.4.0 && \
    mvn clean package -DskipTests

# 运行阶段
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /app

# 安装依赖
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        openjdk-8-jre \
        tzdata \
        locales \
        xfonts-utils \
        fontconfig \
        libreoffice-nogui \
        ttf-mscorefonts-installer \
        ttf-wqy-microhei \
        ttf-wqy-zenhei \
        xfonts-wqy && \
    echo 'Asia/Shanghai' > /etc/timezone && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    localedef -i zh_CN -c -f UTF-8 -A /usr/share/locale/locale.alias zh_CN.UTF-8 && \
    locale-gen zh_CN.UTF-8 && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# # 复制中文字体（可选）
# COPY fonts/* /usr/share/fonts/chinese/
# RUN mkdir -p /usr/share/fonts/chinese && \
#     cd /usr/share/fonts/chinese && \
#     mkfontscale && \
#     mkfontdir && \
#     fc-cache -fv
find / -name "file-preview-4.4.0.jar" 2>/dev/null
​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​​
# 复制编译好的 jar
COPY --from=builder /app/target/file-preview-4.4.0.jar /app/kkFileView.jar

# 设置环境变量
ENV LANG=zh_CN.UTF-8 \
    LC_ALL=zh_CN.UTF-8

# 暴露端口
EXPOSE 8012

# 启动命令
CMD ["java", "-Xms512m", "-Xmx2048m", "-jar", "/app/kkFileView.jar"]
