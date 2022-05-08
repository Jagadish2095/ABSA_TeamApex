/** 
    * @description get cafApplication
    
    */

@RestResource(urlMapping='/UploadFiles/*')  
global class CAF_UploadFiles_Case {
    /** 
    * @description get cafApplication
    * @return Files
    * @param externamRefNumber
    * @param fileData
    * @param clientCIF
    
    */
    @HttpPost  
    global static String uploadFiles(String externamRefNumber,String fileData,String clientCIF)   
    {  
        System.debug('data '+fileData);
        System.debug('externamRefNumber '+externamRefNumber);
        System.debug('clientCIF '+clientCIF);
        String messageToReturn = '';
        if(externamRefNumber == '' || externamRefNumber == null ||
           fileData == '' || fileData == null ){
               messageToReturn = 'Error : Please send all required parameters(externamRefNumber,fileData)';
           }
        try{
            Case cs = new Case();
            try{
                cs = [Select Id,External_Reference_Number__c,Client_CIF_Number__c From Case Where External_Reference_Number__c =: externamRefNumber LIMIT 1];
            }catch(Exception e){
                System.debug('Exception '+e.getMessage());
            }
            System.debug('cs '+cs);    
            if(cs != null && cs.Id != null){
                
                
                //List<ContentVersion> cv = [select id,VersionData,Title from ContentVersion Where Title = 'Bkgd_Joblist_Filter_Accordian' ];
                //fileData = EncodingUtil.base64Encode(cv[0].VersionData);
                Blob versionData = EncodingUtil.base64Decode(fileData);
                
                ContentVersion conVer = new ContentVersion();
                conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
                conVer.PathOnClient = 'Testing Files3.pdf'; // The files name, extension is very important here which will help the file in preview.
                conVer.Title = 'Testing Files3.pdf'; // Display name of the files
                //conVer.VersionData = Blob.toPdf(fileData); // converting your binary string to Blog
                
                conVer.VersionData = versionData;
                insert conVer;    //Insert ContentVersion
                
                // First get the Content Document Id from ContentVersion Object
                Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
                //create ContentDocumentLink  record 
                ContentDocumentLink conDocLink = New ContentDocumentLink();
                conDocLink.LinkedEntityId = cs.Id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
                conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
                conDocLink.shareType = 'V';
                insert conDocLink;
                
                messageToReturn = 'SUCCESS';
            }else{
                messageToReturn = 'No matching case found.';
            }
        }catch(Exception e){
            messageToReturn = e.getMessage();
        }
        return messageToReturn;
    }
}