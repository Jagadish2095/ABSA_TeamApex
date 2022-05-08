/**
* Descripton: Apex Integration Utility Bean class for SVcreateLinkSavingsNoticeDepAccountV6 service
* Test Class Name: SVcreateLinkSavingsDepAccount_IU_v1_Test
* @author  Srikanth : Absa
* @since   2020-02-24
*
**/
public class SVcreateLinkSavingsDepAccount_IU_v1{
   
    //Adeed source of fund value to pass the saving service by chandra dated 25/06/2020
    public static SVcreateLinkSavingsDepAccount_Req_IB_v1 mapRequestdFields(String cifCode, String site, String productCode, String srcOfFnds1, 
                                                       						String srcOfFnds2, String srcOfFnds3, 
                                                                            String srcOfFnds4, String srcOfFnds5, String rbaEddRating){ //Case casemap,User usermap,String accNum,String fromDate, String toDate,string CIFkey,string selectedprotype,String srcnum ){
        
        User currentUser = [SELECT Id,SiteCode__c, Teller_Operator_Code__c,Supervisor__c,EmployeeNumber FROM USER WHERE Id =: Userinfo.getUserId()];
      SVcreateLinkSavingsDepAccount_Req_IB_v1 requestBean = new SVcreateLinkSavingsDepAccount_Req_IB_v1();
        string electronicsite = System.Label.ElectronicSiteForAccount;
        requestBean.tellerCode= currentUser.Teller_Operator_Code__c;//'9999999';
        requestBean.agencyCode= '0';
        requestBean.supervisorCode= currentUser.Supervisor__c;//'9999999';
        requestBean.marketersCode= currentUser.EmployeeNumber; // Added by diksha for Employeenumber mapping
        requestBean.noticePeriod= '24';
        requestBean.effectiveDate= (''+system.today()).substring(0,10).replace('-',''); //'20200225';
        requestBean.withdrwlPerc= '10';
        requestBean.versionNbr= '0';
        requestBean.channelInd= 'B' ;
        requestBean.productCode= productCode; //'09007';
        requestBean.srcOfFnds1= srcOfFnds1;//Updated by chandra to remove hardcoded value dated 25/06/2020
        requestBean.brandCode= 'ABS'; 
        requestBean.srcOfFnds2= srcOfFnds2;//Updated by chandra to remove hardcoded value dated 25/06/2020
        requestBean.tranSiteType= '034';
        requestBean.srcOfFnds3= srcOfFnds3;//Updated by chandra to remove hardcoded value dated 25/06/2020
        requestBean.tranSiteCode = electronicsite;//currentUser.SiteCode__c;// '1334'; 
        requestBean.srcOfFnds4= srcOfFnds4; //Updated by chandra to remove hardcoded value dated 25/06/2020 
        requestBean.acctSiteType= '034'; 
        requestBean.srcOfFnds5= srcOfFnds5;//Updated by chandra to remove hardcoded value dated 25/06/2020 
        requestBean.acctSiteCode = electronicsite;//site; // '1334'; 
        requestBean.investAmount='10000'; 
        requestBean.clientCode = cifCode;//'LTD 933'; 
        requestBean.investTerm= '10';
        requestBean.msgTarget= 'BDP';
        requestBean.rateOption= '';
        requestBean.msgLanguage= 'E';
        requestBean.crpCode= '';
        requestBean.trace= 'N';
        requestBean.freqCode= '0';
        requestBean.application= 'BDP';
        requestBean.rbaEddRating= rbaEddRating;//'VH';
        requestBean.channel= 'BDP';
        System.debug('requestBean in IU'+requestBean) ;   
         return requestBean;
  }
    
    
      /* Creates a bean from the response 
      * @param: HTTP Response
      * @return: SVcreateLinkSavingsDepAccount_Resp_IB_v1 bean object
      * */
      public static SVcreateLinkSavingsDepAccount_Resp_IB_v1 mapResponseFields(HttpResponse respP){
        SVcreateLinkSavingsDepAccount_Resp_IB_v1 responseBean = (SVcreateLinkSavingsDepAccount_Resp_IB_v1)JSON.deserialize(respP.getBody().replace('transaction','transactionList'), SVcreateLinkSavingsDepAccount_Resp_IB_v1.class);
        responseBean.status = respP.getStatus();
        responseBean.statusCode = respP.getstatusCode();
        System.debug('SVcreateLinkSavingsDepAccount Service Success ResponseBean: ' + responseBean);
    
        return responseBean;
      }
    
      /* Creates a custom bean with the parameters mapped to their respective fields (Used for creating failed response beans)
      * @param: Status Code
      * @param: Status
      * @param: message
      * @return: SVcreateLinkSavingsDepAccount_Resp_IB_v1 bean object
      * */
      public static SVcreateLinkSavingsDepAccount_Resp_IB_v1 mapFailedResponseFields(Integer statusCodeP, String statusP, String messageP){
        SVcreateLinkSavingsDepAccount_Resp_IB_v1 responseBean = new SVcreateLinkSavingsDepAccount_Resp_IB_v1();
        responseBean.StatusCode = statusCodeP;
        responseBean.StatusMessage = statusP;
        System.debug('SVcreateLinkSavingsDepAccount Service Failed Response Bean: ' + responseBean);
        return responseBean;
  }
}