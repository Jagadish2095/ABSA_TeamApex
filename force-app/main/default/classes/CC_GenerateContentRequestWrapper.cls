public class CC_GenerateContentRequestWrapper {
    
    public CC_GenerateContentRequestWrapper() {}
    
    public CC_GenerateContentRequestWrapper(CC_GenerateContentRequest body) {
        this.body = JSON.serialize(body);
    }
    public String body { get; set; }
      
}