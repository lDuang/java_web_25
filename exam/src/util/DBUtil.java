package util;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Properties;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.dbcp2.BasicDataSource;

public class DBUtil {
    private static BasicDataSource dataSource;

    static {
        Properties propConfig = new Properties();
        try {
            InputStream in = DBUtil.class.getClassLoader().getResourceAsStream("db.properties");
            propConfig.load(in);

            String driver = propConfig.getProperty("driver");
            String url = propConfig.getProperty("url");
            String username = propConfig.getProperty("username");
            String password = propConfig.getProperty("password");
            int initSize = Integer.parseInt(propConfig.getProperty("initialSize"));
            int maxTotal = Integer.parseInt(propConfig.getProperty("maxActive"));
            int maxIdle = Integer.parseInt(propConfig.getProperty("maxIdle"));
            int minIdle = Integer.parseInt(propConfig.getProperty("minIdle"));
            int maxWait = Integer.parseInt(propConfig.getProperty("maxWait"));
            in.close();

            String envHost = System.getenv("DB_HOST");
            String envPort = System.getenv("DB_PORT");
            String envName = System.getenv("DB_NAME");
            String envUser = System.getenv("DB_USER");
            String envPassword = System.getenv("DB_PASSWORD");

            if (envHost != null && !envHost.isEmpty()) {
                String port = (envPort != null && !envPort.isEmpty()) ? envPort : "3306";
                String dbName = (envName != null && !envName.isEmpty()) ? envName : extractDbName(url);
                url = "jdbc:mysql://" + envHost + ":" + port + "/" + dbName
                + "?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
            }

            if (envUser != null && !envUser.isEmpty()) {
                username = envUser;
            }

            if (envPassword != null && !envPassword.isEmpty()) {
                password = envPassword;
            }

            dataSource = new BasicDataSource();

            dataSource.setDriverClassName(driver);
            dataSource.setUrl(url);
            dataSource.setUsername(username);
            dataSource.setPassword(password);
            dataSource.setInitialSize(initSize);
            dataSource.setMaxTotal(maxTotal);
            dataSource.setMaxIdle(maxIdle);
            dataSource.setMinIdle(minIdle);
            dataSource.setMaxWaitMillis(maxWait);

        } catch (IOException e) {
            e.printStackTrace();
            throw new RuntimeException("ʼӳʧ");

        }
    }

    private static String extractDbName(String url) {
        int slashIndex = url.lastIndexOf('/');
        if (slashIndex < 0 || slashIndex == url.length() - 1) {
            return "commentdb";
        }
        int questionIndex = url.indexOf('?', slashIndex);
        if (questionIndex < 0) {
            return url.substring(slashIndex + 1);
        }
        return url.substring(slashIndex + 1, questionIndex);
    }

    public static Connection getConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) throws Exception {
        System.out.println(getConnection());
//              closeConnection(getConnection());
    }

}