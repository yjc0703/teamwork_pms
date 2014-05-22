package pms;

import java.util.List;
import java.util.Map;

public class TaskService {
	private TaskDao taskDao;
	public TaskService() {
		taskDao = new TaskDao();
	}
	
	public List<Task> getTasks(String pj) {
		return taskDao.getTasks(pj);
	}
	
	public void deleteTask(String id) {
		taskDao.deleteTask(id);
	}
	
	public void setTask(Map m) {
		
		Task newTask = MapToTask(m);
		
		if(!Util.isIntegerRegex(Util.nvl(m.get("id")))) {
			taskDao.insertTask(newTask);
		} else {
			Task orgTask = taskDao.getTask(Util.nvl(m.get("id")));			
			if(!orgTask.equals(newTask)) {
				taskDao.updateTask(newTask);
			}	
		}
	}
	
	public Task MapToTask(Map m) {
		Task t = new Task();
		
		if(Util.isIntegerRegex(Util.nvl(m.get("id")))) {
			t.setId(Util.parseInt(Util.nvl(m.get("id"))));
		}
		
		t.setName(Util.nvl(m.get("name")));
		t.setCode(Util.nvl(m.get("code")));
		t.setLevel(Util.parseInt(Util.nvl(m.get("level"))));
		t.setStatus(Util.nvl(m.get("status")));
		t.setStart(Util.parseLong(Util.nvl(m.get("start"))));
		t.setDuration(Util.parseInt(Util.nvl(m.get("duration"))));
		t.setEnd(Util.parseLong(Util.nvl(m.get("end"))));
		t.setStartIsMilestone(Util.nvl(m.get("startIsMilestone")).equals("1"));
		t.setEndIsMilestone(Util.nvl(m.get("endIsMilestone")).equals("1"));
		t.setDepends(Util.nvl(m.get("depends")));
		t.setDescription(Util.nvl(m.get("description")));
		t.setProgress(Util.parseInt(Util.nvl(m.get("progress"))));
		t.setSort(Util.nvl(m.get("sort")));
		t.setPj(Util.nvl(m.get("pj")));
				
		return t;
	}
	
}
