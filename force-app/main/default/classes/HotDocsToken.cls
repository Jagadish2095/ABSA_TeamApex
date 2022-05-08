public class HotDocsToken implements RestClientUtils.MappedProperties {

  public string accessToken { get; set; }
  public integer expiresIn { get; set; }
  public string tokenType { get; set; }
  
  @testVisible
  public Map<String, String> getPropertyMappings() {
  	Map<String, String> properties = new Map<String, String>();
  	properties.put('access_token', 'accessToken');
  	properties.put('expires_in', 'expiresIn');
  	properties.put('token_type', 'tokenType');
  	return properties;
  }
  
    @testVisible
    public static HotDocsToken getExample() {
        HotDocsToken example = new HotDocsToken();
        example.accessToken = 'uwyqiwk192291ksjo';
        example.expiresIn = 1245;
        example.tokenType = 'Bearer';
        return example;
    }

}