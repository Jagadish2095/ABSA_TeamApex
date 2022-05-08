/**
* Descripton: Apex Integration Utility Bean class for ABSAOnlineStatementDetailsV1 service
* Test Class Name: MBinitiatePaymentV10_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-01-30
*
**/
public class MBinitiatePaymentV10_IU_v1{
    /*  
  * @param: 
  * @return: MBinitiatePaymentV10_Req_IB_v1 bean object
  * */
    public static MBinitiatePaymentV10_Req_IB_v1 mapRequestdFields(){ //Case casemap,User usermap,String accNum,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){

        MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1(); 
        requestBean.channel= 'SALESFOR';
        requestBean.application= 'SALESFOR';
        requestBean.trace= 'T';
        requestBean.msgLanguage= 'E';
        requestBean.msgTarget= 'STD';
        requestBean.channelInp= 'SALESFOR';
        requestBean.paymTime= '11050112';
        requestBean.maxRetrieve= '1';
        requestBean.instrType= 'OOP' ;//CaseMap.Payment__c;
        requestBean.instrRefName= '';
        requestBean.actDate= '20200129';
        requestBean.amount= '1.00'; //String.valueOf(caseMap.Fixed_Amount__c);
        requestBean.srcAcc= '3001325523';
        requestBean.srcAccType= '';
        requestBean.srcClrCode= '0';
        requestBean.srcStmtRef= 'loan to build'; //caseMap.Source_Statement_Reference__c;
        requestBean.trgAcc= '4044751304'; //caseMap.Credit_Account__c;
        requestBean.trgClrCode= '0'; //caseMap.Beneficiary_ACB_or_Branch_Code__c;//'0';
        requestBean.trgAccType= ''; //caseMap.Credit_Account_Type__c;//'';
        requestBean.trgStmtRef = 'loans'; //CaseMap.Target_Statement_Reference__c;//
        requestBean.changeBranch='8089'; // usermap.SiteCode__c;//
        requestBean.changeTeller = '11012'; //usermap.Teller_Operator_Code__c;//
        requestBean.benNonResStat= '';
        System.debug('requestBean in IU'+requestBean) ;   
        return requestBean;
    }
   // @added  Lulu Rankwe : Absa 
    public static MBinitiatePaymentV10_Req_IB_v1 mbInitiateRequestdFields(String payTime,String actDate, String amount,String srcAcc,String srcAccType, String srcStmtRef,String trgAcc,String trgClrCode,String trgAccType,String trgStmtRef,String paymIipInd,String instrRefName, String tieb){
        
        String channelInp = 'SALESFOR';
        User currentUser = new UsersSelector().selectById(UserInfo.getUserId());
        
        String tbSiteCodes = Label.Telephone_Banking_Site_Codes;
		List<String> tbSiteCodeList = tbSiteCodes.split(';');
        
        if(tbSiteCodeList.contains(currentUser.SiteCode__c)){
            channelInp = 'TELEBANK';
        }
        
        MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1(); 
                                                                     
        requestBean.paymTime= payTime;
        requestBean.channel= 'SALESFOR';
        requestBean.application= 'SALESFOR';                                  
        requestBean.maxRetrieve = '1';
        requestBean.trace = 'Y';
        requestBean.msgLanguage = 'E';
        requestBean.msgTarget  = 'STD';
        requestBean.instrType= 'OOP' ;
        requestBean.channelInp = channelInp;
        requestBean.srcClrCode = '632005' ;
        requestBean.paymIipInd = paymIipInd;
        requestBean.instrRefName = instrRefName;                                                             
        requestBean.actDate= actDate;
        requestBean.amount= amount;        
        requestBean.srcAcc= srcAcc;
        requestBean.srcAccType= srcAccType;
        requestBean.srcStmtRef= srcStmtRef;
        requestBean.trgAcc= trgAcc;
        requestBean.trgClrCode= trgClrCode;
        requestBean.trgAccType= trgAccType;
        requestBean.trgStmtRef = trgStmtRef;
        requestBean.changeBranch= currentUser.SiteCode__c; 
        requestBean.changeTeller = currentUser.Teller_Operator_Code__c;                                                  
        requestBean.benNonResStat= '';
        return requestBean;
        
    }
    
    
    /*  
* @param: 
* @return: MBinitiatePaymentV10_Req_IB_v1 bean object
* */
    public static MBinitiatePaymentV10_Req_IB_v1 mapRequestdFieldsPayBeneficiary(String paymTime,String accessAcc,String cifKey,
  		 String instrRefName,String actDate,String amount,String instrNo,String srcAcc,String srcAccType,
       String srcStmtRef,String trgAcc,String trgClrCode,String trgAccType,String trgStmtRef,String paymIipInd,String tieb){ 
           
           String channelInp = 'SALESFOR';
           
           User currentUser =  new UsersSelector().selectById(Userinfo.getUserId());
           String siteCode = currentUser.SiteCode__c;  
           String teller = currentUser.Teller_Operator_Code__c; 
		   
           String tbSiteCodes = Label.Telephone_Banking_Site_Codes;
		   List<String> tbSiteCodeList = tbSiteCodes.split(';');
        
           if(tbSiteCodeList.contains(siteCode)){
               channelInp = 'TELEBANK';
           }
           
           MBinitiatePaymentV10_Req_IB_v1 requestBean = new MBinitiatePaymentV10_Req_IB_v1(); 
           
           requestBean.channel = 'SALESFOR';
           requestBean.application ='SALESFOR';
           requestBean.trace = 'Y';
           requestBean.msgLanguage = 'E';
           requestBean.msgTarget = 'STD';
           requestBean.channelInp = channelInp;
           requestBean.paymTime = paymTime;
           requestBean.paymIipInd = paymIipInd;
           requestBean.maxRetrieve= '1';
           requestBean.accessAcc = accessAcc;
           requestBean.cifKey = cifKey;
           requestBean.multiNo = '0';
           requestBean.instrType ='VP';
           requestBean.instrRefName = instrRefName;
           requestBean.actDate = actDate;
           requestBean.amount = amount;
           requestBean.instrNo = instrNo;
           requestBean.srcAcc = srcAcc;
           requestBean.srcAccType = srcAccType;
           requestBean.srcClrCode = '632005';
           requestBean.srcStmtRef = srcStmtRef;
           requestBean.trgAcc = trgAcc;
           requestBean.trgClrCode = trgClrCode;
           requestBean.trgAccType =trgAccType;
           requestBean.trgStmtRef = trgStmtRef;
           requestBean.changeBranch = siteCode;
           requestBean.changeTeller = teller;
           requestBean.benNonResStat ='';
           requestBean.tieb = tieb;
           

         return requestBean;
  }
    
    
      /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: MBinitiatePaymentV10_Resp_IB_v1 bean object
      * */
      public static MBinitiatePaymentV10_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = (MBinitiatePaymentV10_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), MBinitiatePaymentV10_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('MBinitiatePaymentV10 Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: MBinitiatePaymentV10_Resp_IB_v1 bean object
      * */
      public static MBinitiatePaymentV10_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        MBinitiatePaymentV10_Resp_IB_v1 responseBean = new MBinitiatePaymentV10_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('MBinitiatePaymentV10 Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }
}