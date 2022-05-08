/**
* @description Apex class for controlOfficerLinkingBankerDetails Lightning Component
*
* @author  Diksha : Absa
* @version v1.0
* @since   2020-06-11
*/

public class controlOfficerLinkingBankerDetailsCon {

    /**
    * @description 
    * @author muvhuso.nekhubvi@absa.africa | 2021-06-07 
    * @param oppId 
    * @return string
    **/
    @AuraEnabled
    public static string LinkBanker(string oppId){
        String messageText ; //to store Service Response message
        String confirmationStatus ;
        String GrpOrInv;
        String ControlOfficerType;
        String BusinessSeg;
        String BusinessSubSeg;
        String FranchiseSec;
        String BankingSector;
        Boolean result;
        Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
        string approvedByEmp = System.Label.ApprovedByEmp;
        Account accounts = new AccountsSelector().selectByOpportunityId(oppId);
 
        //To get the translated values

        Map<String,string> CMSTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName('CMS','Outbound');
        System.debug('CMSTranslatedMap'+CMSTranslatedMap);

        if(!CMSTranslatedMap.isEmpty() && CMSTranslatedMap!=null){

            if(String.isNotEmpty(opp.Business_Segment_Indicator__c))
                BusinessSeg = CMSTranslatedMap.get(opp.Business_Segment_Indicator__c);
            system.debug('String BusinessSeg'+BusinessSeg);

            if(String.isNotEmpty(opp.Business_Sub_Segment_Indicator__c))
                //BusinessSubSeg = CMSTranslatedMap.get(opp.Business_Sub_Segment_Indicator__c);
                BusinessSubSeg = CMSTranslatedMap.get(opp.Account.Agricultural_Sub_Type__c);//W-006585

            if(String.isNotEmpty(opp.Franchise_Sector__c))
                FranchiseSec = CMSTranslatedMap.get(opp.Franchise_Sector__c);

            if(String.isNotEmpty(opp.Banking_Sector__c))
                BankingSector = CMSTranslatedMap.get(opp.Banking_Sector__c);
        }

        String CIF=opp.CIF_Number__c ;
        if(CIF == null){
            CIF = '';
        }
        String BranchRegionSite = opp.Branch_Region_Site__c ;
        if(BranchRegionSite == null){
            BranchRegionSite = '';
        }

        if(String.isNotEmpty(opp.Group_or_Individual__c))
            GrpOrInv = opp.Group_or_Individual__c.substring(0,1) ;
        if(GrpOrInv == null){
            GrpOrInv = '';
        }
        if(String.isNotEmpty(opp.Control_Officer_Type__c))
            ControlOfficerType = opp.Control_Officer_Type__c.substringBefore('–');
        if(ControlOfficerType == null){
            ControlOfficerType = '';
        }
        String ControlOfficerNumber = opp.Control_Officer_Number__c;
        if(ControlOfficerNumber == null){
            ControlOfficerNumber = '';
        }
        String AppByEmp = approvedByEmp;
        if(AppByEmp == null){
            AppByEmp = '';
        }
        String CapByEmp = opp.Captured_by_Employee__c;
        if(CapByEmp == null){
            CapByEmp = '';
        }
        String OverallSiteCode = opp.Overall_Site_Code__c;
        if(OverallSiteCode == null){
            OverallSiteCode = '0';
        }
        String BusinessSegIndi = BusinessSeg;
        if(BusinessSegIndi == null){
            BusinessSegIndi = '';
        }
        String BusinessSubSegIndi = BusinessSubSeg;
        if(BusinessSubSegIndi == null){
            BusinessSubSegIndi = '';
        }
        String FranchiseSector = FranchiseSec;
        if(FranchiseSector == null){
            FranchiseSector = '0';
        }

        String BranchSector = BankingSector;
        if(BranchSector == null){
            BranchSector = '';
        }

        try{
            Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1(CIF ,BranchRegionSite ,BranchSector,GrpOrInv ,ControlOfficerType,ControlOfficerNumber,CapByEmp,AppByEmp,OverallSiteCode,BusinessSegIndi,BusinessSubSegIndi,FranchiseSector);
            GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
            //Logging the request
            List<Sys_Log_Integration__c> GBcreateCmsContOffLinkV1Logs = responseMap.values()[0];
            if(GBcreateCmsContOffLinkV1Logs!=null && !GBcreateCmsContOffLinkV1Logs.isEmpty()){
                Insert GBcreateCmsContOffLinkV1Logs;
            } // Insert logs if its present

            // String messageText ; //to store Service Response message
            if((responseBean != Null ) && (responseBean.statusCode == 200) ){
                messageText = responseBean.GBcreateCmsContOffLinkV1Response.Nbsmsgo3.msgEntry.msgTxt ;
                confirmationStatus = responseBean.GBcreateCmsContOffLinkV1Response.Gsp020o.confirmation;
                result = messageText.contains('Already Exists');
                
                //Tdb - Map response to Account - Captured response mean successful linking
                if(confirmationStatus != null && confirmationStatus.toUpperCase() == 'CAPTURED' ) {
                    opp.CMS_Linking_Status__c = 'CAPTURED';
                    messageText = opp.CMS_Linking_Status__c;
                    opp.StageName = accounts.SPM_Platform_Type__c == null ? 'Provide and Record Client Advice' : opp.StageName;

                } else if (messageText != null && messageText.toUpperCase() == 'Control Officer Type Already Exists For Client' && (opp.CMS_Linking_Status__c == 'CAPTURED' || opp.CMS_Linking_Status__c == '' || opp.CMS_Linking_Status__c == null )) {
                    opp.CMS_Linking_Status__c = 'CAPTURED';
                    messageText = messageText;
                    opp.StageName = accounts.SPM_Platform_Type__c == null ? 'Provide and Record Client Advice' : opp.StageName;

                } else if(result){
                    opp.CMS_Linking_Status__c = 'CAPTURED';       
                }else {
                    if(confirmationStatus != null) {
                        opp.CMS_Linking_Status__c = confirmationStatus + ' ' + messageText;
                    } else {
                        opp.CMS_Linking_Status__c = messageText;
                    }
                    
                    messageText = opp.CMS_Linking_Status__c;
                }

                System.debug('#####' + responseBean.serialize(responseBean) + '#####');
            }
            else{
                messageText = 'CMS service failed';
            }
            
            update opp;
            return messageText;
        } catch(Exception e){
            System.debug('Exception Occured' + e.getMessage() + 'At Line number' + e.getLineNumber());
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
    }
}