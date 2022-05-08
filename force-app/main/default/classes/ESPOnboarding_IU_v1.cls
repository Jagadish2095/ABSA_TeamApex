/**
* Apex Integration Utility Bean class for ESP Onboarding service
* @author  Manoj Danthala : Absa
* @since   2019-02-27
*
**/
public class ESPOnboarding_IU_v1{
    /* Creates a Request Bean from the Leads 
	* @param: List of Lead objects
	* @return: ESPOnboarding_Req_IB_v1 bean object
	* */
    public static ESPOnboarding_Req_IB_v1 mapRequestdFields(Lead leadRec,Financial_Product__c finProd){
        ESPOnboarding_Req_IB_v1 requestBean = new ESPOnboarding_Req_IB_v1();
        
        requestBean.Requester = System.Label.ESPOnboarding_Requester;
        requestBean.FunctionType = Integer.valueof(System.Label.ESPOnboarding_FunctionType);
        requestBean.RequesterReference = leadRec.Lead_Ref_No__c;
        
        List<User> userList = new UsersSelector().selectById(new Set<Id>{leadRec.OwnerId});
        String userABNumber = '';
        if(!userList.isEmpty()){
            userABNumber = userList[0].AB_Number__c !=null ? userList[0].AB_Number__c : '';
        }
        
        ESPOnboarding_Req_IB_v1.Payload load = new ESPOnboarding_Req_IB_v1.Payload();
        load.Firstname = leadRec.FirstName;
        load.LastName = leadRec.LastName;
        load.BankerABNumber = userABNumber;
        load.IdRegNumber = leadRec.Company_Registration_Number__c !=null ? leadRec.Company_Registration_Number__c : '';
        load.EntityType = translateToExternalValue('ESP Entity Type',leadRec.Entity_Type__c); //leadRec.Entity_Type__c
        load.ContactNumber = leadRec.MobilePhone!=null ? leadRec.MobilePhone : leadRec.Phone;
        
        List<ESPOnboarding_Req_IB_v1.Products> prodList = new List<ESPOnboarding_Req_IB_v1.Products>();
        
        ESPOnboarding_Req_IB_v1.Products prod = new ESPOnboarding_Req_IB_v1.Products();
        prod.Group_x = finProd.Product_Group_Code__c;
        prod.Product = finProd.Product_Code__c;
        prodList.add(prod);
        load.Products = prodList;
        
        requestBean.Payload = JSON.serialize(load);
        
		return requestBean;
	}
    
    /**
    * Method that translates an internal value to an external value
    * @param System Name (Currentlty not used)
    * @param Field Name
    * @param Internal Value
    * @return External Value
    */
    public static String translateToExternalValue(String fieldNameP, String valueP){
        //Metadata type records for mapping Salesforce values to ESP.
        List<Integration_Mapping__mdt> integrationMappingValueList = new List<Integration_Mapping__mdt>([
            SELECT
            External_Value__c
            FROM
            Integration_Mapping__mdt
            WHERE
            Salesforce_Value__c =: valueP
            AND
            System_Value_Type__c =: fieldNameP
        ]);
        
        if(integrationMappingValueList.size() == 1){
            return integrationMappingValueList.get(0).External_Value__c;
        }
        return null;
    }
    
	/* Creates a bean from the response 
	* @param: HTTP Response
	* @return: ESPOnboarding_Resp_IB_v1 bean object
	* */
	public static ESPOnboarding_Resp_IB_v1 mapResponseFields(HttpResponse respP){
		ESPOnboarding_Resp_IB_v1 responseBean = (ESPOnboarding_Resp_IB_v1)JSON.deserialize(respP.getBody(), ESPOnboarding_Resp_IB_v1.class);
		//responseBean.RequesterReference = respP.RequesterReference;
		//responseBean.status = respP.getStatus();
		//responseBean.statusCode = responseBean.statusCode();
		System.debug('ESP Service Success ResponseBean: ' + responseBean);

		return responseBean;
	}

	/* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
	* @param: Status Code
	* @param: Status
	* @param: message
	* @return: ESPOnboarding_Resp_IB_v1 bean object
	* */
	public static ESPOnboarding_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
		ESPOnboarding_Resp_IB_v1 responseBean = new ESPOnboarding_Resp_IB_v1();
		responseBean.StatusCode = statusCodeP;
		responseBean.StatusMessage = statusP;
		System.debug('ESP Service Failed Response Bean: ' + responseBean);
		return responseBean;
	}
}