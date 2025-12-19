package dao;

import java.util.List;

import forum.Message;

public interface MessageDao {

	int saveMessage(Message msg);

	List<Message> list();

}
