package pms;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Util {
	public static String nvl(Object o) {
		return o == null ? "" : o.toString();
	}
	
	public static int parseInt(String s) {
		return isIntegerRegex(s) ? Integer.parseInt(s) : 0;
	}
	
	public static long parseLong(String s) {
		return isIntegerRegex(s) ? Long.parseLong(s) : 0;
	}
	
	public static boolean isIntegerRegex(String s) {
        return s.matches("^[0-9]+$");
    }
	
	public static List<Map<String, Object>> objectListToMapList(Object objectList) {
		List<Map<String, Object>> ml = new ArrayList<Map<String,Object>>();
		
		List<Object> ol = (List<Object>)objectList;
		
		for(int l = 0; l < ol.size(); l++)
		{
			Object o = ol.get(l);
		
			Method[] methods = o.getClass().getMethods();
			Map<String, Object> map = new HashMap<String, Object>();
			
			for(int i = 0; i < methods.length; i++) {
				Method m = methods[i];
				if(m.getName().startsWith("get") && !m.getName().equals("getClass")) {
					
					String name = m.getName().substring(3).substring(0, 1).toLowerCase().concat(m.getName().substring(4));					
					Object ret = null;
					try {
						ret = m.invoke(o, null);
						//ret = m.invoke(o, new Object(){});
					} catch (IllegalArgumentException e) {
						e.printStackTrace();
					} catch (IllegalAccessException e) {
						e.printStackTrace();
					} catch (InvocationTargetException e) {
						e.printStackTrace();
					}
					
					map.put(name, ret);
				}				
			}
			ml.add(map);			
		}
		
		return ml;
	}
}
