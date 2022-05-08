public class JitterbitAuthResponse implements RestClientUtils.MappedProperties {

  public String message { get; set; }
  public string token { get; set; }
  public String tokenType { get; set; }
    private Integer expiresIn { get; set; }
  
  public static JitterbitAuthResponse getExample() {
    JitterbitAuthResponse example = new JitterbitAuthResponse();
    example.message = 'message';
    example.token = '1821929182';
    example.tokenType = 'Bearer';
        example.expiresIn = 1234;
    return example;
  }
    
    public Map<String, String> getPropertyMappings() {
        return new Map<String, String> {
            'access_token' => 'token',
            'token_type' => 'tokenType',
            'expires_in' => 'expiresIn'
        };
    }

}