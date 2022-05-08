/**
 * A custom JSON parser to handle ECM query responses.
 */
public class ECM_QueryResultParser implements RestClientUtils.ResultParser {
	
	public ECM_QueryResult parse(String content) {
		ECM_QueryResult result = new ECM_QueryResult();
		JSONParser parser = JSON.createParser(content);
		System.JSONToken t = null;
		while ((t = parser.nextToken()) != null) {
		    if (parser.getCurrentName() == 'QueryResult') {
		        parser.nextToken();
		        ECM_QueryResult.QueryResult eqr = (ECM_QueryResult.QueryResult) parser.readValueAs(ECM_QueryResult.QueryResult.class);
				result.QueryResult = eqr;
		    }
		    if (parser.getCurrentName() == 'Document') {
		        ECM_QueryResult.Documents docs = new ECM_QueryResult.Documents();
		        JSONToken t2 = parser.nextToken();
		        if (t2 == JSONToken.START_ARRAY) {
		            //map to list of documents
		            List<ECM_QueryResult.Document> docList = (List<ECM_QueryResult.Document>) parser.readValueAs(List<ECM_QueryResult.Document>.class);    
		            docs.document = docList;
		        } else if (t2 == JSONToken.START_OBJECT) {
		            //map to a single document
		            ECM_QueryResult.Document doc = (ECM_QueryResult.Document) parser.readValueAs(ECM_QueryResult.Document.class);
		            docs.document = new List<ECM_QueryResult.Document>();
		            docs.document.add(doc);
		        } else {
		            //we cant deal with this
		        }
		        result.Documents = docs;
		        //break;
		    }
		}
		return result;
	}
}