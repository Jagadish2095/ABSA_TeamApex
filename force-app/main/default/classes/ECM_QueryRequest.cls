public class ECM_QueryRequest {
    
    public QueryRequest QueryRequest { get; set; }
    
    public class QueryRequest {
        public String Token { get; set; }
    	public String Query { get; set; }
    }
}