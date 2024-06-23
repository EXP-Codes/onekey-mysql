# onekey-mysql

> 一键 注册/反注册/启动/停止 mysql 脚本


## 0x00 前言

由于 Mysql 一直都有着极为严格的登录权限校验、以致不少同学都会被卡在初始化的地方，极让人抓狂。

在 [Mysql 官网下载](https://dev.mysql.com/downloads/mysql/) 绿色版的 zip 不过是想解压即用，但 Mysql 说不准。

你必须先处理各种弯弯绕绕的无关问题：

- 写配置项意义不明的配置文件： Mysql8 甚至不再提供模板
- 找到 root 用户的密码： Mysql8 竟然是随机生成的还藏起来
- 找到密码你还不一定能登录，你一定不陌生： `ERROR 1130 (HY000) Host is not allowed to connect to this MySQL server`
- 登录后还要修改 root 密码、修改权限
- 都做完后发现客户端还是无法连接： Mysql8 对密码做了加密
- ...

很多时候只是想和现有的 Mysql 独立想部署一个简单测试库进行验证，都要处理这么多工序，就很让人烦躁。

针对这些痛点，我做了 4 个开箱即用的一键脚本


## 0x10 脚本简介

以下脚本需要确保 Mysql 的**解压路径为纯英文**，并且使用**管理员权限**运行：

| 脚本 | 说明 | 关键词 |
|:---:|:---|:---:|
| [_svcname](./win/_svcname) | Mysql 服务名称，被所有脚本读取 | 服务名称 |
| [01_register.bat](./win/01_register.bat) | Mysql 服务注册脚本，用于初始化或迁移位置 | 初始化，迁移 |
| [my.tpl.ini](./win/my.tpl.ini) | Mysql 配置文件模板，配合服务注册脚本使用 | 配置模板 |
| [02_start.bat](./win/02_start.bat) | Mysql 服务启动脚本 | 启动 |
| [03_stop.bat](./win/03_stop.bat) | Mysql 服务停止脚本 | 停止 |
| [04_unregister.bat](./win/04_unregister.bat) | Mysql 服务反注册脚本，用于迁移位置 | 迁移 |



## 0x20 使用方式

### 0x21 安装

1. 从 [官网下载](https://dev.mysql.com/downloads/mysql/) Mysql 的 zip 压缩包，解压到**纯英文路径** 
2. 把 [win](./win/) 目录下所有文件复制到 Mysql 的解压后的根目录
3. 执行 [`01_register.bat`](./win/01_register.bat) 脚本初始化，过程中有两次交互：
    - 选择数据库编码： UTF-8（默认），GBK（简中），BIG5（繁中），latin1（英文）
    - 设置 root 用户密码
4. 完成后会生成：
    - my.ini 配置文件
    - data 数据存储目录

## 0x22 启停

- 启动脚本： [`02_start.bat`](./win/02_start.bat)
- 停止脚本： [`03_stop.bat`](./win/03_stop.bat)


## 0x23 迁移

如果要迁移 Mysql 到别的位置，依次执行：

1. 停止并反注册服务： [`04_unregister.bat`](./win/04_unregister.bat)
2. 移动整个 Mysql 到新位置
3. 执行 [`01_register.bat`](./win/01_register.bat) 脚本重新注册：
    - 此时因为检测到 data 目录已存在，并不会重新初始化
    - 但是会自动备份 my.ini 配置文件，然后根据新位置重新生成一个



