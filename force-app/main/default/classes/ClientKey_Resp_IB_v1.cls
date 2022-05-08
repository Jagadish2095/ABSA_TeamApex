/*
    * @description  Response Integration Bean for clientKey Service for package linking
    * @author Satya Boyenepalli
    * @created 2021-02-25
    */

 /**
 * @description  ClientKey  Request class
 */
public class ClientKey_Resp_IB_v1 extends Base_IB  {
 
        /**
 * @description  CreditAccountDetails
 */
    public class CreditAccountDetails {
         /**
 * @description  creditAccountNumber
 */
        public String creditAccountNumber;
	 /**
 * @description  fiidNumber
 */    
        public String fiidNumber;
 /**
 * @description  accountType
 */    
        public String accountType;
   /**
 * @description  productType
 */   
        public String productType;
  /**
 * @description  accountStatus
 */   
        public String accountStatus;
    }
     /**
 * @description  customerDetails
 */   
    @AuraEnabled public Object customerDetails;
       /**
 * @description  currentCustomerPackages
 */  
    @AuraEnabled public Object currentCustomerPackages;
          /**
 * @description  qualifyingPackages
 */  
    @AuraEnabled public List<QualifyingPackages> qualifyingPackages;
             /**
 * @description  errorMessage
 */  
    @AuraEnabled public String errorMessage;
     /**
    * @description  AvailablePricingScheme    
    */  

    public class AvailablePricingScheme {
        public String pricingSchemeIndicator;
        public String schemeDescription;
        public String schemeCode;
    }
    
     /**
    * @description  QualifyingProducts    
    */  

    public class QualifyingProducts {
        public ChequeAccountDetails chequeAccountDetails;
        public CreditAccountDetails creditAccountDetails;
    }
    /**
    * @description  QualifyingPackages    
    */  
    public class QualifyingPackages {
        public String packageName;
        public QualifyingProducts qualifyingProducts;
        public List<AvailablePricingScheme> availablePricingScheme;
        
    }
      /**
    * @description  ChequeAccountDetails    
    */  
    public class ChequeAccountDetails {
        public Object clientFullName;
        public String accountNumber;
        public String availableBalance;
        public String accountStatus;
        public String accountType;
        public String accountBalance;
    }
    
     /**
    * @description   ClientKey Respone
    * @return ClientKey_Resp_IB_v1
    */
    public static ClientKey_Resp_IB_v1 dummyResponse(){
        ClientKey_Resp_IB_v1 responseBean = new ClientKey_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        ClientKey_Resp_IB_v1.ChequeAccountDetails chequeAccountDetails = new ClientKey_Resp_IB_v1.ChequeAccountDetails();
        chequeAccountDetails.clientFullName='0';
        chequeAccountDetails.accountNumber='0';
        chequeAccountDetails.availableBalance='0';
        chequeAccountDetails.accountStatus='0';
        chequeAccountDetails.accountType='0';
        chequeAccountDetails.accountBalance='0';
        
        ClientKey_Resp_IB_v1.CreditAccountDetails creditAccountDetails = new ClientKey_Resp_IB_v1.CreditAccountDetails();
        creditAccountDetails.creditAccountNumber='0';
        creditAccountDetails.fiidNumber='0';
        creditAccountDetails.accountType='0';
        creditAccountDetails.productType='0';
        creditAccountDetails.accountStatus='0';
        
        ClientKey_Resp_IB_v1.AvailablePricingScheme availablePricingScheme = new ClientKey_Resp_IB_v1.AvailablePricingScheme();
        availablePricingScheme.pricingSchemeIndicator='0';
        availablePricingScheme.schemeDescription='0';
        availablePricingScheme.schemeCode='0';
        
        ClientKey_Resp_IB_v1.QualifyingProducts qualifyingProductsRequest= new ClientKey_Resp_IB_v1.QualifyingProducts();
        qualifyingProductsRequest.chequeAccountDetails =  chequeAccountDetails  ;
        qualifyingProductsRequest.creditAccountDetails =  creditAccountDetails  ;
        
        
        ClientKey_Resp_IB_v1.QualifyingPackages qualifyingPackagesRequest= new ClientKey_Resp_IB_v1.QualifyingPackages();         
        List<ClientKey_Resp_IB_v1.AvailablePricingScheme> availablePricingSchemeRequestList = new List<ClientKey_Resp_IB_v1.AvailablePricingScheme>();
        
        List<ClientKey_Resp_IB_v1.QualifyingPackages> qualifyingPackagesRequestList = new List<ClientKey_Resp_IB_v1.QualifyingPackages>();
        qualifyingPackagesRequestList.add(qualifyingPackagesRequest);
        
        qualifyingPackagesRequest.packageName =  ''  ;
        qualifyingPackagesRequest.qualifyingProducts =  qualifyingProductsRequest  ;
        availablePricingSchemeRequestList.add(availablePricingScheme);
        qualifyingPackagesRequest.availablePricingScheme =  availablePricingSchemeRequestList ;
        
        ClientKey_Resp_IB_v1 ClientKey_Resp_IB_v1bean = new ClientKey_Resp_IB_v1();
        ClientKey_Resp_IB_v1bean.qualifyingPackages = qualifyingPackagesRequestList;
        ClientKey_Resp_IB_v1bean.customerDetails = creditAccountDetails;
        ClientKey_Resp_IB_v1bean.currentCustomerPackages = chequeAccountDetails;        
        responseBean = ClientKey_Resp_IB_v1bean;
        
        return responseBean;
    }
    
}