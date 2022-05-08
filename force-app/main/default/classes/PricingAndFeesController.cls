/**
 * @description       :
 * @author            : almas.aleem@absa.africa
 * @last modified on  : 2021-07-13
 * @last modified by  : Saurabh
 * Modifications Log
 * Ver   Date         Author                    Modification
 * 1.0   2021-07-13   almas.aleem@absa.africa   Initial Version
**/

public class PricingAndFeesController {


    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @return List<FieldWrapper>
    **/
    @auraEnabled
    public static List<FieldWrapper> getfWrapperList(){

        //read metadata---
        List< OverdraftTOBFields__mdt> productFieldList = [SELECT MasterLabel,FieldName__c FROM OverdraftTOBFields__mdt];

        List<FieldWrapper> fieldWrapList = new List<FieldWrapper>();
        for(OverdraftTOBFields__mdt productField : productFieldList){

            if(productField.MasterLabel == 'Initiation Fee' || productField.MasterLabel == 'Prime + %' ){
                List <String> fieldnames = productField.FieldName__c.split(',');
                FieldWrapper fieldWrap = new FieldWrapper();
                fieldWrap.DescText =productField.MasterLabel;
                fieldWrap.editableFields = new List<EditableFields>();
                for(String field : fieldnames){
                    editableFields editf = new editableFields();
                    editf.fieldName = field;
                    editf.isReadOnly = true;  //for other fields which are not editable



                    if(productField.MasterLabel == 'Initiation Fee') {
                        if(field == 'Adjusted_Number__c'||field == 'Pricing_Decision__c' || field =='Comments__c' ){
                            editf.isReadOnly = false;
                        }else{
                            editf.isReadOnly = true;
                        }

                    } if(productField.MasterLabel == 'Prime + %'  ){
                        if(field == 'Adjusted_Number__c' ||field == 'Pricing_Decision__c' || field =='Comments__c'){
                            editf.isReadOnly = false;
                        }else{
                            editf.isReadOnly = true;
                        }

                    }

                    fieldWrap.editableFields.add(editf);
                }

                fieldWrapList.add(fieldWrap);

            }else{
                continue;
            }
        }
        return fieldWrapList;


        /*List<FieldWrapper> fieldWrapList = new List<FieldWrapper>();

FieldWrapper  fieldWrap = new FieldWrapper();
fieldWrap.DescText = 'Prime + %';
fieldWrap.editableFields = new List<EditableFields>();
fieldWrap.editableFields.add( new editableFields('Existing_Account_Number__c', true));
fieldWrap.editableFields.add( new editableFields('Requested_Number__c', true));
fieldWrap.editableFields.add( new editableFields('PowerCurve_Offered_Number__c', true));
fieldWrap.editableFields.add( new editableFields('Final_Offered_Number__c', true));

fieldWrap.editableFields.add( new editableFields('Adjusted_Number__c', true));
//  fieldWrap.editableFields.add( new editableFields('Comments__c', true));
fieldWrap.FieldNames = new List<String> {'Existing_Account_Number__c','Requested_Number__c','PowerCurve_Offered_Number__c','Final_Offered_Number__c','Adjusted_Number__c','Comments__c'};
fieldWrapList.add(fieldWrap);




fieldWrap = new FieldWrapper();
fieldWrap.DescText = 'Initiation Fee';

fieldWrap.editableFields = new List<EditableFields>();
fieldWrap.editableFields.add( new editableFields('Existing_Account_Number__c', true));
fieldWrap.editableFields.add( new editableFields('Requested_Number__c', true));
fieldWrap.editableFields.add( new editableFields('PowerCurve_Offered_Number__c', true));
fieldWrap.editableFields.add( new editableFields('Final_Offered_Number__c', true));
fieldWrap.editableFields.add( new editableFields('Adjusted_Number__c', true));
// fieldWrap.editableFields.add( new editableFields('Comments__c', true));
fieldWrap.FieldNames = new List<String> {'Existing_Account_Number__c','Requested_Number__c','PowerCurve_Offered_Number__c','Final_Offered_Number__c','Adjusted_Number__c'};
fieldWrapList.add(fieldWrap);

return fieldWrapList;*/
    }


    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    **/
    public static void updateApprovePricing(Id oppId){
        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);

        //use selector later
        List<Terms_Of_Business__c> pricingtobList = [Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,Pricing_Decision__c
                                                     ,Comments__c,Existing_Account__c,Final_Offered__c,
                                                     Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,Adjusted_Number__c,
                                                     PowerCurve_Offered_Number__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                     PowerCurve_Offered_Date__c,Requested__c,
                                                     Requested_Number__c,Requested_Date__c from Terms_Of_Business__c  Where TOB_Classification__c='Pricing And Fees' AND (Tob_Description__c='Prime + %' OR Tob_Description__c='Initiation Fee')
                                                     AND Application_Product__r.Application_Product_Parent__c = null AND Application_Product__r.Product_Status__c='Accepted' AND Application_Product__r.Opportunity__c=:oppId  ];


