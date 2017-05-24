<%@ page import="java.util.*,java.io.*,java.lang.*,java.text.*, java.lang.reflect.*"
%><%

	try {
		String from = request.getParameter("from");
		String to = request.getParameter("to");
		SimpleDateFormat sm = new SimpleDateFormat("yyyy-MM-dd");
		List<String>data = data = new ArrayList<String>();
		String path = (request.getRealPath("/")+"Transaction\\");
		
		File transaction_folder = new File(request.getRealPath("/")+"Transaction");
		for(File myfile : transaction_folder.listFiles()){
			int pos = myfile.getName().lastIndexOf(".");
			String fileName = myfile.getName().substring(0,pos);
			if(sm.parse(from).compareTo(sm.parse(fileName))<=0 && sm.parse(to).compareTo(sm.parse(fileName))>=0){
				String fullPath = path+fileName+".txt";
				readFile(fullPath,data);
			}
			
		}
		
			out.println(data);
		
	} catch (Exception e){
		out.println(e.toString());
	}
%><%!
	public List<String> readFile(String path, List<String> data) throws Exception{
		BufferedReader br = null;
		try {
			String currentLine;
			br = new BufferedReader(new FileReader(path));
			while((currentLine = br.readLine())!=null ){
				data.add(currentLine.trim());
			}
		
		} catch (Exception e){
			throw e;
		}
		
		return data;
	}
%>
