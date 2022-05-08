/*
 * ECM Rest Service
 *
 * @author Masimba Chingwende
 *
 * ECM_GetResult_IH_V1
 */
public class ECM_GetResult_IB_V1 {
	
	public GetResult GetResult { get; set; }
	public Content Content { get; set; }
	public Metadata Metadata { get; set; }
        
	public class GetResult {		
		public String Status { get; set;}
	    public String Detail { get; set; }
	}
	
	public class Content {
    	public String FileName { get; set; }
    	public String MimeType { get; set; }
    	public String Data { get; set; }
  }
  
  public class MetaData {
    public String ItemType { get; set; }
    public String PID { get; set; }
    public String CreationDate { get; set; }
    public String LastModifiedDate { get; set; }
    public String Creator { get; set; }
    public Fields Fields { get; set; }
  }
  
  public class Fields {
  	public List<ECM_Field> Field { get; set; }
  }
  
  public class ECM_Field {
    	
    	public String name { get; set; }
    	public String Type { get; set; }
    	public String size { get; set; }
    	public String nullable { get; set; }
    	public String unique { get; set; }
    	public String description { get; set; }
    	public String value { get; set; }
  }
    
    public static ECM_GetResult_IB_V1 getExample() {
        ECM_GetResult_IB_V1 result = new ECM_GetResult_IB_V1();
        GetResult gr = new GetResult();
        gr.status = 'Ok';
        gr.Detail = 'Details';
        result.GetResult = gr;
        Content c = new Content();
        c.FileName = 'test-file.txt';
    	c.MimeType = 'application/txt';
    	c.Data = 'test';
        result.Content = c;
        Metadata md = new Metadata();
        md.ItemType = 'Will';
    	md.PID = 'PID';
    	md.CreationDate= '12/12/2018';
    	md.LastModifiedDate = '12/12/2018';
        md.Creator = 'Test Creator';
    	//public List<ECM_Field> Fields { get; set; }
    	List<ECM_Field> fields = new List<ECM_Field>();
        ECM_Field field = new ECM_Field();
        field.name = 'IdNr';
    	field.Type = 'String';
    	field.size = '13';
    	field.nullable = 'false';
    	field.unique = 'false';
    	field.description = 'Id number field';
        fields.add(field);
        md.fields = new Fields();
        md.fields.Field = fields;
        result.Metadata = md;
        return result;
    }

}