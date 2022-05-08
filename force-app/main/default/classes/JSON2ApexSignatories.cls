/**
* This class is used for parsing of the JSON structure for the signatories
* Many thanks to http://json2apex.herokuapp.com/
* @author Vladimir Panajic
* @created 2019-08-29
*/
public class JSON2ApexSignatories {
    public String Id {get;set;}
    public String Title {get;set;}
    public String Last_Name {get;set;}
    public String Mobile_Phone {get;set;}
    public String Email {get;set;}
    public String Order {get;set;}
    public String Role {get;set;}
	public String Method {get;set;}
    public String Document_Name {get;set;}
    public String Document_Type {get;set;}
	
	public JSON2ApexSignatories(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'Title') {
                        Title = parser.getText();
                    } else if (text == 'Last_Name') {
                        Last_Name = parser.getText();
                    } else if (text == 'Mobile_Phone') {
                        Mobile_Phone = parser.getText();
                    } else if (text == 'Email') {
                        Email = parser.getText();
                    } else if (text == 'Order') {
                        Order = parser.getText();
                    } else if (text == 'Role') {
                        Role = parser.getText();
                    } else if (text == 'Method') {
						Method = parser.getText();
					} else if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'Document_Name') {
						Document_Name = parser.getText();
					} else if (text == 'Document_Type') {
						Document_Type = parser.getText();
					} else {
						System.debug(LoggingLevel.WARN, 'JSON2Apex consuming unrecognized property: ' + text);
						consumeObject(parser);
					}
				}
			}
		}
	}
    
	public static List<JSON2ApexSignatories> parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return arrayOfJSON2Apex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<JSON2ApexSignatories> arrayOfJSON2Apex(System.JSONParser p) {
        List<JSON2ApexSignatories> res = new List<JSON2ApexSignatories>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new JSON2ApexSignatories(p));
        }
        return res;
    }
}