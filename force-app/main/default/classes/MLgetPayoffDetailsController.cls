/**
 * @description Contoller Class for HLsettlementLetterSearch AUra component
* @author  Srikanth : Absa
* @version v2.0
* @since   2020-10-20
* Edited Simangaliso: 26 Aug 2021
*/

public class MLgetPayoffDetailsController {
    
    /**
	 * @description Method to fetch and generate Settlement Letter
	 * @param accountId
	 * @param mortgageLoanNo
	 * @param payAllAcc
	 * @param effectiveDate
	 * @param includeCommit
	 * @param documentTemplateName
	 * @return String
	 */
    @AuraEnabled
    public static String fetchHLSettlementLetter(Id accountId, String mortgageLoanNo, String payAllAcc, String effectiveDate, String includeCommit, String documentTemplateName) {
        MLgetPayoffDetailsV1_Resp_IB_v1 payoffDetailsResponseBean = MLgetPayoffDetailsV1_IH_v1.MLgetPayoffDetailsV1(mortgageLoanNo, payAllAcc, effectiveDate, includeCommit);

        if (payoffDetailsResponseBean?.MLgetPayoffDetailsV1Response?.nbsmsgo?.nbrUserErrs != 0) {
            return 'Error: getting response from MLgetPayoffDetailsV1 service. Error Message: ' + payoffDetailsResponseBean?.MLgetPayoffDetailsV1Response?.nbsmsgo?.msgEntry;
        }

        if (payoffDetailsResponseBean?.MLgetPayoffDetailsV1Response?.mlp801o?.balance == null) {
            return 'Error: Unexpected response from MLgetPayoffDetailsV1 service. Response: ' + JSON.serialize(payoffDetailsResponseBean);
        }

        DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
        Document_Template__c documentTemplate = new DocumentTemplateSelector().selectTemplateByName(documentTemplateName);
        Account accountRecord = new AccountsSelector().selectAllById(accountId);
        Map<String, String> params = GenerateDocument.setECMParam(accountRecord, documentTemplate);
        Datetime formattedDate = Datetime.valueOf(effectiveDate.left(4) + '-' + effectiveDate.mid(4, 2) + '-' + effectiveDate.right(2) + ' 00:00:00');
        contextBuilder.add('acctId', mortgageLoanNo);
        contextBuilder.add('clientName', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.clientName);
        contextBuilder.add('endowCommDate', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.endowCommDate);
        contextBuilder.add('payOffDate', formattedDate);
        contextBuilder.add('commitGross', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.commitGross);
        contextBuilder.add('capMnthInd', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.capMnthInd);
        contextBuilder.add('outstBal', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.balance[0].outstBal);
        contextBuilder.add('commitAmnt', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.commitAmnt);
        contextBuilder.add('intAccrued', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.intAccrued);
        contextBuilder.add('hocPremium', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.hocPremium);
        contextBuilder.add('hmpPremium', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.hmpPremium);
        contextBuilder.add('provAdminFee', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.provAdminFee);
        contextBuilder.add('provEndowment', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.provEndowment);
        contextBuilder.add('amntReqPayOffLoan', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.amntReqPayOffLoan);
        contextBuilder.add('uncCheq', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.uncCheq);
        contextBuilder.add('uncDoc', payoffDetailsResponseBean.MLgetPayoffDetailsV1Response.mlp801o.uncDoc);

        CC_GenerateContentResponse generateDocumentResponse = new DocumentTemplateProcessor().generateDocument(contextBuilder, documentTemplate, params);

        if (String.isBlank(generateDocumentResponse?.contentStoreToken)) {
            return 'Error: Document generation using DocumentTemplateProcessor service failed. Response: ' + JSON.serialize(generateDocumentResponse);
        }

        Map<String, String> credentials = ECM_IH_V1.getCredentials();
        ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(credentials.get('store'), credentials.get('username'), credentials.get('password'));
        ECM_GetResult_IB_V1 getResult = ECM_IH_V1.getDocument(login.token, generateDocumentResponse.contentStoreToken);

        if (String.isBlank(getResult?.Content?.data)) {
            return 'Error: Document download using ECM_IH_V1 service failed. Response: ' + JSON.serialize(getResult);
        }

        return getResult.Content.data;
    }

    /**
	 * @description Method to send an email
	 * @param caseId
	 * @param emailTemplate
	 * @param emailAddress
	 * @param fileName
	 * @param pdfData
	 */
    @AuraEnabled
    public static void sendEmail(Id caseId, String emailTemplate, String emailAddress, String fileName,  String pdfData){
        Id targetObjectId = [Select id from Contact where Email != '' limit 1].Id;
        List<Messaging.SingleEmailMessage> constructEmail = EmailHandler.ComposeEmail(caseId, targetObjectId, emailAddress,emailTemplate);
        // OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'businessbanking@absa.africa'];

        List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject(constructEmail.get(0).getSubject()+ ' - ' + fileName);
        mail.setSaveAsActivity(true);
        mail.setToAddresses(new List<String>{emailAddress});
        mail.setHtmlBody(constructEmail.get(0).getHtmlBody());
        mail.setOrgWideEmailAddressId(NotifyBankerController.getOrgWideEmailAddressId(caseId));

        List<Messaging.EmailFileAttachment> fileAttachments = new List<Messaging.EmailFileAttachment>();
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName(fileName + '.pdf');
        efa.setBody(EncodingUtil.base64Decode(pdfData));
        fileAttachments.add(efa);
        Messaging.EmailFileAttachment efaAbsa1288 = getAbsa1288Attachment();
        if (efaAbsa1288 != null) {
            fileAttachments.add(efaAbsa1288);
        }
        mail.setFileAttachments(fileAttachments);
        mails.add(mail);

        Messaging.sendEmail(mails);
        NotifyBankerController.emailActivities(mail, caseId);
    }

    /**
	 * @description Method to update case status
	 * @param caseId
     * @return string
	 */
    @AuraEnabled
    public static String caseStatusUpdate(String caseId){
        Case caseObj = new Case(Id=caseId, Status = 'Closed', Bypass_Validation_Rules__c = true);
        try{
            Update caseObj;
        }catch(exception e){
            return e.getMessage();
        }
        return 'success';
    }

    /**
	 * @description Method to get Absa1288Attachment
     * @return Messaging.EmailFileAttachment
	 */
    private static Messaging.EmailFileAttachment getAbsa1288Attachment() {
        String staticResourceName = 'Absa_1288_EX_NCA';
        List<StaticResource> srList = [SELECT Id, Body FROM StaticResource WHERE Name = :staticResourceName LIMIT 1];
        if (srList?.size() > 0 && srList[0]?.Body?.size() > 0) {
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName(staticResourceName + '.pdf');
            efa.setBody(srList[0].Body);
            return efa;
        }
        return null;
    }
}