FROM tomcat:9.0.67-jdk8

WORKDIR /usr/local/tomcat

RUN rm -rf /usr/local/tomcat/webapps/ROOT

# Copy static resources and dependencies
COPY exam/WebContent/ webapps/ROOT/

# Compile Java sources into WEB-INF/classes
COPY exam/src/ /tmp/src/

RUN mkdir -p /tmp/classes \
 && javac \
       -cp "lib/servlet-api.jar:webapps/ROOT/WEB-INF/lib/*" \
       -d /tmp/classes \
       $(find /tmp/src -name "*.java") \
 && mkdir -p webapps/ROOT/WEB-INF/classes/ \
 && cp /tmp/src/db.properties /tmp/classes/ \
 && cp -r /tmp/classes/* webapps/ROOT/WEB-INF/classes/ \
 && rm -rf /tmp/src /tmp/classes

ENV DB_HOST=db \
    DB_PORT=3306 \
    DB_NAME=commentdb \
    DB_USER=root \
    DB_PASSWORD=root

EXPOSE 8080
CMD ["catalina.sh", "run"]