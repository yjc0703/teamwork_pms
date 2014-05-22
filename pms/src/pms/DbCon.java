package pms;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ResourceBundle;

import org.apache.commons.dbcp.BasicDataSource;

public class DbCon {
	private static BasicDataSource ds = null;

	static {
		
		ResourceBundle rb = ResourceBundle.getBundle("db");
		
		String driver = "com.mysql.jdbc.Driver";
		String url = "jdbc:mysql://" + rb.getString("url") + ":" + rb.getString("port") + "/" + rb.getString("db");
		String user = rb.getString("user");
		String pass = rb.getString("pass");

		try {
			ds = new BasicDataSource();

			ds.setDriverClassName(driver);
			ds.setUrl(url);
			ds.setUsername(user);
			ds.setPassword(pass);

			ds.setMaxIdle(10);
			ds.setMaxActive(40);
			ds.setMaxWait(1000);
			ds.setValidationQuery("select 1/1");
			ds.setValidationQueryTimeout(1);
			ds.setTestOnBorrow(true);
		} catch (Exception e) {
			System.out.println("error creat datasource");
			e.printStackTrace();
		} finally {
		}
	}

	public Connection getConnection() throws SQLException {
		return ds.getConnection();
	}

	public void Close(Connection c, Statement s, ResultSet r) {
		if (r != null) {
			try {
				r.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		try {
			s.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

		try {
			c.close();
		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	public void Close(Connection c, Statement s) {
		Close(c, s, null);
	}
}
