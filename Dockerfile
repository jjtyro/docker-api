######## 构建 ########
FROM --platform=${BUILDPLATFORM:-amd64} node:12.18.2 as builder

#COPY ./sources.list /etc/apt/sources.list

#RUN rm -fr /var/lib/apt/lists/*

# 安装构建工具
RUN apt-get update 
RUN apt-get install -y ca-certificates curl git python make gcc g++ zlib1g-dev autoconf automake file nasm && update-ca-certificates && rm -fr /var/lib/apt/lists/*

# YApi 版本
ENV YAPI_VERSION=local-changes

WORKDIR /yapi/vendors

# 拷贝源码
COPY ./vendors/ ./ 

#安装
RUN npm install --production --registry https://registry.npm.taobao.org


######## 镜像 ########
FROM node:12.18.2-alpine3.11

WORKDIR /yapi

COPY --from=builder /yapi .

EXPOSE 3000

CMD ["node", "/yapi/vendors/server/app.js"]
