/**
 * @description       : AccountEnquiryCntr
 * @author            : Mradul Maheshwari
 * @last modified on  : 04-11-2021
 * @last modified by  : Mradul Maheshwari
 * @Work Id           : W-013340 W-016008
 **/
public with sharing class AccountEnquiryCntr {
  /**
   * @description getAccountDetails
   * @author Mradul Maheshwari | 28-09-2021
   * @param accountNumber
   * @return String
   **/
  @AuraEnabled
  public static String getAccountDetails(String accountNumber) {
    User currentUser = new UsersSelector().selectById(UserInfo.getUserId());

    if (String.isBlank(currentUser.AB_Number__c)) {
      throw new AuraHandledException(
        'Error: Blank value provided for currentUser AB_Number__c.'
      );
    }

    if (String.isBlank(accountNumber) || accountNumber == null) {
      throw new AuraHandledException(
        'Error: Blank value provided for Account Number'
      );
    }

    AccountEnquiry_Resp_IB_V1 responseBean = AccountEnquiry_IH_V1.accountEnquiryRequest(
      accountNumber,
      currentUser.AB_Number__c
    );

    if (responseBean.statusCode != 200) {
      throw new AuraHandledException('Error: ' + responseBean.message);
    }

    if (responseBean == null) {
      throw new AuraHandledException(
        'Error: Blank response received from service.'
      );
    }

    if (
      responseBean?.NBSAPDPO == null ||
      responseBean?.MLB857O.MLB857O_OUTPUT_AREA?.MLB857O_ERROR_CODE == null
    ) {
      throw new AuraHandledException(
        'Error: Unexpected response received from service'
      );
    }
    if (responseBean?.MLB857O?.MLB857O_OUTPUT_AREA?.MLB857O_ERROR_CODE != 0) {
      throw new AuraHandledException(
        'Error: Request returned with error code : ' +
        responseBean?.MLB857O?.MLB857O_OUTPUT_AREA?.MLB857O_ERROR_CODE +
        ' with error message : ' +
        responseBean?.MLB857O?.MLB857O_OUTPUT_AREA?.MLB857O_ERROR_MSG
      );
    }

    return JSON.serialize(responseBean);
  }

  /**
   * @description getDocumentData
   * @author Mradul Maheshwari | 28-09-2021
   * @param accountDetails
   * @param accountId
   * @param caseRecordId
   * @return String
   **/
  @AuraEnabled
  public static String getDocumentData(
    String accountDetails,
    String accountId,
    String caseRecordId
  ) {
    String documentTemplateName = System.Label.HL_Account_Enquiry_Document_template;

    AccountEnquiry_Resp_IB_V1 responseBean = (AccountEnquiry_Resp_IB_V1) JSON.deserialize(
      accountDetails,
      AccountEnquiry_Resp_IB_V1.class
    );

    Account accountRecord = new AccountsSelector().selectAllById(accountId);
    DocumentTemplateProcessor.ContextBuilder contextBuilder = getContextBuilder(
      responseBean,
      accountRecord
    );
    Document_Template__c documentTemplate = new DocumentTemplateSelector()
      .selectTemplateByName(documentTemplateName);

    Map<String, String> params = GenerateDocument.setECMParam(
      accountRecord,
      documentTemplate
    );

    documentTemplate = getDocumentTemplate(responseBean, documentTemplate);

    //Generate document
    DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
    CC_GenerateContentResponse generateDocumentResponse = documentTemplateProcessor.generateDocument(
      contextBuilder,
      documentTemplate,
      params
    );
    if (!Test.isRunningTest()) {
      if (String.isBlank(generateDocumentResponse?.contentStoreToken)) {
        throw new AuraHandledException(
          'Error: Document generation using DocumentTemplateProcessor service failed. Response: ' +
          JSON.serialize(generateDocumentResponse)
        );
      }
    }
    //Retrieve generated document
    Map<String, String> credentials = ECM_IH_V1.getCredentials();
    ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(
      credentials.get('store'),
      credentials.get('username'),
      credentials.get('password')
    );

    ECM_GetResult_IB_V1 getResult;
    if (!Test.isRunningTest()) {
      getResult = ECM_IH_V1.getDocument(
        login.token,
        generateDocumentResponse.contentStoreToken
      );
    }
    if (String.isBlank(getResult?.Content?.data)) {
      throw new AuraHandledException(
        'Error: Document download using ECM_IH_V1 service failed. Response: ' +
        JSON.serialize(getResult)
      );
    }
    return getResult.Content.data;
  }

  /**
   * @description sendEmail
   * @author Mradul Maheshwari | 28-09-2021
   * @param pdfData
   * @param email
   * @param caseId
   * @param accountId
   * @param accountDetails
   * @return String
   **/
  @AuraEnabled
  public static String sendEmailAttachment(
    String pdfData,
    String email,
    String caseId,
    String accountId,
    String accountDetails
  ) {
    String documentTemplateName = System.Label.HL_Account_Enquiry_Document_template;

    AccountEnquiry_Resp_IB_V1 responseBean = (AccountEnquiry_Resp_IB_V1) JSON.deserialize(
      accountDetails,
      AccountEnquiry_Resp_IB_V1.class
    );

    String accountNumber = String.valueOf(
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_ACCT_NBR
    );

    Account accountRecord = new AccountsSelector().selectAllById(accountId);
    DocumentTemplateProcessor.ContextBuilder contextBuilder = getContextBuilder(
      responseBean,
      accountRecord
    );
    Document_Template__c documentTemplate = new DocumentTemplateSelector()
      .selectTemplateByName(documentTemplateName);

    Map<String, String> params = GenerateDocument.setECMParam(
      accountRecord,
      documentTemplate
    );
    params.put('password', accountNumber);
    documentTemplate = getDocumentTemplate(responseBean, documentTemplate);

    //Generate document
    DocumentTemplateProcessor documentTemplateProcessor = new DocumentTemplateProcessor();
    CC_GenerateContentResponse generateDocumentResponse;
    if (!Test.isRunningTest()) {
      generateDocumentResponse = documentTemplateProcessor.generateDocument(
        contextBuilder,
        documentTemplate,
        params //,
        // accountNumber
      );

      if (String.isBlank(generateDocumentResponse?.contentStoreToken)) {
        throw new AuraHandledException(
          'Error: Document generation using DocumentTemplateProcessor service failed. Response: ' +
          JSON.serialize(generateDocumentResponse)
        );
      }
    }
    String protectedDocument;
    //Retrieve generated document
    Map<String, String> credentials = ECM_IH_V1.getCredentials();
    ECM_LoginResult_IB_V1 login = ECM_IH_V1.login(
      credentials.get('store'),
      credentials.get('username'),
      credentials.get('password')
    );
    ECM_GetResult_IB_V1 getResult;
    if (!Test.isRunningTest()) {
      getResult = ECM_IH_V1.getDocument(
        login.token,
        generateDocumentResponse.contentStoreToken
      );

      if (String.isBlank(getResult?.Content?.data)) {
        throw new AuraHandledException(
          'Error: Document download using ECM_IH_V1 service failed. Response: ' +
          JSON.serialize(getResult)
        );
      }
      protectedDocument = getResult.Content.data;
    } else {
      protectedDocument = 'test';
    }

    String emailTemplateName = System.label.HL_Account_Enquiry_Email_Template;
    OrgWideEmailAddress owea = [
      SELECT Id, Address
      FROM OrgWideEmailAddress
      WHERE Address = :System.Label.Absa_Home_Email
    ];

    if (owea != null) {
      Map<String, String> replaceMap = new Map<String, String>();
      replaceMap.put(
        '{account}',
        accountNumber.subString(accountNumber.length() - 4)
      );

      String returnString = EmailHandler.sendEmailAttachmentWithHTMLMergeFields(
        replaceMap,
        owea.Id,
        protectedDocument,
        caseId,
        email,
        emailTemplateName,
        System.Label.HL_Account_Enquiry_Document_Name
      );

      if (returnString == 'Email sent Successfully.') {
        Attachment att = new Attachment();
        att.Name = System.Label.HL_Account_Enquiry_Document_Name;
        att.Body = EncodingUtil.base64Decode(pdfData);
        att.parentId = caseId;
        insert att;
      }

      return returnString;
    } else {
      //Error - No OrgWideEmailAddress found
      throw new AuraHandledException(
        'Error: Unable to find a matching Org Wide Email Address from the Email Address specified on the Service_Group__c of this Case. '
      );
    }
  }

  /**
   * @description getDocumentTemplate
   * @author Mradul Maheshwari | 28-09-2021
   * @param responseBean
   * @param documentTemplate
   * @return Document_Template__c
   **/
  public static Document_Template__c getDocumentTemplate(
    AccountEnquiry_Resp_IB_V1 responseBean,
    Document_Template__c documentTemplate
  ) {
    String secondaryAccountXml = '';
    for (
      AccountEnquiry_Resp_IB_V1.MLB857O_SEC_ACCT_DETAIL sec : responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_SEC_ACCT_DETAIL
    ) {
      if (sec.MLB857O_SE_ACCT_NBR != 0) {
        String secAcc =
          '<Linked_x0020_Accounts><MLB857O_SE_ACCT_NBR>' +
          sec.MLB857O_SE_ACCT_NBR +
          '</MLB857O_SE_ACCT_NBR>' +
          '<MLB857O_SE_OUTST_BAL>' +
          sec.MLB857O_SE_OUTST_BAL +
          '</MLB857O_SE_OUTST_BAL> </Linked_x0020_Accounts>';
        secondaryAccountXml += secAcc;
      }
    }

    if (documentTemplate.XML__c != null) {
      documentTemplate.XML__c = documentTemplate.XML__c.replace(
        '{SecondaryAccInfo}',
        secondaryAccountXml
      );
    }
    return documentTemplate;
  }

  /**
   * @description getContextBuilder
   * @author Mradul Maheshwari | 28-09-2021
   * @param responseBean
   * @param accountRecord
   * @return DocumentTemplateProcessor.ContextBuilder
   **/
  public static DocumentTemplateProcessor.ContextBuilder getContextBuilder(
    AccountEnquiry_Resp_IB_V1 responseBean,
    Account accountRecord
  ) {
    DocumentTemplateProcessor.ContextBuilder contextBuilder = new DocumentTemplateProcessor.ContextBuilder();
    contextBuilder.add('AccountName', accountRecord.Name);
    contextBuilder.add(
      'ERFNBR',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_ERF_NBR
    );
    contextBuilder.add(
      'Township',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_TOWNSHIP
    );
    contextBuilder.add(
      'city',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_CITY
    );
    contextBuilder.add(
      'propertyType',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_PROPERTY_DESCR
    );
    contextBuilder.add(
      'unitNBR',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_UNIT_NBR
    );
    contextBuilder.add(
      'portion',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_PORTION
    );
    contextBuilder.add(
      'complex',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_COMPLEX_NAME
    );
    contextBuilder.add(
      'accountNumber',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_ACCT_NBR
    );
    contextBuilder.add(
      'loanGrantAmount',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_BOND_AMT
    );
    contextBuilder.add(
      'registrationDate',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_BOND_REG_DATE
    );
    contextBuilder.add(
      'termLoan',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_TERM_OF_LOAN
    );
    contextBuilder.add(
      'remainingTerm',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_REMAINING_TERM
    );

    contextBuilder.add(
      'rate',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_EFF_ACCT_RATE
    );
    contextBuilder.add(
      'outstandingBalance',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_OUTST_BAL
    );
    contextBuilder.add(
      'dueDay',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_DUE_DAY
    );
    contextBuilder.add(
      'basicInterest',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_BASIC_INST
    );
    contextBuilder.add(
      'hoc',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_PROV_HOC
    );
    contextBuilder.add(
      'hmp',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_PROV_HMP
    );
    contextBuilder.add(
      'endowment',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_PROV_ENDOWMENT
    );
    contextBuilder.add(
      'adminFee',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_PROV_ADMIN_FEE
    );

    contextBuilder.add(
      'totalInstallment',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_INST_DETAIL.MLB857O_PR_TOTAL_INST
    );

    contextBuilder.add(
      'anivDate',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PROPERTY_DETAIL[0]
        .MLB857O_HOC_ANIV_DATE
    );
    contextBuilder.add(
      'flexiAmount',
      responseBean.MLB857O.MLB857O_OUTPUT_AREA.MLB857O_PRIM_ACCT_DETAIL.MLB857O_PR_FLEXI_AMT_AVAIL
    );

    return contextBuilder;
  }
}