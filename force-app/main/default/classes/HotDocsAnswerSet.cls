public class HotDocsAnswerSet implements RestClientUtils.MappedProperties {
	
	public String id { get; set; }
	public String href { get; set; }
	
	public Map<String, String> getPropertyMappings() {
  		Map<String, String> properties = new Map<String, String>();
  		properties.put('Id', 'id');
  		properties.put('Href', 'href');
  		return properties;
	}
    
    @testVisible
    public static HotDocsAnswerSet getExample() {
        HotDocsAnswerSet example = new HotDocsAnswerSet();
        example.id = '1726182812';
        example.href = 'HotDocsAnswers/api/v1/answerSet/1726182812/versions/live/answerXml';
        return example;
    }
}