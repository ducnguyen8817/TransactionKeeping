<%@ page import="java.util.*, java.lang.*, java.text.*, java.lang.reflect.*, java.io.*"
%><%
	String transaction_type 	= nvl(request.getParameter("transaction_type"));
	String description 			= nvl(request.getParameter("description"));
	String date					= nvl(request.getParameter("date"));
	String payment_type 		= nvl(request.getParameter("payment_type"));
	int quantity				= nvl(request.getParameter("quantity"),0);
	double price 				= nvl(request.getParameter("price"),0.0);
	
	try {
		Transaction transaction = new Transaction();
		
		transaction.transaction_type = transaction_type;
		transaction.description = description;
		transaction.date = date;
		transaction.payment_type = payment_type;
		transaction.quantity = quantity;
		transaction.price = price;
		
		out.println(request.getRequestURI());
		out.println(request.getProtocol());
		out.println(request.getPathInfo());
		out.println(request.getRemoteAddr());
		out.println(request.getServletPath());
		
		
		
		
	} catch (Exception e){
		throw e;
	}
	
%>
<%!
	public class Transaction{
		Transaction(){}
		public String transaction_type = null;;
		public String description = null;;
		public String date = null;
		public String payment_type = null;;
		public int quantity = 0;
		public double price = 0.0;
	}
	public String nvl(String value){
		return ( value == null || value.length()== 0 ) ? "" : value;
	}
	public int nvl(String value, int number){
		return (value ==null || Integer.parseInt(value)<0) ? 0 : Integer.parseInt(value);
	}
	
	public double nvl(String value, double number){
		return (value == null || Double.parseDouble(value)<0) ? 0.0 : Double.parseDouble(value);
	}
	public void writeFile(HttpServletRequest request, String name, String content) throws Exception{
		try {
		
			String path = request.getRealPath("/");
			File myFile = new File(path+"Transaction\\"+name+".txt");
			FileWriter fileWriter = new FileWriter(myFile,true);
			BufferedWriter bufferedWriter = new BufferedWriter(fileWriter);
			bufferedWriter.write(content);
			bufferedWriter.newLine();
			bufferedWriter.close();
		
		} catch (Exception e){
			throw e;
		}
	}
	public void createFile(HttpServletRequest request, String name) throws Exception{
		try {
		
			String path = request.getRealPath("/");
			File myFile = new File(path+"Transaction\\"+name+".txt");
			myFile.createNewFile();
			
		} catch (Exception e){
			throw e;
		}
	}
	
	public String toJson(Object obj) {
        boolean isClassArray = false;
        StringBuffer arrBuffer = new StringBuffer();
        StringBuffer buffer = new StringBuffer();
        Object arrayElement = null;
        int    arrayLength  = 0;

        if ( obj == null ) return ("");

        // If this is an array we need to handle each element individually
        if ( obj.getClass().isArray() ) {
            arrayLength = java.lang.reflect.Array.getLength(obj);
            buffer.append("[ ");
            if ( arrayLength > 0 ) {
                arrayElement = java.lang.reflect.Array.get(obj, 0);
                buffer.append(toJson(arrayElement));
                for ( int j=1; j < arrayLength; j++ ) {
                    buffer.append(",\n");
                    arrayElement = java.lang.reflect.Array.get(obj, j);
                    buffer.append(toJson(arrayElement));
                }
            }
            buffer.append(" ]");
            return buffer.toString();
        }


        Field [] fields = obj.getClass().getDeclaredFields();
        for ( int i=0; i < fields.length; i++ ) {
            if ( fields[i].getModifiers() != Modifier.PUBLIC ) continue;

            Class  classType  = fields[i].getType();

            String fieldName  = fields[i].getName();
            String fieldValue = "";

            try {
                if ( fields[i].get(obj) != null ) {
                    if ( fields[i].getType().equals(java.lang.Integer.TYPE) ) {
                        fieldValue = ""+fields[i].getInt(obj);
                    } else if ( fields[i].getType().equals(java.lang.Boolean.TYPE) ) {
                        fieldValue = ""+fields[i].getBoolean(obj);
                    } else if ( fields[i].getType().equals(java.lang.Long.TYPE) ) {
                        fieldValue = ""+fields[i].getLong(obj);
                    } else if ( fields[i].getType().equals(java.lang.Double.TYPE) ) {
                        fieldValue = ""+fields[i].getDouble(obj);
                    } else if ( fields[i].getType().getName().equals("java.lang.String") ) {
                        fieldValue = "\"" + nvl((String)fields[i].get(obj)).replaceAll("\\\"","\\\\\"") + "\"";
                    } else {
                        if ( fields[i].get(obj).getClass().isArray() ) {
                            arrBuffer.setLength(0);
                            isClassArray = fields[i].getType().toString().startsWith("class [L")
                                    && ! classType.getName().equals("[Ljava.lang.String;");
                            arrayLength = java.lang.reflect.Array.getLength(fields[i].get(obj));
                            for (int j = 0; j < arrayLength; j++) {
                                arrayElement = java.lang.reflect.Array.get(fields[i].get(obj), j);
                                arrBuffer.append("\n { \"" + fieldName.replaceAll("s$","") + "\": ");
                                arrBuffer.append((isClassArray ? "\n" + toJson(arrayElement) : "\"" + arrayElement + "\""));
                                arrBuffer.append(" } ");
                                if ( j < arrayLength-1 ) arrBuffer.append(",");
                                arrBuffer.append(" ");
                            }
                            fieldValue = "[ " + arrBuffer.toString() + " ]\n";
                            arrBuffer.setLength(0);
                        } else {
                            // We'll assume this is a simple Class
                            if ( fields[i].get(obj) != this ) fieldValue = "\n" + toJson(fields[i].get(obj));
                        }
                    }
                }
            } catch (Exception e) {
                fieldValue = e.toString();
            }

            if ( buffer.length() > 0 ) buffer.append(", ");
            buffer.append( "\"" + fieldName + "\": " + (fieldValue.length() == 0 ? "\"\"" : fieldValue));
        }

        return "{ " + buffer.toString() + " }";
    }
	
%>