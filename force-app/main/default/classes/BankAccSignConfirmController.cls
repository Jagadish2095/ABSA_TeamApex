/* Lightning cmp controller for Bank Acc Signatories Confirmation
* Author: Himanshu Nimje (Mphatek)
* Date :  23/07/2020 
* 
*/

public class BankAccSignConfirmController {
    
    /**
* @author Himanshu Nimje
* getInstruction :Get the Signing Instructions and Signatories records
* @param Id Account Number
*/
    
    @AuraEnabled
    public static String getInstruction(String accountId,String accNo ){
        
        System.debug('accNo' +accNo ); 
        Map<CIgetSigningInstructionsV4_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = CIgetSigningInstructionsV4_IH_v1.CIgetSigningInstructionsV4(accNo,'8198','5');
        CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = (new List<CIgetSigningInstructionsV4_Resp_IB_v1>(responseMap.keySet()))[0];  
        
        if(responseBean.statusCode == 200){
            Boolean updatexml = updateXML(accountId,accNo,JSON.serialize(responseBean.CIgetSigningInstructionsV4Response.cip082do.nbrSignRetrieved),JSON.serialize(responseBean) );
            if(updatexml){
                return JSON.serialize(responseBean.CIgetSigningInstructionsV4Response);
            } else {
                
                System.debug('Error In Updating Document Template Record' );  
            }
        }
        
        return null;
    }
    
    /**
* @author Himanshu Nimje
* updateXML : Create and update Xml in Document template record according to Signatories 
* @param Service response from SigningInstruction 
*/
    
