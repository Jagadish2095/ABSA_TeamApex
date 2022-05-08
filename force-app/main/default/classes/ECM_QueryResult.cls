public class ECM_QueryResult {
    
    public QueryResult QueryResult;
    public Documents Documents;
    
    public static ECM_QueryResult getExample() {
        ECM_QueryResult example = new ECM_QueryResult();
        example.QueryResult  = new QueryResult().getExample();
        example.Documents = new Documents().getExample();
        return example;
    }
    
    public class QueryResult {
        public String Status { get; set; }
        public String Details { get; set; }
        
        public QueryResult getExample() {
            QueryResult example = new QueryResult();
            example.Status = 'Ok';
            example.Details = 'Ok';
            return example;
        }
    }
    
    public class Documents {
        public List<Document> document { get; set; }      
        
        public Documents getExample() {
            Documents example = new Documents();
            example.document = new List<Document>();
            example.document.add(new Document().getExample());
            return example;
        }
    }
    
    public class Document {
        public String ItemType { get; set; }
        public String PID { get; set; }
        public String CreationDate { get; set;}
        public String LastModifiedDate { get; set;}
        public String Creator { get; set; }
        public Fields fields { get; set; }
        
        public Document getExample() {
            Document example = new Document();
            example.ItemType = 'Will';
            example.PID = '28372837-398493-sjkdjskd';
            example.CreationDate = '10/03/2019';
            example.LastModifiedDate = '10/03/2019';
            example.Creator = 'ABMC863';
            example.Fields = new Fields();
            example.Fields.field = new List<Field>();
            Field f = new Field();
            f.Name = 'WillNo';
            f.Value = '123456';
            example.Fields.field.add(f);
            return example;
        }
        
        public String getField(String name) {
        	if (fields != null && fields.field != null) {
        		for (Field f : fields.field) {
        			if (f.Name == name) {
        				return f.Value;
        			}
        		}
        	}
        	return '';
        }
        
    }
    public class Fields {
        public List<Field> field { get; set;}
    }
    
    public class Field {
        public String Name { get; set; }
        public String Value { get; set; }
    }
}