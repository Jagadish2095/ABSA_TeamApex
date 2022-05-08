/**
 * A generate content response.
 *
 * @author Masimba Chingwende
 */
public class CC_GenerateContentResponse implements RestClientUtils.MappedProperties {
	/**
     * Failed, Success or ContentFailed
     * @return responseStatus
     */
    public String responseStatus { get; set; }

    /**
     * Get contentStatus
     * @return contentStatus
     */
    public String contentStatus { get; set; }

    /**
     * Get contentStoreToken
     * @return contentStoreToken
     */
    public String contentStoreToken { get; set; }

    /**
     * Get contentStore
     * @return contentStore
     */
    public String contentStore { get; set; }

    /**
     * Get log
     * @return log
     */
    public String log { get; set; }

    /**
     * Get contentRequestType
     * @return contentRequestType
     */
    public String contentRequestType { get; set; }

    /**
     * Get rawContent
     * @return rawContent
     */
    //public String rawContent { get; set; }

    /**
     * Get templateData
     * @return templateData
     */
    public String templateData { get; set; }

    /**
     * Get templateSchema
     * @return templateSchema
     */
    public String templateSchema { get; set; }

    /**
     * Get templateID
     * @return templateID
     */
    public String templateID { get; set; }

    /**
     * Get encodingType
     * @return encodingType
     */
    public String encodingType { get; set; }

    /**
     * Get transformedData
     * @return transformedData
     */
    public String transformedData { get; set; }

    private static final Map<String, String> propertyMappings = new Map<String, String> {
        'ResponseStatus' => 'responseStatus',
        'ContentStatus' => 'contentStatus',
        'ContentStoreToken' => 'contentStoreToken',
        'ContentStore' => 'contentStore',
        'Log' => 'log',
        'ContentRequestType' => 'contentRequestType',
        //'RawContent' => 'rawContent',
        'TemplateData' => 'templateData',
        'TemplateSchema' => 'templateSchema',
        'TemplateID' => 'templateID',
        'EncodingType' => 'encodingType',
        'TransformedData' => 'transformedData'
    };

    public Map<String, String> getPropertyMappings() {
        return propertyMappings;
    }
    
    public static CC_GenerateContentResponse getExample() {
    	CC_GenerateContentResponse example = new CC_GenerateContentResponse();
    	example.responseStatus = 'Ok';
    	example.contentStatus = 'Ok';
    	example.contentStoreToken = '1872197291728912';
    	example.contentStore = 'ECM';
    	example.log = '';
    	example.contentRequestType = 'XML';
    	example.templateData = 'data';
    	example.templateSchema = '';
    	example.templateID = '25';
    	example.encodingType = 'UTF-8';
    	example.transformedData = '';
    	return example;
    }
}