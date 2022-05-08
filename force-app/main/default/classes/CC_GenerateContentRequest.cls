/**
 * @description       :
 * @author            :
 * @group             :
 * @last modified on  : 09-01-2021
 * @last modified by  : Taras Kuliievych
**/
public class CC_GenerateContentRequest implements RestClientUtils.MappedProperties {
	/**
     * @description The name of the file
     * @return fileName
     */
    @AuraEnabled
    public String fileName { get; set; }

    /**
     * @description This is the type of Template Data used to generared the document, JSON or XML
     * @return templateDataType
     */
    @AuraEnabled
    public String templateDataType { get; set; }

    /**
     * @description Logging level
     * @return logLevel
     */
    public String logLevel { get; set; }

    /**
     * @description Get scheduleTimeStamp
     * @return scheduleTimeStamp
     */
    @AuraEnabled
    public String scheduleTimeStamp { get; set; }

    /**
     * @description Get recordSystemFeedbackID
     * @return recordSystemFeedbackID
     */
    @AuraEnabled
    public String recordSystemFeedbackID { get; set; }

    /**
     * @description Text = 1, HTML =2, RTF = 3, Excel = 4, PDF = 5,
     * @return contentRequestType
     */
    @AuraEnabled
    public String contentRequestType { get; set; }

    /**
     * @description Get contentStoreParamaters
     * @return contentStoreParamaters
     */
    public List<ContentStoreParams> contentStoreParamaters { get; set; }

    /**
     * @description Get contentStoreType
     * @return contentStoreType
     */
    @AuraEnabled
    public String contentStoreType { get; set; }

    /**
     * @description Get contentVersion
     * @return contentVersion
     */
    public String contentVersion { get; set; }

    /**
     * @description if set generated document will be protected using this password
     * @return password
     */
    @AuraEnabled
    public String password { get; set; }

    /**
     * @description The type to which the document should be encoded in, Base64 etc
     * @return encodingType
     */
    @AuraEnabled
    public String encodingType { get; set; }

    /**
     * @description The type to which the document should be encoded in, Base64 etc(Using only for JSON template data requst)
     * @return responseEncodingType
     */
    @AuraEnabled
    public String responseEncodingType { get; set; }

    /**
     * @description Get returnEmptyContent
     * @return returnEmptyContent
     */
    public Boolean returnEmptyContent { get; set; }

    /**
     * @description The template ID to be used in DocFusion
     * @return templateID
     */
    @AuraEnabled
    public String templateID { get; set; }

    /**
     * @description This sample used XML, JSON can also be used however the TemplateDataType field needs ot reflect that.
     * @return templateData
     */
    @AuraEnabled
    public String templateData { get; set; }

    /**
     * @description Get complete
     * @return complete
     */
    public Boolean complete { get; set; }

    /**
     * @description
     */
    private static final Map<String, String> propertyMappings = new Map<String, String>{
        'FileName' => 'fileName',
        'TemplateDataType' => 'templateDataType',
        'LogLevel' => 'logLevel',
        'ScheduleTimeStamp' => 'scheduleTimeStamp',
        'RecordSystemFeedbackID' => 'recordSystemFeedbackID',
        'ContentRequestType' => 'contentRequestType',
        'ContentStoreParamaters' => 'contentStoreParamaters',
        'ContentStoreType' => 'contentStoreType',
        'ContentVersion' => 'contentVersion',
        'Password' => 'password',
        'EncodingType' => 'encodingType',
        'ReturnEmptyContent' => 'returnEmptyContent',
        'TemplateID' => 'templateID',
        'TemplateData' => 'templateData'
    };

    /**
    * @description
    * @return Map<String, String>
    **/
    public Map<String, String> getPropertyMappings() {
        return propertyMappings;
    }

    /**
    * @description
    **/
    public class ContentStoreParams {
    	/**
        * @description
        **/
    	public String ItemType { get; set; }

        /**
        * @description
        **/
        public String ItemValue { get; set; }

        /**
        * @description
        **/
        public contentStoreParams() {}

        /**
        * @description
        * @param key
        * @param value
        **/
        public contentStoreParams(String key, String value) {
            this.ItemType = key;
            this.ItemValue = value;
        }
    }

    /**
    * @description
    * @return CC_GenerateContentRequest
    **/
    public static CC_GenerateContentRequest getExample() {
    	CC_GenerateContentRequest example = new CC_GenerateContentRequest();
    	example.fileName = 'Test.pdf';
    	example.templateDataType = 'XML';
    	example.logLevel = 'ERROR';
    	example.scheduleTimeStamp = '';
    	example.recordSystemFeedbackID = '';
    	example.contentRequestType = 'XML';
    	example.contentStoreParamaters = null;
    	example.templateData = 'data';
    	example.templateID = '25';
    	example.contentStoreType = 'ECM';
    	example.contentVersion = '1.0';
        example.responseEncodingType = 'Base64';

    	return example;
    }

    /**
    * @description
    * @param key
    * @param value
    **/
    public void addContentParam(String key, String value) {
        if (this.contentStoreParamaters == null) {
            this.contentStoreParamaters = new List<ContentStoreParams>();
        }
        this.contentStoreParamaters.add(new ContentStoreParams(key, value));
    }

    /**
    * @description
    * @param params
    **/
    public void addParams(List<ContentStoreParams> params) {
        if (this.contentStoreParamaters == null) {
            this.contentStoreParamaters = new List<ContentStoreParams>();
        }
        this.contentStoreParamaters.addAll(params);
    }
}