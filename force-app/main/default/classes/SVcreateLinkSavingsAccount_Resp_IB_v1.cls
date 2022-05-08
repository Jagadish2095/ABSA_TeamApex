/**
 *@description Integration Handler for SVcreateLinkSavingsAccount_Resp_IB_v1 Service
 * @author khaliq Abdul 
 * @created 2021-08-26
 */
public without sharing class SVcreateLinkSavingsAccount_Resp_IB_v1 extends Base_IB{

    
	public String status;
	public List<Errors> errors;
    public Data data;
    public String timestamp;
	public String message;
	public String path;
    

    /** 
     * @description Data
     */
	public class Data {
		public String AccountNumber;
	}
    
    /** 
     * @description Errors
     */
    public class Errors {
		public String type;
		public String statusCode;
		public String message;
		public String sourceSystem;
		public String fieldName;
	}
    /** 
     * @description dummyResponse
     * @return SVcreateLinkSavingsAccount_Resp_IB_v1
     */
    public static SVcreateLinkSavingsAccount_Resp_IB_v1 dummyResponse(){
        SVcreateLinkSavingsAccount_Resp_IB_v1 responseBean = new SVcreateLinkSavingsAccount_Resp_IB_v1();
        responseBean.status='SUCCESSFUL';
        responseBean.message='SUCCESS';
        responseBean.timestamp='1629971195869';   
        responseBean.path='/api/accounts/savingsaccount';
        
        SVcreateLinkSavingsAccount_Resp_IB_v1.Data data = new SVcreateLinkSavingsAccount_Resp_IB_v1.Data();
       	data.AccountNumber='9051453871';
            
        SVcreateLinkSavingsAccount_Resp_IB_v1.Errors errors = new SVcreateLinkSavingsAccount_Resp_IB_v1.Errors();
        List<SVcreateLinkSavingsAccount_Resp_IB_v1.Errors> errorsList = new List<SVcreateLinkSavingsAccount_Resp_IB_v1.Errors>();
       	errors.type='EXTERNAL_SERVICE_ERROR';
        errors.statusCode='424';
        errors.message='CLIENT TYPE IS INVALID';
        errors.sourceSystem='Account Service';
        errors.fieldName='';
        errorsList.add(errors);
        
        responseBean.errors = errorsList;        
        responseBean.Data = data;

        return responseBean;
    }
    
    public override void setFieldNameSubstitutions() {
        fieldNameSubstitutionMap = new Map<String, String>();
        fieldNameSubstitutionMap.put('"Account Number":', '"AccountNumber":');
        //fieldNameSubstitutionMap.put('"type":', '"type_z":');
        
    }
}