    @AuraEnabled
    public static Boolean updateXML(String accountId,String accNo, String noOfSign,String lstOfSign ){
        User user = new UsersSelector().selectById(UserInfo.getUserId());
        Account accountRecord = new AccountsSelector().selectAllById(accountId);
        System.debug('accountRecord : ' + accountRecord);
        Integer nrbSign = Integer.valueOf(noOfSign.replace('"', ''));
        String XmlString ;
        boolean DmlStatus = true;
        Document_Template__c documentTemplate = new Document_Template__c();
        documentTemplate = new DocumentTemplateSelector().selectTemplateByName('ABSA 6994 - Bank Account Signatories Confirmation');
        System.debug('documentTemplate' + documentTemplate);
        System.debug('noOfSign' + noOfSign); 
        System.debug('lstOfSign' + lstOfSign); 
        System.debug('user' + user);
        CIgetSigningInstructionsV4_Resp_IB_v1 responseBeanContent;
        CIgetSigningInstructionsV4_Resp_IB_v1 responseBean = new CIgetSigningInstructionsV4_Resp_IB_v1();
        responseBeanContent = (CIgetSigningInstructionsV4_Resp_IB_v1)responseBean.deserialize(lstOfSign, CIgetSigningInstructionsV4_Resp_IB_v1.class);
        system.debug(' responseBeanContent' + responseBeanContent);
        
        //Creating the XML
        DOM.Document doc = new DOM.Document();
        if(nrbSign == 1){
            System.debug('Inside one Record' + nrbSign);  
            dom.XmlNode Schema =doc.createRootElement('Schema',null,null);
            dom.xmlNode body=Schema.addchildElement('AISxMetaData',null,null);
            body.addChildElement('IsNCA', null, null).addTextNode('false');
            body.addChildElement('IsCPA', null, null).addTextNode('false');
            body.addChildElement('IsDigitalSignature', null, null).addTextNode('true');
            body.addChildElement('Language', null, null);
            
            dom.xmlNode body0=schema.addchildElement('Main',null,null);
            body0.addChildElement('entityName', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[0].Name);
            if(accountRecord.Company_Registration_Number__c!=null){
                body0.addChildElement('registrationNumber', null, null).addTextNode(accountRecord.Company_Registration_Number__c);
            }
            body0.addChildElement('accountNumber', null, null).addTextNode(accNo);
            body0.addChildElement('fullNames', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[0].Name);
            body0.addChildElement('surname', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[0].surname);
            body0.addChildElement('IDNumber', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[0].idNbr);
            body0.addChildElement('consultantName', null, null).addTextNode(user.Name);
            body0.addChildElement('consultantSurname', null, null).addTextNode(user.LastName);
            XmlString =doc.toXmlString();
            System.debug(LoggingLevel.FINEST,'XMLSTRING' + XmlString); 
            documentTemplate.XML__c=XmlString ;
            update documentTemplate ;
            System.debug('documentTemplate' + documentTemplate);
            
        } else If(nrbSign > 1){
            System.debug('Inside List Of Sign' + nrbSign);
            
            dom.XmlNode Schema =doc.createRootElement('Schema',null,null);
            dom.xmlNode base0=Schema.addchildElement('AISxMetaData',null,null);
            base0.addChildElement('IsNCA', null, null).addTextNode('false');
            base0.addChildElement('IsCPA', null, null).addTextNode('false');
            base0.addChildElement('IsDigitalSignature', null, null).addTextNode('true');
            base0.addChildElement('Language', null, null);
            
            for(Integer i=0; i < nrbSign; i++){
                List<String> newMainString = new List<String>();
                System.debug('Inside List Of Sign' + i);
                dom.xmlNode main=schema.addchildElement('Main',null,null);
                main.addChildElement('entityName', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[i].Name);
                if(accountRecord.Company_Registration_Number__c!=null){
                    main.addChildElement('registrationNumber', null, null).addTextNode(accountRecord.Company_Registration_Number__c);
                }
                main.addChildElement('accountNumber', null, null).addTextNode(accNo);
                main.addChildElement('fullNames', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[i].Name);
                main.addChildElement('surname', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[i].surname);
                main.addChildElement('IDNumber', null, null).addTextNode(responseBeanContent.CIgetSigningInstructionsV4Response.cip082do.outputTable[i].idNbr);
                main.addChildElement('consultantName', null, null).addTextNode(user.LastName);
                main.addChildElement('consultantSurname', null, null).addTextNode(user.LastName);
                newMainString.add(String.valueOf(main));
                
            }
            
            XmlString =doc.toXmlString();
            System.debug(LoggingLevel.FINEST,'XMLSTRING' + XmlString);         
            documentTemplate.XML__c=XmlString ;   
            update documentTemplate ;
            
            System.debug('documentTemplate' + documentTemplate);
            
        }else {
            
            System.debug('No list of Signatories fetched cannot Continue..');
            
        }
        
        return DmlStatus;        
    }
    /**
* @author Himanshu Nimje
* getDocument : Get the Pdf Document from DocFusion/ECM 
* @param Id XML
*/
    
    
    @AuraEnabled
    public static String getDocument(String accountId, String accNo, String noofSign, String lstOfSignatories, String templateName, string caseId ){
        
        System.debug(LoggingLevel.Finest,'lstOfSignatories :' + lstOfSignatories);
        System.debug('noofSign :' + noofSign);
        Account accountRecord = new AccountsSelector().selectAllById(accountId);
        System.debug('accountRecord : ' + accountRecord);
        System.debug('templateName : ' + templateName);
        Map<String, String> result = new Map<String, String>();
        Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(templateName);
        System.debug('documentTemplate : ' + documentTemplate);
        DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
        DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
        
        // this bit here is temporary so we have dates to populate while we try get ECM and Docfusion to work on dates - if send a null or unformatted date they throw error
        Datetime dt = Datetime.now();
        contextBuilder.add('today', dt.format('yyyy-MM-dd')+'T00:00:00');
        contextBuilder.add('today2', dt.format('yyyy/MM/dd'));
        contextBuilder.add('showUSCitizens', false);
        // end dirty fix
        
        String req = contextBuilder.serialize(documentTemplate.XML__c);
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        System.debug(LoggingLevel.Finest,req);
        System.debug('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
        Map<String, String> params = setECMParam(accountRecord, documentTemplate);
        System.debug(LoggingLevel.Finest,'params' +params); 
        System.debug(LoggingLevel.Finest,'contextBuilder' +contextBuilder);   
        
        if (!Test.isRunningTest()){
        CC_GenerateContentResponse response = documentTemplateProcessor.generateDocument(contextBuilder, documentTemplate, params);
        System.debug(LoggingLevel.Finest,'@@@@@@@@@@@@ ---DOcument Content serialise response ' + JSON.serialize(response));
        System.debug(LoggingLevel.Finest,'@@@@@@@@@@@@ ---DOcument Content TOken ' + JSON.serialize(response.contentStoreToken));
        Document__c docs = new Document__c();
        docs.Name = documentTemplate.Name.left(75)+'.pdf';
        docs.Type__c = documentTemplate.Document_Type__c;
        docs.Reference__c = response.contentStoreToken;
        docs.Case__c = caseId;
        insert docs;
        }
        return 'Success';
    }
    
    public static Map<String, String> setECMParam(Account acc, Document_Template__c template){
        Map<String, String> fields = new Map<String, String>();
        
        fields.put('CIFNr', acc.CIF__c == null ? '0' : acc.CIF__c);
        fields.put('IdNr', acc.Registration_Number__c == null ? '0' : acc.Registration_Number__c);
        fields.put('AcctNr', acc.AccountNumber == null ? '0' : acc.AccountNumber);
        fields.put('Origin', 'Salesforce B2C');
        fields.put('BusinessUnit', 'RBB');
        
        if (!Test.isRunningTest()){
            Map<String, String> credentials = ECM_IH_V1.getCredentials();
            fields.put('ECM_Account', credentials.get('username'));
            fields.put('ECM_Password', credentials.get('password'));
            fields.put('ECMItemType', template.ECM_Item_Type__c);
        }
        
        return fields;
    }
    
    /**
* @author Himanshu Nimje
* closeCaseAction : Close a case from the screen flow
* @param Id caseRecordId
*/
    @AuraEnabled
    public static void closeCaseAction(Id caseRecordId ){
        
        String errorMsg = 'Exception';
        AuraHandledException ex = new AuraHandledException(errorMsg);
        
        try{
            
            if(caseRecordId != null){
                Case caseObj = new Case(Id=caseRecordId);
                caseObj.Status = 'Closed';
                Update caseObj;
            }
            
        }catch(DmlException e){
            throw new AuraHandledException( e.getMessage());
        }
        
    }
}