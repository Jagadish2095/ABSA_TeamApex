@isTest
public class ECM_QueryResultParserTest {
	
	@isTest
	public static void shouldParseArrayDocuments() {
		String content = '{"QueryResult": {"Status": "Ok", "Details": "Some details"}, "Documents": {"Document":[{"ItemType": "Will", "PID": "1234567890"}]}}';
		ECM_QueryResult result = new ECM_QueryResultParser().parse(content);
		System.assert(result != null);
	}
	
	@isTest
	public static void shouldParseObjectDocument() {
		String content = '{"QueryResult": {"Status": "Ok", "Details": "Some details"}, "Documents": {"Document":{"ItemType": "Will", "PID": "1234567890"}}}';
		ECM_QueryResult result = new ECM_QueryResultParser().parse(content);
		System.assert(result != null);
	}

}