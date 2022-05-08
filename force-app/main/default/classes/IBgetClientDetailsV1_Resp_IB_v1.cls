/*
 * Response Integration Bean for IBgetClientDetails Service
 * @author Khaliq Abdul
 * @created 2020-09-22
 */
public class IBgetClientDetailsV1_Resp_IB_v1 extends Base_IB {
     public String status;
     public Integer statusCode;
     public String message;
     public IBgetClientDetailsV1Response IBgetClientDetailsV1Response;
  
    public class IBgetClientDetailsV1Response{
         public Nbsapdpo nbsapdpo{get;set;}
         public Nbsmsgo3 nbsmsgo3{get;set;}
         public Nhs400o nhs400o{get;set;}            
    }
    
    public class Nbsapdpo{
         public String version;
         public String returnCode;
         public String reasonCode;
         public String serviceVersion;
         public String echoKey;        
    }
    
    public class Nbsmsgo3{
        public String version;
        public  String sysErrTxt;
        public String nbrUserMsgs;
        public String nbrUserErrs;
                 
    }    
    public class Nhs400o {
     public Decimal accountPaymentAvail;
     public Decimal accountPaymentLimit;
     public Decimal accountPaymentUsed;
     public String bdbSalaryServices;
     public Integer changeDate;
     public Integer changeSite;
     public Integer changeTeller;
     public Integer changeTime;
     public String clientName;
     public String clientType;
     public Long combiCardNumber;
     public Long costAccount;
     public Long debitedAccount;
     public String division;
     public String email;
     public String feeStructure;
     public Decimal fundTransferAvail;
     public Decimal fundTransferLimit;
     public Decimal fundTransferUsed;
     public Decimal futureDatedLimit;
     public String lastAccessUserName;
     public Integer lastAccessedDate;
     public Integer lastAccessedTime;
     public Integer lastUserNumber;
     public String mindleaders;
     public Integer numOfAuthRequired;
     public Integer numOfMainUsers; 
     public Integer numOfOperators;
     public String operatorSystemEnabled;
     public Decimal ownDefinedAvail;
     public Decimal ownDefinedLimit;
     public Decimal ownDefinedUsed;
     public String pinValidationRequired;
     public String registeredForApp; 
     public String registeredForInternet;  
     public String registeredForMobile; 
     public String registeredForWap;
     public String registeringSite;
     public Integer registrationDate;
     public Integer registrationTeller;
     public Integer registrationTime;
     public String securityOption;
     public Integer serviceChangeDate;
     public Integer serviceChangeTime;
     public String serviceStatus;
     public Integer statusDate;
     public Integer statusTime;
     public Integer stopOrderLimit;
    }
    
    public static IBgetClientDetailsV1_Resp_IB_v1 dummyResponse(){
        IBgetClientDetailsV1_Resp_IB_v1 responseBean = new IBgetClientDetailsV1_Resp_IB_v1();
        responseBean.status='OK';
        responseBean.statusCode=200;
        responseBean.message='SUCCESS';
        
        IBgetClientDetailsV1_Resp_IB_v1.Nbsapdpo nbsapdpo = new IBgetClientDetailsV1_Resp_IB_v1.Nbsapdpo();
       nbsapdpo.version='0';
        nbsapdpo.reasonCode = '0';
        nbsapdpo.returnCode = '0';
        nbsapdpo.serviceVersion = 'BUSO003';
        nbsapdpo.echoKey='';
        IBgetClientDetailsV1_Resp_IB_v1.Nbsmsgo3 nbsmsgo3 = new IBgetClientDetailsV1_Resp_IB_v1.Nbsmsgo3();
        nbsmsgo3.version = 'MSG3001';
        nbsmsgo3.sysErrTxt='';
        nbsmsgo3.nbrUserErrs = '0';
        nbsmsgo3.nbrUserMsgs = '0';
        
         IBgetClientDetailsV1_Resp_IB_v1.Nhs400o nhs400oRequest = new IBgetClientDetailsV1_Resp_IB_v1.Nhs400o();
        nhs400oRequest.accountPaymentAvail =  0 ;
        nhs400oRequest.accountPaymentUsed =  0  ;
        nhs400oRequest.bdbSalaryServices =  '0'  ;
        nhs400oRequest.changeDate =  0  ;
        nhs400oRequest.changeSite =  0  ;
        nhs400oRequest.changeTeller =  0  ;
        nhs400oRequest.changeTime =  0  ;
        nhs400oRequest.clientName =  'KS'  ;
        nhs400oRequest.clientType =  ''  ;        
        nhs400oRequest.combiCardNumber =  0 ;
        nhs400oRequest.costAccount =  0  ;
        nhs400oRequest.debitedAccount =  0  ;
        nhs400oRequest.division =  '0'  ;
        nhs400oRequest.email =  ''  ;
        nhs400oRequest.feeStructure =  ''  ;
        nhs400oRequest.fundTransferAvail =  0  ;
        nhs400oRequest.fundTransferLimit =  0  ;
        nhs400oRequest.fundTransferUsed =  0  ;        
        nhs400oRequest.futureDatedLimit =  0 ;
        nhs400oRequest.lastAccessUserName =  '0'  ;
        nhs400oRequest.lastAccessedDate =  0  ;
        nhs400oRequest.lastAccessedTime =  0  ;
        nhs400oRequest.lastUserNumber =  0  ;
        nhs400oRequest.mindleaders =  ''  ;
        nhs400oRequest.numOfAuthRequired =  0  ;
        nhs400oRequest.numOfMainUsers =  0 ;
        nhs400oRequest.numOfOperators =  0  ;        
        nhs400oRequest.operatorSystemEnabled =  '0' ;
        nhs400oRequest.ownDefinedAvail =  0  ;
        nhs400oRequest.ownDefinedLimit =  0  ;
        nhs400oRequest.ownDefinedUsed =  0  ;
        nhs400oRequest.pinValidationRequired =  '0'  ;
        nhs400oRequest.registeredForApp =  '0'  ;
        nhs400oRequest.registeredForInternet =  '0'  ;
        nhs400oRequest.registeredForMobile =  '0'  ;
        nhs400oRequest.registeredForWap =  ''  ;        
        nhs400oRequest.registeringSite =  '0' ;
        nhs400oRequest.registrationDate =  0  ;
        nhs400oRequest.registrationTeller =  0  ;
        nhs400oRequest.registrationTime =  0  ;
        nhs400oRequest.securityOption =  '0'  ;
        nhs400oRequest.serviceChangeDate =  0  ;
        nhs400oRequest.serviceChangeTime =  0  ;
        nhs400oRequest.serviceStatus =  '0'  ;
        nhs400oRequest.statusDate =  0  ;
        nhs400oRequest.statusTime =  0  ;
        nhs400oRequest.stopOrderLimit =  0  ;
        
        
        IBgetClientDetailsV1_Resp_IB_v1.IBgetClientDetailsV1Response IBgetClientDetailsV1Responsebean = new IBgetClientDetailsV1_Resp_IB_v1.IBgetClientDetailsV1Response();
        IBgetClientDetailsV1Responsebean.nbsapdpo = nbsapdpo;
        IBgetClientDetailsV1Responsebean.nbsmsgo3 = nbsmsgo3;
        IBgetClientDetailsV1Responsebean.nhs400o = nhs400oRequest;
        
        responseBean.IBgetClientDetailsV1Response = IBgetClientDetailsV1Responsebean;
        
        return responseBean;
    }
}