        for(Terms_Of_Business__c tob :pricingtobList){
            if(tob.Tob_Description__c.equalsIgnoreCase('Prime + %') && tob.Pricing_Decision__c =='Approve'){
                tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ?tob.Final_Offered_Number__c :tob.Adjusted_Number__c  ;
            }
            if(tob.Tob_Description__c.equalsIgnoreCase('Initiation Fee') && tob.Pricing_Decision__c =='Approve'){
                tob.Final_Offered_Number__c = tob.Adjusted_Number__c == 0 ?tob.Final_Offered_Number__c :tob.Adjusted_Number__c  ;
            }

        }

        try{
            update pricingtobList;
            PCOCall8(oppId);
        }catch(dmlException e){
            system.debug('Exception e---'+e.getmessage());
        }

    }


    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    * @return List<PricingWrapper>
    **/
    @auraEnabled
    public static List<PricingWrapper> getproductPricing(Id oppId){
        /*List<ProductTermsOFBusinessController.ProductTOB> productTOBList = ProductTermsOFBusinessController.getProductTOBOrigination(oppId);
*/

        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);

        //use selector later
        List<Application_Product__c> existingProductList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,
                                                            toLabel(Product_Type__c) producttype,Review_Date__c, Expiry_Date__c,  NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c,
                                                            (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c
                                                             ,Comments__c,Existing_Account__c,Final_Offered__c,
                                                             Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                             PowerCurve_Offered_Number__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                             PowerCurve_Offered_Date__c,Requested__c,
                                                             Requested_Number__c,Requested_Date__c from Terms_Of_Business__r  Where TOB_Classification__c='Pricing And Fees' AND (Tob_Description__c='Prime + %' OR Tob_Description__c='Initiation Fee')) from Application_Product__c Where Id IN: appPrdList
                                                            AND Application_Product_Parent__c = null AND Product_Status__c='Accepted'  ];

        // List<Application_Product__History> historyList = new ApplicationProductSelector().selectApplicationProductHistory(appPrdList);

        Map<Id,List<Terms_Of_Business__c>> prodTobmap = new Map<Id,List<Terms_Of_Business__c>>();
        List<PricingWrapper> pricingList = new  List<PricingWrapper> ();

        for(Application_Product__c appProd: existingProductList){

            String accountNumber;
            if(appProd.Product_State__c == 'New'){
                accountNumber = appProd.Temp_Account_Number__c;
            }else{
                accountNumber = ''+appProd.Account_Number__c;
            }
            PricingWrapper ptob = new PricingWrapper();
            //  ptob.DescriptionWithFieldType = new Map<String,String>();
            ptob.appProdId = appProd.Id;

            ptob.limitType = appProd.Limit_Type__c;
            ptob.appProduct = appProd;
            ptob.appProductLabel = 'Overdraft Faciltiy' + '-'+appProd.Product_State__c+' '+accountNumber +'-'+appProd.Product_Status__c;

            for(Terms_Of_Business__c tob : appProd.Terms_Of_Business__r ){

                if(tob.Tob_Description__c.equalsIgnoreCase('Prime + %')){
                    ptob.pricingList.add(tob);
                }
                if(tob.Tob_Description__c.equalsIgnoreCase('Initiation Fee')){
                    ptob.pricingList.add(tob);
                }

                //ptob.pricingList.add(tob);
            }
            //ptob.tobList = prodTobmap.get(appProdId);
            pricingList.add(ptob);

        }

        return pricingList;

    }
    /**
* @description Product and TOB Wrapper
*/
    public Class PricingWrapper{
        @auraEnabled public Id appProdId;
        @auraEnabled public Application_Product__c appProduct;
        @auraEnabled public String appProductLabel;

        @auraEnabled public String limitType ;
        //  @auraEnabled public List<appProdHistory> appProductHistory;
        @auraEnabled public List<Terms_Of_Business__c> pricingList ;

         /**
* @description Product and TOB Wrapper
*/

        public PricingWrapper(){
            this.pricingList = new List<Terms_Of_Business__c> ();
            //this.appProductHistory = new List<appProdHistory>() ;
            this.appProduct = new Application_Product__c();
        }
    }

     /**
* @description Product and TOB Wrapper
*/public Class FieldWrapper{
        @auraEnabled public  String DescText;
        @auraEnabled public list <EditableFields> editableFields;
        @auraEnabled public List<String>  FieldNames;
        // @auraEnabled public Map<String,Boolean> EditableFields;
    }

     /**
* @description Product and TOB Wrapper
*/
public class EditableFields {
        @auraEnabled public String fieldName;
        @auraEnabled public Boolean isReadOnly;
        /*public EditableFields(String fieldName,Boolean isReadOnly){
this.fieldName = fieldName;
this.isReadOnly = isReadOnly;
}*/

    }

    //Pricing approval Controller part
    //

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    * @return String
    **/
    @auraEnabled
    public static String submitPricing(Id oppId){
        String message='';
        Boolean redirect;

        map<String,Boolean> returnresult = new  map<String,Boolean>();
        //  List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);

        //use selector later @Almas Aleem will add selector query
        List<Application_Product__c> existingProductList = [Select id, Name ,Product_Name__c,Account_Number__c,Product_State__c,Limit_Type__c,
                                                            (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c,
                                                             Adjusted_by_Sanctioner__c,Comments__c,Existing_Account__c,Final_Offered__c,
                                                             Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                             PowerCurve_Offered_Number__c,Adjusted_Number__c,Adjusted_Date__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                             PowerCurve_Offered_Date__c,Pricing_Decision__c,
                                                             Requested_Number__c,Requested_Date__c from Terms_Of_Business__r Where TOB_Classification__c='Pricing And Fees' AND (Tob_Description__c='Prime + %' OR Tob_Description__c='Initiation Fee') )from Application_Product__c Where Opportunity__c=:oppId
                                                            AND Application_Product_Parent__c = null AND Product_Status__c='Accepted' ];

        for(Application_Product__c appProd: existingProductList){
            for(Terms_Of_Business__c pricing : appProd.Terms_Of_Business__r ){
                if(pricing.Pricing_Decision__c == null){
                    // message = 'You have not made a decision for all pricing adjustments.';
                    message = 'Adjustments complete. You can proceed with approving the Pricing approval request ';
                    //returnresult.put(message, false);
                    returnresult.put(message, true);
                    continue;
                    //break;
                }if(pricing.Pricing_Decision__c == 'Approve' || pricing.Pricing_Decision__c == 'Decline' ){
                    message = 'Adjustments complete. You can proceed with approving the Pricing approval request ';
                    returnresult.put(message, true);
                    continue;
                }if(pricing.Pricing_Decision__c == 'Support'){
                    message = 'Adjustments complete. You can now reassign the Pricing approval request';
                    returnresult.put(message, true);
                    break;
                }
            }
        }
        //  PCOCall8(oppId);

        return message; //JSON.serializePretty(returnresult);
    }

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    *
    **/
    @auraEnabled
    public static void submitApprovalProcess(Id oppId){
        //send credit opp for pricing approval process
        User u = [select id, Name from User where id = :userInfo.getUserId()];
        //update opportunity
        Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);
        opp.Trigger_Approval_Process__c = 'Pricing';
        opp.Pricing_Refer_DateTime__c = system.now();
        opp.Is_Referred_Pricing__c = true;
        opp.Pricing_Referred_By__c = u.name;
        opp.Pricing_Decision__c = null;

        List<Application_Product__c> appPrdList = new ApplicationProductSelector().selectByOpportunityId(oppId);

        Application__c updateApp = [SELECT Id, Name, Credit_Application_Accepted__c, Credit_Application_Accepted_DateTime__c,Credit_Application_Acceptedby__c
                                    FROM Application__c where Opportunity__c=:oppId  LIMIT 1  ];



        //use selector later
        List<Application_Product__c> existingProductList = [Select id,Accept_TOB__c, Name ,Product_Name__c,Account_Number__c,Product_State__c,Product_Status__c,Limit_Type__c,Temp_Account_Number__c,
                                                            toLabel(Product_Type__c) producttype,Review_Date__c, Expiry_Date__c,  NCA_Appplicable__c, Maximum_NCA_Rate_Type__c,Maximum_NCA_Rate__c,
                                                            (Select id,Application_Product__c,TOB_Classification__c,Tob_Description__c
                                                             ,Comments__c,Existing_Account__c,Final_Offered__c,
                                                             Offered_by_Powercurve__c,Requested_Amount__c,Existing_Account_Number__c,Final_Offered_Number__c,
                                                             PowerCurve_Offered_Number__c,Existing_Account_Date__c,Final_Offered_Date__c,
                                                             PowerCurve_Offered_Date__c,Requested__c,
                                                             Requested_Number__c,Requested_Date__c from Terms_Of_Business__r  Where TOB_Classification__c='Pricing And Fees' AND (Tob_Description__c='Prime + %' OR Tob_Description__c='Initiation Fee')) from Application_Product__c Where Id IN: appPrdList
                                                            AND Application_Product_Parent__c = null AND Product_Status__c='Accepted'  ];



        for(Application_Product__c appProd: existingProductList){
            appProd.Accept_TOB__c = false;
            //appProd.Product_Status__c = '';
        }


        updateApp.Credit_Application_Accepted__c=false;
        updateApp.Credit_Application_Accepted_DateTime__c=null;
        updateApp.Credit_Application_Acceptedby__c='';

        try{
            update opp;
            update existingProductList;
            update updateApp;
            system.debug('call pco status update---');

            PCOStatusCall(Opp.id);
        }catch(DMLException e){
            system.debug('e---'+e.getCause());
        }

        // Create an approval request for the Opportunity
        Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
        req1.setComments('Submitting request for pricing approval');
        req1.setObjectId(oppId);
        //req1.setNextApproverIds(new Id[] {opp.Next_Approver__c});

        // Submit the approval request for the Opportunity
        Approval.ProcessResult result = Approval.process(req1);

        //Added by Himanshu -W-011453
        CreditDecisionSummaryController.submitActivityHistory(oppId, 'Activity History', 'Pricing requested by',u.Name, '0');
    }

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    * @return Id
    **/
    @auraEnabled
    public static Id isPricingApproval(Id oppId){
        Boolean ispricing;
        Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);
        Id workItemId = getWorkItemId(oppId);
        if(workItemId !=null){
            ispricing = true;
            return workItemId;
        }

        return null;
    }
    /* @auraEnabled
public static void rejectApprovalProcessForPricing(Id oppId){

system.debug('oppId---'+oppId);
Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);

Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
req.setComments('rejecting pricing');
req.setAction('Reject');

//Area Manager as approver
User banker = [SELECT Name, ManagerID, Manager.Name FROM User WHERE Id = : UserInfo.getUserId()]; //use selector later
if(banker.ManagerID != null){
req.setNextApproverIds(new Id[] {banker.ManagerID});
}

Id workItemId = getWorkItemId(oppId);

if(workItemId == null)
{
//opp.addError('Error Occured in Trigger');
system.debug('error');
}
else
{
req.setWorkitemId(workItemId);
// Submit the request for approval
Approval.ProcessResult result =  Approval.process(req);
}
}



@auraEnabled
public static void approveApprovalProcessForPricing(Id oppId){

system.debug('oppId---'+oppId);
Opportunity opp =new OpportunitiesSelector().selectBySanctioningSLAInfoById(oppId);

Approval.ProcessWorkitemRequest req = new Approval.ProcessWorkitemRequest();
req.setComments('Approving pricing');
req.setAction('Approve');

//req.setNextApproverIds(new Id[] {opp.Next_Approver__c});
Id workItemId = getWorkItemId(oppId);

if(workItemId == null)
{
//opp.addError('Error Occured in Trigger');
system.debug('error');
}
else
{
req.setWorkitemId(workItemId);
// Submit the request for approval
Approval.ProcessResult result =  Approval.process(req);
}
}

*/
    /**

* Get ProcessInstanceWorkItemId using SOQL

**/

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param targetObjectId
    * @return Id
    **/
    public static Id getWorkItemId(Id targetObjectId)

    {

        Id retVal = null;
        //later use selector

        for(ProcessInstanceWorkitem workItem  : [Select p.Id from ProcessInstanceWorkitem p

                                                 where p.ProcessInstance.TargetObjectId =: targetObjectId ])//AND  p.ProcessInstance.ProcessDefinition.Name ='Pricing Approval Process'

        {

            retVal  =  workItem.Id;

        }

        return retVal;

    }


    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    **/
    public static void updateCall8Return(Id oppId){
        List<Application_Product__c> appPrdList = [SELECT Product_Name__c, Product_Type__c, Temp_Account_Number__c,Product_Amount__c,Product_Status__c,
                                                   System_Decision__c, Final_Decision__c, Opportunity__c, Name, Id, Product_State__c
                                                   FROM Application_Product__c
                                                   where Opportunity__c = :oppId  AND Application_Product_Parent__c = null];


        SetProductTOBController.mapFromPCOResponse(appPrdList,'8');   //map fields

    }

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    **/
    @future(callout = true)
    public static void PCOCall8(Id oppId){
        if(!Test.isRunningTest()){
            PowerCurveController.pcoStageHandler(oppId, '08', false);
        }
    }

    /**
    * @description
    * @author almas.aleem@absa.africa | 2021-07-13
    * @param oppId
    **/
    @future(callout = true)
    public static void PCOStatusCall(Id oppId){
        if(!Test.isRunningTest()){
            PowerCurveStatusUpdate.pcoCallout(oppId);
        }
    }

}