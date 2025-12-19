package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import forum.Message;
import util.DBUtil;

public class MessageDaoImpl implements MessageDao{

	@Override
	public int saveMessage(Message msg) {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		Connection con =null;
		PreparedStatement pst = null;
		int result = 0;
		
		try {
			//1.从数据库连接池获取一个连接
			con = DBUtil.getConnection();
			
			String sql = "insert into comment(user,score,interest,comment,date ) " +
					"values(?,?,?,?,?)";
			pst = con.prepareStatement(sql);			
			pst.setString(1, msg.getUser());
			pst.setInt(2, msg.getScore());
			pst.setString(3, msg.getInterest());
			pst.setString(4,msg.getComment());
			pst.setDate(5,new java.sql.Date(msg.getDate().getTime()));
			
			result = pst.executeUpdate();
		}catch (SQLException e) {			
			e.printStackTrace();
		}finally{
			if(pst!=null)  {try{pst.close();} catch(Exception e){}}
			if(con!=null) {try{con.close();} catch(Exception e){}}
		}	
		return result;
	}

	@Override
	public List<Message> list() {
		// TODO Auto-generated method stub
		Connection con =null;
		Statement st = null;
		ResultSet rs = null;
		
		try {			
			//1.从数据库连接池获取一个连接
			con = DBUtil.getConnection();
			//2.获取Statement对象
			st = con.createStatement();
			String sql = "select * from comment";			
			rs = st.executeQuery(sql);
			
			//3.处理查询结果
			List<Message> list = new ArrayList<Message>();
			while(rs.next()){
				Message msg = new Message();
				
				msg.setId(rs.getInt("id"));
				msg.setUser(rs.getString("user"));
				msg.setScore(rs.getInt("score"));				
				msg.setInterest(rs.getString("interest"));	
				msg.setComment(rs.getString("comment"));		
				msg.setDate(rs.getDate("date"));	
				list.add(msg);
			}		
			return list;
		}catch (SQLException e) {
			e.printStackTrace();
		}finally{
			if(rs!=null)  {try{rs.close();} catch(Exception e){}}
			if(st!=null)  {try{st.close();} catch(Exception e){}}
			if(con!=null) {try{con.close();} catch(Exception e){}}
		}
		// 返回空列表而不是 null，避免调用方 NPE
		return new ArrayList<Message>();
	}

}
