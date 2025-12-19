# Java Web Exam

该项目提供了一个基于 Tomcat 的简单留言板示例，并附带 MySQL 初始化脚本 `exam.sql`。

## 一键启动

确保本机安装 Docker 与 Docker Compose，然后在仓库根目录运行：

```bash
docker-compose up -d --build
```

默认会在本机开放：
- 应用访问端口：`http://localhost:8080`
- 数据库端口：`3306`

Compose 会启动以下服务：
- `db`：基于官方 MySQL 镜像，加载 `exam.sql` 初始化数据；默认数据库名为 `commentdb`，root 账户密码均为 `root`。
- `web`：基于 `tomcat:9-jdk11` 构建，自动将 `exam/WebContent` 和已编译的 `build/classes` 部署到 `webapps/ROOT`，并通过环境变量 `DB_HOST`、`DB_USER`、`DB_PASSWORD` 等覆盖数据库连接。

完成后可通过浏览器访问主页进行验证。
