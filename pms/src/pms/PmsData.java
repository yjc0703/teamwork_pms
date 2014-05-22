package pms;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class PmsData extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1356595936517558873L;

	public PmsData() {
	}
	
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		ProjectService ps = new ProjectService(Util.nvl(req.getParameter("pj")));
		
		resp.setContentType("text/html; charset=UTF-8");
		PrintWriter out = resp.getWriter();
		
		JSONObject obj = new JSONObject();
		obj.put("ok", true);
		obj.put("project", ps.getProject());
		
		obj.writeJSONString(out);
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		
		ProjectService ps = new ProjectService(Util.nvl(req.getParameter("pj")));
		
		// 저장
		String strPrj = Util.nvl(req.getParameter("prj"));
		JSONParser parser = new JSONParser();
		
		try {
			
			ps.SetProject((Map<String, Object>) parser.parse(strPrj));
			
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		System.out.println();
		
		
		// 변경내용 반영 후 조회로	
		this.doGet(req, resp);
		
	}

}
