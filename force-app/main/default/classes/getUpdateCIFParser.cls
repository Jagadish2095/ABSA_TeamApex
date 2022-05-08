/**
* @description getUpdateCIFParser
               UpdateCIFParser a parser class for deserializing for UpdateCIF service response
* @author  Sharath Chandra : ABSA
* @version v1.0
* @since  2021-04-26
* @W-010965
*/
/**
 * @description getUpdateCIFParser
 */
public class getUpdateCIFParser {
	
    public String status;
    public Integer statusCode;
    public String message;
    
    /***
    * @method  getUpdateCIFParser
    * @description   getUpdateCIFParser
    **/
    public getUpdateCIFParser()
    {
        this.status = status;
        this.statusCode = statusCode;
        this.message = message;
    }
    
    /***
    * @description   ErrorMessageParameters
    **/
	public class ErrorMessageParameters {
        /***
        * @method  systemErrorText
        * @description   systemErrorText
        * @return String
        **/
		public String systemErrorText {get;set;} 
         /**
        * @method  messageEntryTable
        * @description   messageEntryTable
        * @return MessageEntryTable
        */
		public List<MessageEntryTable> messageEntryTable {get;set;} 
		/***
        * @method version
        * @description   version
        * @return String
        **/
		public String version {get;set;} 
        /***
        * @method numberUserErrors
        * @description   numberUserErrors
        * @return Integer
        **/
		public Integer numberUserErrors {get;set;} 
         /***
        * @method  numberUserMessages
        * @description   numberUserMessages
        * @return Integer
        **/
		public Integer numberUserMessages {get;set;}
        
