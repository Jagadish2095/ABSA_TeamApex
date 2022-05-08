/**
 * @description       : Controller to handle financial spreading logic
 * @author            : Ravi B, Vara.
 * @group             :
 * @last modified on  : 2021-10-01
 * @last modified by  : Tawanda M.
 **/
public class CaseFlowController {
  public static final Map<String, String> spreadingPriorityPicklistValues = new Map<String, String>{
    'Yes' => 'Yes',
    'No' => 'No'
  };

  public static final Map<String, String> timeFramePicklistValues = new Map<String, String>{
    '4 hours' => '4 hours',
    'Next business day' => 'Next business day',
    'One week' => 'One week',
    'Two business days' => 'Two business days'
  };

  public static final Map<String, String> workItemPicklistValues = new Map<String, String>{
    'Absa Fund Managers' => 'Absa Fund Managers',
    'Absa Wealth' => 'Absa Wealth',
    'ADD Risk Acceptance' => 'ADD Risk Acceptance',
    'Commercial' => 'Commercial',
    'Commercial Asset Finance' => 'Commercial Asset Finance',
    'Corporate' => 'Corporate',
    'De Register Entity' => 'De Register Entity',
    'Enterprise' => 'Enterprise',
    'Fee/Interest Refund' => 'Fee/Interest Refund',
    'Instant Business' => 'Instant Business',
    'Instant Business (KYC)' => 'Instant Business (KYC)',
    'Merchants Service' => 'Merchants Service',
    'Migration in Absa Wealth' => 'Migration in Absa Wealth',
    'Non Registered PDLS' => 'Non Registered PDLS',
    'PEPS' => 'PEPS',
    'Porting' => 'Porting',
    'Private Bank' => 'Private Bank',
    'Project- HRR' => 'Project- HRR',
    'RC List on Active Accounts' => 'RC List on Active Accounts',
    'Vendor On Boarding' => 'Vendor On Boarding'
  };

  public static final Map<String, String> reasonPicklistValues = new Map<String, String>{
    'Incomplete Financials' => 'Incomplete Financials',
    'No Financials Attached' => 'No Financials Attached',
    'Wrong Financials Attached' => 'Wrong Financials Attached',
    'Request By The Instructor' => 'Request By The Instructor',
    'Not Relevant To RBEU Queue' => 'Not Relevant To RBEU Queue'
  };

  /**
    * @description Custom Exception Class
    * @author Tawanda M. | 07-20-2021 
    **/
    public class FSException extends Exception{}

  /**
   * @description Class Wrappers
   * @author Tawanda M. | 09-27-2021
   **/
  public class CaseWrapper {
    @AuraEnabled
    public Case caseRec;
    public CaseObjectWrapper caseObject;
    public List<CaseDocuments> caseDocuments;
    public Map<String, String> yesNoPicklistValues;
    public Map<String, String> timeFramePicklistValues;
    public Map<String, String> workItemPicklistValues;
    public Map<String, String> reasonPicklistValues;
  }
  /**
   * @description Class Wrappers
   * @author Tawanda M. | 09-27-2021
   **/
  public class CaseObjectWrapper {
    @AuraEnabled
    public string caseId;
    @AuraEnabled
    public string spreadingPriority;
    @AuraEnabled
    public string financials;
    @AuraEnabled
    public string groupLoans;
    @AuraEnabled
    public string timeFrame;
    @AuraEnabled
    public string consolidatedSpread;
    @AuraEnabled
    public string managementAccounts;
    @AuraEnabled
    public string projections;
    @AuraEnabled
    public string instructions;
    @AuraEnabled
    public string workItemClassification;
    @AuraEnabled
    public Boolean submitted;
    @AuraEnabled
    public String reason;
    @AuraEnabled
    public string sLAViolation;
    @AuraEnabled
    public string conciseInstruction;
    @AuraEnabled
    public String comments;
    @AuraEnabled
    public String parentState;
    @AuraEnabled
    public String accountId;
    @AuraEnabled
    public String sicCode;
    @AuraEnabled
    public String status;
    @AuraEnabled
    public Boolean isParent;
    @AuraEnabled
    public Boolean result;

    
    /**
    * @description Constructor
    * @author Tawanda M. | 09-27-2021 
    * @param caseId 
    * @param spreadingPriority 
    * @param financials 
    * @param groupLoans 
    * @param timeFrame 
    * @param consolidatedSpread 
    * @param managementAccounts 
    * @param projections 
    * @param instructions 
    * @param workItemClassification 
    * @param submitted 
    * @param reason 
    * @param sLAViolation 
    * @param conciseInstruction 
    * @param comments 
    * @param parentState 
    * @param accountId 
    * @param sicCode 
    * @param status 
    * @param isParent
    * @param result 
    **/
    public CaseObjectWrapper(
      String caseId,
      String spreadingPriority,
      String financials,
      String groupLoans,
      String timeFrame,
      String consolidatedSpread,
      String managementAccounts,
      String projections,
      String instructions,
      String workItemClassification,
      Boolean submitted,
      String reason,
      String sLAViolation,
      String conciseInstruction,
      String comments,
      String parentState,
      String accountId,
      String sicCode,
      String status,
      Boolean isParent,
      Boolean result
    ) {
      this.caseId = caseId;
      this.spreadingPriority = spreadingPriority;
      this.financials = financials;
      this.groupLoans = groupLoans;
      this.timeFrame = timeFrame;
      this.consolidatedSpread = consolidatedSpread;
      this.managementAccounts = managementAccounts;
      this.projections = projections;
      this.instructions = instructions;
      this.workItemClassification = workItemClassification;
      this.submitted = submitted;
      this.reason = reason;
      this.sLAViolation = sLAViolation;
      this.conciseInstruction = conciseInstruction;
      this.comments = comments;
      this.parentState = parentState;
      this.accountId = accountId;
      this.sicCode = sicCode;
      this.status = status;
      this.isParent = isParent;
      this.result = result;
    }
  }

