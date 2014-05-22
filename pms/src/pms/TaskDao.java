package pms;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class TaskDao {
	DbCon con;
	
	public TaskDao() {
		con = new DbCon();
	}
	
	public List<Task> getTasks(String pj) {
		List<Task> l = new ArrayList<Task>();
		
		Connection c = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		try {
			
			String sql = "select * from pms_tasks where use_yn = 'Y' and pj = '" + pj + "' order by convert(sort,  unsigned)";
			
			c = con.getConnection();
			stmt = c.createStatement();			
			rs = stmt.executeQuery(sql);
			
			while(rs.next()) {
				Task t = new Task();
				
				t.setId(rs.getInt("ID"));
				t.setName(rs.getString("NAME"));
				t.setCode(rs.getString("CODE"));
				t.setLevel(rs.getInt("LEVEL"));
				t.setStatus(rs.getString("STATUS"));				
				t.setStart(rs.getLong("START"));
				t.setDuration(rs.getInt("DURATION"));
				t.setEnd(rs.getLong("END"));
				t.setStartIsMilestone(rs.getInt("SIM") == 1);
				t.setEndIsMilestone(rs.getInt("EIM") == 1);
				t.setDepends(rs.getString("DEPENDS"));
				t.setDescription(rs.getString("DESCRIPTION"));
				t.setProgress(rs.getInt("PROGRESS"));
				t.setSort(rs.getString("SORT"));
				t.setAssigs(new ArrayList<Map<String, Object>>());
				
				l.add(t);				
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			con.Close(c, stmt, rs);
		}
		
		return l;
	}
	
	public Task getTask(String id) {
		
		Connection c = null;
		Statement stmt = null;
		ResultSet rs = null;
		
		Task t = new Task();
		
		try {
			
			String sql = "select * from pms_tasks where use_yn = 'Y' and id = "+ id;
			
			c = con.getConnection();
			stmt = c.createStatement();			
			rs = stmt.executeQuery(sql);			
			
			if(rs.next()) {				
				
				t.setId(rs.getInt("ID"));
				t.setName(rs.getString("NAME"));
				t.setCode(rs.getString("CODE"));
				t.setLevel(rs.getInt("LEVEL"));
				t.setStatus(rs.getString("STATUS"));				
				t.setStart(rs.getLong("START"));
				t.setDuration(rs.getInt("DURATION"));
				t.setEnd(rs.getLong("END"));
				t.setStartIsMilestone(rs.getInt("SIM") == 1);
				t.setEndIsMilestone(rs.getInt("EIM") == 1);
				t.setDepends(rs.getString("DEPENDS"));
				t.setDescription(rs.getString("DESCRIPTION"));
				t.setProgress(rs.getInt("PROGRESS"));
				t.setSort(rs.getString("SORT"));
				t.setAssigs(new ArrayList<Map<String, Object>>());
				t.setPj(rs.getString("pj"));
			}
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			con.Close(c, stmt, rs);
		}
		
		return t;
	}
	
	public void insertTask(Task task) {
		Connection c = null;
		PreparedStatement pstmt = null;
		
		try {
			
			// param : 14ea
			String sql = "insert into pms_tasks(name, code, level, status, start, duration, end, sim, eim, depends, description, progress, sort, pj) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";			
			
			c = con.getConnection();			
			pstmt = c.prepareStatement(sql);
			
			pstmt.setString(1, task.getName());
			pstmt.setString(2, task.getCode());
			pstmt.setInt(3, task.getLevel());
			pstmt.setString(4, task.getStatus());
			pstmt.setLong(5, task.getStart());
			pstmt.setInt(6, task.getDuration());
			pstmt.setLong(7, task.getEnd());
			pstmt.setString(8, task.getStartIsMilestone() ? "1" : "0");
			pstmt.setString(9, task.getEndIsMilestone() ? "1" : "0");
			pstmt.setString(10, task.getDepends());
			pstmt.setString(11, task.getDescription());
			pstmt.setInt(12, task.getProgress());
			pstmt.setString(13, task.getSort());
			pstmt.setString(14, task.getPj());
			
			pstmt.execute();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			con.Close(c, pstmt);
		}
	}
	
	public void updateTask(Task task) {
		Connection c = null;
		PreparedStatement pstmt = null;
		
		try {
			
			String sql = "update pms_tasks set name = ?, code = ?, level = ?, status = ?, start = ?, duration = ?, end = ?, sim = ?, eim = ?, depends = ?, description = ?, progress = ?, sort = ?, pj = ? where id = ?";
			
			c = con.getConnection();			
			pstmt = c.prepareStatement(sql);			
			
			pstmt.setString(1, task.getName());
			pstmt.setString(2, task.getCode());
			pstmt.setInt(3, task.getLevel());
			pstmt.setString(4, task.getStatus());
			pstmt.setLong(5, task.getStart());
			pstmt.setInt(6, task.getDuration());
			pstmt.setLong(7, task.getEnd());
			pstmt.setString(8, task.getStartIsMilestone() ? "1" : "0");
			pstmt.setString(9, task.getEndIsMilestone() ? "1" : "0");
			pstmt.setString(10, task.getDepends());
			pstmt.setString(11, task.getDescription());
			pstmt.setInt(12, task.getProgress());
			pstmt.setString(13, task.getSort());
			pstmt.setString(14, task.getPj());
			pstmt.setInt(15, task.getId());
			
			pstmt.execute();
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			con.Close(c, pstmt);
		}
	}
	
	
	public void deleteTask(String id) {
		Connection c = null;
		Statement stmt = null;
		
		try {
			
			String sql = "delete from pms_tasks where id = '" + id + "'";
			
			c = con.getConnection();
			stmt = c.createStatement();	
			stmt.execute(sql);
			
		} catch(Exception e) {
			e.printStackTrace();
		} finally {
			con.Close(c, stmt);
		}
		
	}
}
