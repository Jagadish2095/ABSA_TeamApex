public class HotDocsWorkItem implements RestClientUtils.MappedProperties {

  public String id { get; set; }
  public String name { get; set; }
  public String description { get; set; }
  public String answerSetId { get; set; }
  public PrimaryTemplate primaryTemplate { get; set; }
  public String CreationDate { get; set; }
  public String LastModifiedDate { get; set; }
  public String CreatedBy { get; set; }
  public String LastModifiedBy { get; set; }
  public String InterviewSessionId { get; set; }
  
  public Map<String, String> getPropertyMappings() {
  	Map<String, String> properties = new Map<String, String>();
  	properties.put('Id', 'id');
  	properties.put('Name', 'name');
  	properties.put('Description', 'description');
  	properties.put('AnswerSetId', 'answerSetId');
  	properties.put('PrimaryTemplate', 'primaryTemplate');
  	properties.put('CreationDate', 'creationDate');
  	properties.put('LastModifiedDate', 'lastModifiedDate');
  	properties.put('CreatedBy', 'createdBy');
  	properties.put('LastModifiedBy', 'lastModifiedBy');
  	properties.put('InterviewSessionId', 'interviewSessionId');
  	return properties;
  }
    
    public static HotDocsWorkItem getExample() {
        HotDocsWorkItem example = new HotDocsWorkItem();
        example.id = '178219820';
        example.description = 'Description';
        example.name = 'Name';
        example.answerSetId = 'answerSetId';
        example.primaryTemplate = new PrimaryTemplate().getExample();
        example.CreationDate = '10/03/2019';
        example.LastModifiedDate = '10/03/2019';
        example.InterviewSessionId = '1792192';
        example.LastModifiedBy = 'userId';
        return example;
    }
  
  public class AssembledDocument implements RestClientUtils.MappedProperties  {
  	
  	public String DocumentId { get; set; }
  	
  	public Map<String, String> getPropertyMappings() {
  		Map<String, String> properties = new Map<String, String>();
  		properties.put('DocumentId', 'documentId');
  		return properties;
  	}
      
      public AssembledDocument getExample() {
          AssembledDocument example = new AssembledDocument();
          example.DocumentId = 'DocumentId';
          return example;
      }
  }
  
  public class PrimaryTemplate implements RestClientUtils.MappedProperties  {

  	public string templateId { get; set; }
  	public string templateTitle { get; set; }
  	public List<AssembledDocument> assembledDocuments { get; set; }
  	
  	public Map<String, String> getPropertyMappings() {
  		Map<String, String> properties = new Map<String, String>();
  		properties.put('TemplateId', 'templateId');
  		properties.put('TemplateTitle', 'templateTitle');
  		properties.put('AssembledDocuments', 'assembledDocuments');
  		return properties;
  	}
    
      public PrimaryTemplate getExample() {
          PrimaryTemplate example = new PrimaryTemplate();
          example.templateId = 'templateId';
          example.templateTitle = 'templateTitle';
          List<AssembledDocument> assembledDocuments = new List<AssembledDocument>();
          assembledDocuments.add(new AssembledDocument().getExample());
          example.assembledDocuments = assembledDocuments;
          return example;
      }

  }

}