package pms;

import java.util.List;
import java.util.Map;

public class Task {
	private int id;
	private String name;
	private String code;
	private int level;
	private String status;
	private long start;
	private int duration;
	private long end;
	private boolean startIsMilestone;
	private boolean endIsMilestone;
	private String depends;
	private String description;
	private int progress;
	private String sort;
	private List<Map<String, Object>> assigs;
	private String pj;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public int getLevel() {
		return level;
	}

	public void setLevel(int level) {
		this.level = level;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public long getStart() {
		return start;
	}

	public void setStart(long start) {
		this.start = start;
	}

	public int getDuration() {
		return duration;
	}

	public void setDuration(int duration) {
		this.duration = duration;
	}

	public long getEnd() {
		return end;
	}

	public void setEnd(long end) {
		this.end = end;
	}

	public boolean getStartIsMilestone() {
		return startIsMilestone;
	}

	public void setStartIsMilestone(boolean startIsMilestone) {
		this.startIsMilestone = startIsMilestone;
	}

	public boolean getEndIsMilestone() {
		return endIsMilestone;
	}

	public void setEndIsMilestone(boolean endIsMilestone) {
		this.endIsMilestone = endIsMilestone;
	}

	public String getDepends() {
		return depends;
	}

	public void setDepends(String depends) {
		this.depends = depends;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getProgress() {
		return progress;
	}

	public void setProgress(int progress) {
		this.progress = progress;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public List<Map<String, Object>> getAssigs() {
		return assigs;
	}

	public void setAssigs(List<Map<String, Object>> assigs) {
		this.assigs = assigs;
	}
	
	public String getPj() {
		return this.pj;
	}
	
	public void setPj(String pj) {
		this.pj = pj;
	}

	@Override
	public boolean equals(Object obj) {

		Task t = (Task) obj;
		
		return this.id == t.id && this.name.equals(t.name) && this.code.equals(t.code)
				&& this.level == t.level && this.status.equals(t.status)
				&& this.start == t.start && this.duration == t.duration
				&& this.end == t.end
				&& this.startIsMilestone == t.startIsMilestone
				&& this.endIsMilestone == t.endIsMilestone
				&& this.depends.equals(t.depends)
				&& this.description.equals(t.description)
				&& this.progress == t.progress && this.sort.equals(t.sort)
				&& this.pj.equals(t.getPj());
	}
	
	@Override
	public String toString() {
		return "id : " + Integer.toString(this.id);
	}
}
