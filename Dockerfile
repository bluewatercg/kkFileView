FROM bluewatercg/kkfileview

# 安装 LibreOffice
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libreoffice-nogui && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# 设置 OFFICE_HOME 环境变量
ENV OFFICE_HOME=/usr/lib/libreoffice/program

# 将构建好的 kkFileView 覆盖到 /opt/ 目录
ADD server/target/kkFileView-*.tar.gz /opt/

# 配置 kkFileView
ENV KKFILEVIEW_BIN_FOLDER=/opt/kkFileView-4.4.0/bin

# 设置启动命令，确保使用 OFFICE_HOME 环境变量
ENTRYPOINT ["java","-Dfile.encoding=UTF-8","-Dspring.config.location=/opt/kkFileView-4.4.0/config/application.properties","-Doffice.home=$OFFICE_HOME","-jar","/opt/kkFileView-4.4.0/bin/kkFileView-4.4.0.jar"]
