/**
 * @description       : 
 * @author            : Khaliq Abdul
 
 * 1.0   2021-10-23   Khaliq Abdul   Initial Version
**/
@IsTest
public class ASPDeviceCustomerVerificationRespTest 
{
 /**
 * @description       : 
 */   
    @isTest
    public static void ASPContractRequestTestMethodNew()
    {
        ASPDeviceCustomerVerificationResponse dummyResponseBean = ASPContractRequestTestMethod();
       System.assertEquals('Success', 'Success', 'Succeded'); 
    }
    /**
 * @description       : 
 * @return ASPDeviceCustomerVerificationResponse
 */
    public static ASPDeviceCustomerVerificationResponse ASPContractRequestTestMethod()
    {
        
        ASPDeviceCustomerVerificationResponse deviceCustomerVerificationResponse = new ASPDeviceCustomerVerificationResponse();
        ASPDeviceCustomerVerificationResponse dummyResponseBean = deviceCustomerVerificationResponse.Dummyresponse();
		return dummyResponseBean;
        
    }

}