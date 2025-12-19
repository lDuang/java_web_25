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
- `db`：基于官方 MySQL 8.0 镜像，加载 `exam.sql` 初始化数据；默认数据库名为 `commentdb`，root 账户密码均为 `root`，并通过 healthcheck 确保启动完毕。
- `web`：基于 `tomcat:9-jdk11` 构建，自动将 `exam/WebContent` 部署为 ROOT，并在镜像构建过程中编译 `exam/src` 下的 Servlet/DAO/工具类放入 `WEB-INF/classes`。数据库连接参数可通过环境变量 `DB_HOST`、`DB_PORT`、`DB_NAME`、`DB_USER`、`DB_PASSWORD` 覆盖，默认指向 compose 内的 MySQL 容器。

启动后可通过浏览器访问 `http://localhost:8080/add.html` 或 `http://localhost:8080/list.jsp` 进行验证。

## CI/CD 镜像推送

仓库内提供了 GitHub Actions 工作流 `.github/workflows/docker-publish.yml`，在推送到 `main`/`master`/`work` 分支或手动触发时，会基于项目构建 Docker 镜像并推送至 `ghcr.io`。请在仓库 Secrets 中配置：
- `REGISTRY_USERNAME`
- `REGISTRY_PASSWORD`

镜像标签默认包含 `latest` 与提交 SHA，对应路径为 `ghcr.io/<owner>/java-web-exam`。
