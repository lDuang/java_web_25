FROM tomcat:9-jdk11

RUN rm -rf /usr/local/tomcat/webapps/ROOT

COPY exam/WebContent/ /usr/local/tomcat/webapps/ROOT/
COPY exam/build/classes/ /usr/local/tomcat/webapps/ROOT/WEB-INF/classes/

ENV DB_HOST=db \
    DB_PORT=3306 \
    DB_NAME=commentdb \
    DB_USER=root \
    DB_PASSWORD=root

EXPOSE 8080
CMD ["catalina.sh", "run"]