        /***
        * @method  ErrorMessageParameters
        * @description   ErrorMessageParameters
        * @param parser 
        **/
		public ErrorMessageParameters(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'systemErrorText') {
							systemErrorText = parser.getText();
						} else if (text == 'messageEntryTable') {
							messageEntryTable = arrayOfMessageEntryTable(parser);
						} else if (text == 'version') {
							version = parser.getText();
						} else if (text == 'numberUserErrors') {
							numberUserErrors = parser.getIntegerValue();
						} else if (text == 'numberUserMessages') {
							numberUserMessages = parser.getIntegerValue();
						} else {
							System.debug(LoggingLevel.WARN, 'ErrorMessageParameters consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
 	/***
    * @description   OutputHeaders
    **/
	public class OutputHeaders {
         /***
        * @method  outputPayloadHeaders
        * @description   outputPayloadHeaders
        * @return OutputPayloadHeaders
        **/
		public OutputPayloadHeaders outputPayloadHeaders {get;set;} 

        /***
        * @method  OutputHeaders
        * @description   OutputHeaders
        * @param parser
        **/
		public OutputHeaders(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'outputPayloadHeaders') {
							outputPayloadHeaders = new OutputPayloadHeaders(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OutputHeaders consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
    /***
    * @description   OutputArea
    **/
	public class OutputArea {
         /***
        * @method  returnCode
        * @description   returnCode
        * @return Integer
        **/
		public Integer returnCode {get;set;} 
         /***
        * @method  clientCode
        * @description   clientCode
        * @return String
        **/
		public String clientCode {get;set;} 
         /***
        * @method  message
        * @description   message
        * @return String
        **/
		public String message {get;set;} 

        /***
        * @method  OutputArea
        * @description   OutputArea
        * @param parser
        **/
		public OutputArea(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'returnCode') {
							returnCode = parser.getIntegerValue();
						} else if (text == 'clientCode') {
							clientCode = parser.getText();
						} else if (text == 'message') {
							message = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OutputArea consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	/***
    * @method  outputHeaders
    * @description   outputHeaders
    * @return OutputHeaders
    **/
	public OutputHeaders outputHeaders {get;set;} 
    /***
    * @method  outputErrorMessage
    * @description   outputErrorMessage
    * @return OutputErrorMessage
    **/
	public OutputErrorMessage outputErrorMessage {get;set;} 
    /***
    * @method  CIupdClientAttestationV20Response
    * @description   CIupdClientAttestationV20Response
    * @return CIupdClientAttestationV20Response
    **/
	public CIupdClientAttestationV20Response CIupdClientAttestationV20Response {get;set;} 
    
    /***
    * @method  getUpdateCIFParser
    * @description   getUpdateCIFParser
    * @param parser
    **/
	public getUpdateCIFParser(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'outputHeaders') {
						outputHeaders = new OutputHeaders(parser);
					} else if (text == 'outputErrorMessage') {
						outputErrorMessage = new OutputErrorMessage(parser);
					} else if (text == 'CIupdClientAttestationV20Response') {
						CIupdClientAttestationV20Response = new CIupdClientAttestationV20Response(parser);
					} else {
						System.debug(LoggingLevel.WARN, 'UpdateCIFParser consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
    /***
    * @description   MessageEntryTable
    **/
	public class MessageEntryTable {
        /***
        * @method  messageText
        * @description   messageText
        * @return String
        **/
		public String messageText {get;set;} 
        /***
        * @method  messageErrorInd
        * @description   messageErrorInd
        * @return String
        **/
		public String messageErrorInd {get;set;} 
       /***
        * @method  messageClass
        * @description   messageClass
        * @return String
        **/
		public String messageClass {get;set;} 
        /***
        * @method  messageCode
        * @description   messageCode
        * @return String
        **/
		public String messageCode {get;set;} 
		
        /***
        * @method  MessageEntryTable
        * @description   MessageEntryTable
        * @param parser
        **/
		public MessageEntryTable(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'messageText') {
							messageText = parser.getText();
						} else if (text == 'messageErrorInd') {
							messageErrorInd = parser.getText();
						} else if (text == 'messageClass') {
							messageClass = parser.getText();
						} else if (text == 'messageCode') {
							messageCode = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'MessageEntryTable consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
    /***
    * @description   OutputPayloadHeaders
    **/
	public class OutputPayloadHeaders {
        /***
        * @method returnCode
        * @description   returnCode
        * @return Integer
        **/
		public Integer returnCode {get;set;} 
        /***
        * @method outputServiceVersion
        * @description   outputServiceVersion
        * @return String
        **/
		public String outputServiceVersion {get;set;} 
         /***
        * @method reasonCode
        * @description   reasonCode
        * @return Integer
        **/
		public Integer reasonCode {get;set;} 
         /***
        * @method version
        * @description   version
        * @return String
        **/
		public String version {get;set;} 
		
        /***
        * @method  OutputPayloadHeaders
        * @description   OutputPayloadHeaders
        * @param parser
        **/
		public OutputPayloadHeaders(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'returnCode') {
							returnCode = parser.getIntegerValue();
						} else if (text == 'outputServiceVersion') {
							outputServiceVersion = parser.getText();
						} else if (text == 'reasonCode') {
							reasonCode = parser.getIntegerValue();
						} else if (text == 'version') {
							version = parser.getText();
						} else {
							System.debug(LoggingLevel.WARN, 'OutputPayloadHeaders consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
    /***
    * @description   OutputErrorMessage
    **/
	public class OutputErrorMessage {
        /***
        * @method  CIupdClientAttestationV20Response
        * @description   CIupdClientAttestationV20Response
        * @return CIupdClientAttestationV20Response
        **/
		public ErrorMessageParameters errorMessageParameters {get;set;} 

        /***
        * @method  OutputErrorMessage
        * @description   OutputErrorMessage
        * @param parser
        **/
		public OutputErrorMessage(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'errorMessageParameters') {
							errorMessageParameters = new ErrorMessageParameters(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'OutputErrorMessage consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	/***
    * @description   OutputErrorMessage
    **/
    public class CIupdClientAttestationV20Response {
        /***
        * @method : outputArea
        * @description   outputArea
        * @return OutputArea
        **/
		public OutputArea outputArea {get;set;} 
		
        /***
        * @method  CIupdClientAttestationV20Response
        * @description   CIupdClientAttestationV20Response
        * @param parser
        **/
		public CIupdClientAttestationV20Response(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'outputArea') {
							outputArea = new OutputArea(parser);
						} else {
							System.debug(LoggingLevel.WARN, 'CIupdClientAttestationV20Response consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	/***
    * @method  parse
    * @description   parse
    * @param json
    * @return getUpdateCIFParser
    **/
	public static getUpdateCIFParser parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new getUpdateCIFParser(parser);
	}
    
	/***
    * @method  consumeObject
    * @description   consumeObject
    * @param parser
    **/
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
	
	/***
    * @method  arrayOfMessageEntryTable
    * @description   arrayOfMessageEntryTable
    * @param p
    * @return res
    **/
    private static List<MessageEntryTable> arrayOfMessageEntryTable(System.JSONParser p) {
        List<MessageEntryTable> res = new List<MessageEntryTable>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new MessageEntryTable(p));
        }
        return res;
    }



}