  /**
   * @description Class Wrappers
   * @author Tawanda M. | 09-27-2021
   **/
  public class CaseDocuments {
    @AuraEnabled
    public Boolean isChecked;
    @AuraEnabled
    public String documentId;
    @AuraEnabled
    public String documentName;
    @AuraEnabled
    public date lastUpdatedDate;
  }

  // private static Map<String, String> getPicklistvalues(String objectAPIName, String fieldName) {
  //   Schema.SObjectType s = Schema.getGlobalDescribe().get(objectAPIName);
  //   Schema.DescribeSObjectResult r = s.getDescribe();
  //   Map<String, Schema.SObjectField> fields = r.fields.getMap();
  //   Schema.DescribeFieldResult fieldResult = fields.get(fieldName).getDescribe();
  //   List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
  //   Map<String, String> picklistValuesMap = new Map<String, String>();
  //   for (Schema.PicklistEntry pickListVal : ple) {
  //     picklistValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
  //   }
  //   return picklistValuesMap;
  // }

  /**
   * @description Init method to wrap all required data
   * @author Tawanda M. | 09-27-2021
   * @param caseObjId
   * @return String
   **/
  @AuraEnabled
  public static String getCaseDetailWrapper(String caseObjId) {
    try {
      Map<String, String> yesNoOptions = spreadingPriorityPicklistValues;
      Map<String, String> timeFrameOptions = timeFramePicklistValues;
      Map<String, String> workItemOptions = workItemPicklistValues;
      Map<String, String> reasonOptions = reasonPicklistValues;
      Case caseObj = [
        SELECT
          Id,
          CaseNumber,
          ParentId,
          AccountId,
          Comments,
          Reason,
          Status,
          SIC_Code__c,
          Account.Sic,
          Extended_Request_Data__c
        FROM Case
        WHERE Id = :caseObjId
        LIMIT 1
      ];

      CaseObjectWrapper caseObjWrap = new CaseObjectWrapper(
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        false,
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        '',
        false,
        false
      );
      //Read from custom field
      if (caseObj.Extended_Request_Data__c != null) {
        caseObjWrap = (CaseObjectWrapper) JSON.deserialize(caseObj.Extended_Request_Data__c, CaseObjectWrapper.class);
        caseObjWrap.caseId = caseObj.Id;
      } else {
        //Place important placeholder data
        caseObjWrap.caseId = caseObj.Id;
        caseObjWrap.accountId = caseObj.AccountId;
        caseObjWrap.isParent = true;
        //Tie SIC code from account
        if (caseObj.SIC_Code__c == null && caseObj.Account.Sic == null) {
          caseObjWrap.sicCode = caseObj.SIC_Code__c;
        } else if (caseObj.Account.Sic != null) {
          caseObjWrap.sicCode = caseObj.Account.Sic;
        } else {
          caseObjWrap.sicCode = caseObj.SIC_Code__c;
        }
        // Default text for empty comments
        caseObjWrap.comments = (caseObj.Comments == null ||
          caseObj.Comments == '')
          ? 'No Additional Comments Given.'
          : caseObj.Comments;
      }

      CaseWrapper casewrap = new CaseWrapper();
      casewrap.caseRec = caseObj;
      casewrap.caseObject = caseObjWrap;
      casewrap.yesNoPicklistValues = yesNoOptions;
      casewrap.timeFramePicklistValues = timeFrameOptions;
      casewrap.workItemPicklistValues = workItemOptions;
      casewrap.reasonPicklistValues = reasonOptions;
      List<CaseDocuments> documents = new List<CaseDocuments>();
      if (!caseObjWrap.isParent) {
        documents = getCaseDocuments(caseObj.ParentId);
      } else {
        documents = getCaseDocuments(caseObj.Id);
      }
      casewrap.caseDocuments = documents;

      return JSON.serialize(casewrap);
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }

  /**
   * @description Method is to update the parent level case as they step through the different tabs
   * @author Tawanda M. | 09-27-2021
   * @param caseObj
   **/
  @AuraEnabled
  public static void saveCaseObject(String caseObj) {
    try {
      CaseObjectWrapper caseWrap = (CaseObjectWrapper) JSON.deserialize(caseObj, CaseObjectWrapper.class);
      Case caseToUpdate = new Case();
      caseWrap.isParent = true;
      caseToUpdate.Id = caseWrap.caseId;
      caseToUpdate.Extended_Request_Data__c = JSON.serialize(caseWrap);
      //caseToUpdate.Spreading_priority__c = caseWrap.spreadingPriority;
      //caseToUpdate.Financials__c = caseWrap.financials;
      //caseToUpdate.Group_loans__c = caseWrap.groupLoans;
      //caseToUpdate.Time_frame__c = caseWrap.timeFrame;
      //caseToUpdate.Consolidated_spread__c = caseWrap.consolidatedSpread;
      //caseToUpdate.Management_accounts__c = caseWrap.managementAccounts;
      //caseToUpdate.Projections__c = caseWrap.projections;
      //caseToUpdate.Clear_Concise_Instructions__c = caseWrap.instructions;
      //caseToUpdate.Work_Item_Classification__c = caseWrap.workItemClassification;
      caseToUpdate.Status = caseWrap.status;
      //caseToUpdate.Financial_Spreading_Reason__c = caseWrap.reason;
      caseToUpdate.Comments = caseWrap.comments;
      caseToUpdate.SIC_Code__c = caseWrap.sicCode;

      update caseToUpdate;
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }
  /**
   * @description Method is to finalise/close the child case/request
   * @author Tawanda M. | 09-27-2021
   * @param caseObj
   **/
  @AuraEnabled
  public static void finaliseChildCase(String caseObj) {
    try {
      CaseObjectWrapper caseWrap = (CaseObjectWrapper) JSON.deserialize(caseObj, CaseObjectWrapper.class);
      Case caseToUpdate = new Case();
      caseToUpdate.Id = caseWrap.caseId;
      caseWrap.isParent = false;
      caseWrap.status = 'Closed';
      caseToUpdate.Extended_Request_Data__c = JSON.serialize(caseWrap);
      //caseToUpdate.Spreading_priority__c = caseWrap.spreadingPriority;
      //caseToUpdate.Financials__c = caseWrap.financials;
      //caseToUpdate.Group_loans__c = caseWrap.groupLoans;
      //caseToUpdate.Time_frame__c = caseWrap.timeFrame;
      //caseToUpdate.Consolidated_spread__c = caseWrap.consolidatedSpread;
      //caseToUpdate.Management_accounts__c = caseWrap.managementAccounts;
      //caseToUpdate.Projections__c = caseWrap.projections;
      //caseToUpdate.Clear_Concise_Instructions__c = caseWrap.instructions;
      //caseToUpdate.Work_Item_Classification__c = caseWrap.workItemClassification;
      //caseToUpdate.Submitted__c = caseWrap.submitted;
      //caseToUpdate.Financial_Spreading_Reason__c = caseWrap.reason;
      caseToUpdate.Status = 'Closed';
      caseToUpdate.SIC_Code__c = caseWrap.sicCode;
      //caseToUpdate.Financial_Spreading_Result__c = (caseWrap.result == true) ? 'Approved' : 'Rejected';
      update caseToUpdate;

      Case cs = [SELECT Id, ParentId, CaseNumber FROM Case WHERE Id = :caseToUpdate.Id];
      Case csParent = [SELECT Id, OwnerId, CaseNumber FROM Case WHERE Id = :cs.ParentId];

      //Decision
      String decision = (caseWrap.result == true) ? 'Approved' : 'Rejected';

      FeedItem post = new FeedItem();
      post.ParentId = cs.ParentId;
      post.Body =
        'Child case for financial spreading has been finalized and result is ' +
        decision +
        '. Parent Case Number is ' +
        csParent.CaseNumber;
      insert post;

      FeedItem ownerPost = new FeedItem();
      ownerPost.ParentId = csParent.OwnerId;
      ownerPost.Body =
        'Child case for financial spreading has been finalized and result is ' +
        decision +
        '. Parent Case Number is ' +
        csParent.CaseNumber;
      insert ownerPost;
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
  }
  /**
   * @description Method is to create child case from parent level
   * @author Tawanda M. | 09-27-2021
   * @param caseObj
   * @return String
   **/
  @AuraEnabled
  public static String createChildCase(String caseObj) {
    Case newChildCase = new Case();
    try {
      saveCaseObject(caseObj);
      CaseObjectWrapper caseWrap = (CaseObjectWrapper) JSON.deserialize(caseObj, CaseObjectWrapper.class);
      List<Case> checkChildren = [SELECT Id FROM Case WHERE ParentId = :caseWrap.caseId LIMIT 1];
      if (checkChildren.size() > 0) {
        throw new FSException('You cannot submit this case because it already has a child case associated to it.');
      }
      //newChildCase.Id = caseWrap.caseId;
      //newChildCase.Spreading_priority__c = caseWrap.spreadingPriority;
      //newChildCase.Financials__c = caseWrap.financials;
      //newChildCase.Group_loans__c = caseWrap.groupLoans;
      //newChildCase.Time_frame__c = caseWrap.timeFrame;
      //newChildCase.Consolidated_spread__c = caseWrap.consolidatedSpread;
      //newChildCase.Management_accounts__c = caseWrap.managementAccounts;
      //newChildCase.Projections__c = caseWrap.projections;
      //newChildCase.Clear_Concise_Instructions__c = caseWrap.instructions;
      //newChildCase.Work_Item_Classification__c = caseWrap.workItemClassification;
      caseWrap.isParent = false;
      caseWrap.status = 'Review Context';
      newChildCase.Extended_Request_Data__c = JSON.serialize(caseWrap);
      //newChildCase.SLA_Violation__c = caseWrap.sLAViolation;
      // newChildCase.Submitted__c = caseWrap.submitted;
      newChildCase.AccountId = caseWrap.accountId;
      newChildCase.Comments = caseWrap.comments;
      newChildCase.Status = 'Review Context';
      newChildCase.Type = 'Financial Spreading';
      newChildCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName()
        .get('Financial Spreading Maintenance')
        .getRecordTypeId();
      newChildCase.ParentId = caseWrap.caseId;
      newChildCase.OwnerId = [SELECT id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'CEEi_Queue'].id;
      newChildCase.SIC_Code__c = caseWrap.sicCode;

      insert newChildCase;

      FeedItem post = new FeedItem();
      post.ParentId = caseWrap.caseId;
      post.Body = 'New child case has been created for financial spreading.';
      insert post;
    } catch (Exception ex) {
      throw new AuraHandledException(ex.getMessage());
    }
    return newChildCase.id;
  }

  /**
   * @description Method is used to retrieve documents associated to financial spreading on parent and child level
   * @author Tawanda M. | 09-27-2021
   * @param caseId
   * @return List<CaseDocuments>
   **/
  public static List<CaseDocuments> getCaseDocuments(String caseId) {
    List<CaseDocuments> documents = new List<CaseDocuments>();
    for (ContentDocumentLink document : [
      SELECT ContentDocumentId, LinkedEntityId, ContentDocument.Title, ContentDocument.LastModifiedDate
      FROM ContentDocumentLink
      WHERE LinkedEntityId = :caseId AND LinkedEntity.Type = 'Case'
    ]) {
      CaseDocuments doc = new CaseDocuments();
      doc.isChecked = false;
      doc.documentId = document.ContentDocumentId;
      doc.documentName = document.ContentDocument.Title;
      doc.lastUpdatedDate = Date.valueOf(document.ContentDocument.LastModifiedDate);
      documents.add(doc);
    }
    return documents;
  }
}