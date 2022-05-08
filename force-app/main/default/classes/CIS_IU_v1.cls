/**
* @description       : Integration utility for CIS
* @author            : Mohammed Junaid U
* @group             :
* @last modified on  : 2021-12-07
* @last modified by  : muvhuso.nekhubvi@absa.africa
* Modifications Log
* Ver   Date         Author                Modification
* 1.0   2021-05-24   Mohammed Junaid U     Initial Version
**/

public class CIS_IU_v1 {
    
   
    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-12-07 
    * @param login 
    * @param fileName 
    * @param documentType 
    * @param a 
    * @param acc 
    * @param subDocumentType 
    * @param fromGoldenSource 
    * @param body 
    * @param jointCIF 
    * @return CIS_AddDocRequest_IB_v1 
    **/
    public static CIS_AddDocRequest_IB_v1 mapAddDocRequestFields(CIS_LoginResult_IB_V1 login, string fileName, string documentType, attachment a, account acc,string subDocumentType,String fromGoldenSource, String body , string jointCIF){
        CIS_AddDocRequest_IB_v1 addDocRequest = new CIS_AddDocRequest_IB_v1();
        addDocRequest.Token = login.Token;
        addDocRequest.FileName = fileName;
        addDocRequest.ItemType = 'Ent_'+documentType;
        string clientCode = jointCIF != '' ? jointCIF : acc.CIF__c;
        addDocRequest.addFieldValue('CIFNr', clientCode != null ? clientCode : '');
        addDocRequest.addFieldValue('SUIN', acc.SUIN__c != null ? acc.SUIN__c : 'NA');
        addDocRequest.addFieldValue('AcctNr', 'NA');
        if (acc.Client_Type__c == 'Individual' || acc.Client_Type__c =='Individual - Minor' || acc.Client_Type__c == 'Non - Resident Entity' || acc.Client_Type__c == 'Private Individual' || acc.Client_Type__c == 'Staff' || acc.Client_Type__c == 'Staff Joint and Several'){
            addDocRequest.addFieldValue('IdNr', acc.Id_number__pc != null ? acc.Id_number__pc : 'NA');}
        else {
            if(acc.Registration_Number__c != null){
                addDocRequest.addFieldValue('IdNr', acc.Registration_Number__c != null ? acc.Registration_Number__c : 'NA');
            }else if(acc.ID_Number__pc != null){
                addDocRequest.addFieldValue('IdNr', acc.Id_number__pc != null ? acc.Id_number__pc : 'NA');} 
        }
        if(documentType == 'ProofOfAddress' || documentType == 'ProofOfId'){
            addDocRequest.addFieldValue('IsFromGoldenSource', fromGoldenSource);}
        addDocRequest.addFieldValue('DocumentSubType', subDocumentType);
        addDocRequest.addFieldValue('Origin', 'RBSALESFORCE');
        addDocRequest.addFieldValue('DocumentGUID', acc.Id);
        addDocRequest.addFieldValue('BusinessUnit', 'RB');
        if(a != null){
            addDocRequest.Data = EncodingUtil.base64Encode(a.Body);}
        else{
            addDocRequest.Data = body;
        }
        return addDocRequest;
    }
    
    /**
* @description
* @param login
* @param pid
* @return CIS_GetDocRequest_IB_V1
**/
    public static CIS_GetDocRequest_IB_V1 mapGetDocRequestfields(CIS_LoginResult_IB_V1 login,string pid){
        //CIS_GetDocRequest_IB_V1.GetRequest getRequest = new CIS_GetDocRequest_IB_V1.GetRequest();
        // getRequest.Token = login.token;
        // getRequest.PID = pid;
        CIS_GetDocRequest_IB_V1 request = new CIS_GetDocRequest_IB_V1();
        request.Token = login.token;
        request.PID = pid;
        return request;
    }
    
}