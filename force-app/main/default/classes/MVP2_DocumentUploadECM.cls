/*
*  @description       : MVP2_DocumentUploadECM
*
* @author  Vitthal Jivrag
* @version v1.0
* @since   2021-02-11
*
*/
/**
 * @description       : MVP2_DocumentUploadECM
 * @author            :  Vitthal Jivrag
 * @last modified on  : 2021-11-24
**/
public class MVP2_DocumentUploadECM {
    /** @description uploadtoECM
     * @param fileName
     * @param data
     * @param parentId
     * @param accID
     * @param usrId
     **/
    @future(callout = true)
    public static void uploadtoECM(String fileName,Blob data,String parentId,String accID,String usrId) {
        try{
            Account Acc=[select id,ID_Number__pc,Registration_Number__c,CIF__c from account where id =: accID];
            User usr=[Select id,Business_Area__c from user where id =: usrId];
            Opportunity Opp=[select id,RecordType.developerName,Accountid,ownerId,ECM_Reference__c from Opportunity where id =:parentId limit 1]; 
            Map<String, String> credentials = ECM_IH_V1.getCredentials();
            ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
            ECM_AddRequest_IB_V1 req = new ECM_AddRequest_IB_V1();
            ECM_AddRequest_IB_V1.AddRequest request = new ECM_AddRequest_IB_V1.AddRequest();
            request.Token = login.Token;
            String documentType = 'STI Documents';
            String fileFullName = fileName;
            if(Opp.RecordType.developerName=='Investment_Opportunity'){
                documentType = 'Investment_Opportunity_'+fileName.substringAfterLast('#@#');
                fileFullName = fileName.substringBeforeLast('#@#');
            }
            request.FileName = fileFullName;
            DocumentManagementUploaderControler.setDocumentECMInfo(request, parentId, acc, usr, documentType);
            request.Data = EncodingUtil.base64Encode(data);
            req.AddRequest = request;
            String fileReference;
            if(!Test.isRunningTest()){
                ECM_AddResult_IB_V1 addResult = ECM_IH_V1.addDocument(req);
                fileReference = addResult.Pid;
            }
            
            if(fileReference != null){
                if(opp.ECM_Reference__c != null){
                    opp.ECM_Reference__c = opp.ECM_Reference__c +'[ File Name - '+fileFullName +'] [ ECM Reference No - '+fileReference + '].';
                }
                else{
                    opp.ECM_Reference__c = '[ File Name - '+fileFullName +'] [ ECM Reference No - '+fileReference + '].';
                }
                opp.Sys_BypassValidation__c = true;
                update Opp;
            }
        }
        catch(Exception ex){
            String e = ex.getMessage();
        }
    }
}