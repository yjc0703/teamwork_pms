package pms;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ProjectService {
	private TaskService taskService;
	private String pj = "default";
	

	public ProjectService(String pj) {
		taskService = new TaskService();
		this.pj = pj;
	}
	
	public Map<String, Object> getProject() {

		Map<String, Object> m = new HashMap<String, Object>();

		m.put("tasks", Util.objectListToMapList(taskService.getTasks(this.pj)));
		m.put("resources", new ArrayList<HashMap<String, Object>>());
		m.put("roles", new ArrayList<HashMap<String, Object>>());
		m.put("canWrite", true);
		m.put("canWriteOnParent", true);
		m.put("selectedRow", 0);
		m.put("deletedTaskIds", new ArrayList<Integer>());

		return m;
	}

	public void SetProject(Map<String, Object> prjMap) {
		List deleteIds = (List) prjMap.get("deletedTaskIds");
		List tasks = (List) prjMap.get("tasks");

		for (int i = 0; i < deleteIds.size(); i++) {
			taskService.deleteTask(deleteIds.get(i).toString());
		}

		int beforeLevel = -1;
		int[] seq = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
		for (int i = 0; i < tasks.size(); i++) {
			Map m = (Map) tasks.get(i);
			
			int lev = Util.parseInt(Util.nvl(m.get("level")));
			
			if(beforeLevel != lev) {
				seq = resetArr(seq, lev + 1);
				beforeLevel = lev;
			}
			
			seq[lev]++;

			m.put("sort", concatArr(seq));
			m.put("pj", this.pj);
			taskService.setTask(m);
		} 

	}
	
	public int[] resetArr(int[] arr, int idx) {
		
		for(int i = 0; i < arr.length; i++) {
			if(i >= idx) arr[i] = 0;
		}
		
		return arr;
	}
	
	public String concatArr(int[] arr) {
		String str = "";
		for(int i = 0; i < arr.length; i++) {
			String num = Integer.toString(arr[i]);
			num = num.length() < 2 ? "0" + num : num;
			str = str + num;
		}		
		return str;
	}
	

}
