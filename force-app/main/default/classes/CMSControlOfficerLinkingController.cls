/**
*@description this class used to link multiple control officers
*Apex Class CMSControlOfficerLinkingController
* @author  Anka Ganta : Absa
* @version v1.0
* @since   2020-01-31
*
*/
public class CMSControlOfficerLinkingController {
    
    /** 
    * @description get all the cms records selected
    * @param oppRecId
    * @return List<CMS_Control_Officer_Linking__c>
    */
    @AuraEnabled
    public static List<CMS_Control_Officer_Linking__c> displayContrOffcRecs(String oppRecId){
        List<CMS_Control_Officer_Linking__c> allCMSContrOffcRecs = new List<CMS_Control_Officer_Linking__c>();
        If(oppRecId != null){
            CMSControlOfficerLinkingSelector cmsSelector = new CMSControlOfficerLinkingSelector();
            allCMSContrOffcRecs = cmsSelector.cmsRecsRelatedToOpp(oppRecId);
        }
        return allCMSContrOffcRecs;
    }
    
    /** 
    * @description update all the cms records selected
    * @param contrOffcRecs
    * @return List<CMS_Control_Officer_Linking__c>
    */
    @AuraEnabled
    public static List<CMS_Control_Officer_Linking__c> updateCMSContrOffcRecs(List<CMS_Control_Officer_Linking__c> contrOffcRecs ){
        Try{     
            update contrOffcRecs;
            return contrOffcRecs;
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
    }
    /** 
    * @description delete selected cms records selected
    * @param oppId 
    * @param contOffcRecsIds
    * @return String
    */
    @AuraEnabled
    public static String deleteCMSContrOffcRecs(String oppId, List<String> contOffcRecsIds ){
        Try{     
           
            List<CMS_Control_Officer_Linking__c> deleteList = [select id from CMS_Control_Officer_Linking__c where ID IN: contOffcRecsIds];
            delete deleteList;
            return 'success';
        }
        catch (Exception e) {
            throw new AuraHandledException('Something went wrong: '+ e.getMessage());
        }
    }
    
    /** 
    * @description delete selected cms records selected
    * @param newCntrOffcRecord
    * @param oppRecId
    * @return List<CMS_Control_Officer_Linking__c>
    */
    @AuraEnabled
    public static List<CMS_Control_Officer_Linking__c> createNewCntrOffcRec(CMS_Control_Officer_Linking__c newCntrOffcRecord,String oppRecId){
        Try{ 
            if(newCntrOffcRecord != null) {  
                newCntrOffcRecord.Opportunity__c = oppRecId;
                insert newCntrOffcRecord;
                //Get alladdresses link
                return displayContrOffcRecs(newCntrOffcRecord.Opportunity__c);
            } else {
                return null;
            }
        }
        catch (Exception e) {
            throw new AuraHandledException('Exception : '+ e.getMessage());
        }
    }
    
   /** 
    * @description link cms records selected
    * @param oppId
    * @param contOffcRecs
    * @return List<String>
    */
    @AuraEnabled
    public static List<String> linkBankersSelected(String oppId,List<String> contOffcRecs){    
        String messageText = '' ; //to store Service Response message
        String confirmationStatus ;
        String GrpOrInv;
        String ControlOfficerType;
        String BusinessSeg;
        String BusinessSubSeg;
        String FranchiseSec;
        String BankingSector;  
        String BranchRegionSite;
        String ControlOfficerNumber;
        String CapByEmp;
        String OverallSiteCode;
        Boolean result;
        
        Set<String> contOffcRecsSet = new Set<String>();
        contOffcRecsSet.addAll(contOffcRecs);
        Opportunity opp = new OpportunitiesSelector().selectByOpptId(oppId);
        
        CMSControlOfficerLinkingSelector cmsSelector = new CMSControlOfficerLinkingSelector();
        List<CMS_Control_Officer_Linking__c> allCMSContrOffcRecs = cmsSelector.selectByIds(contOffcRecsSet);
        List<String> errorList = new List<String>();                              
        string approvedByEmp = System.Label.ApprovedByEmp;
        
        String CIF=opp.CIF_Number__c ;
        if(CIF == null){CIF = '';}
        //W-006585 -2020-12-03 -Anka Ganta
        AccountsSelector acs = new AccountsSelector();
        Account acc = acs.selectByOpportunityId(oppId);
        List<Sys_Log_Integration__c> GBcreateCmsContOffLinkV1LogsAll = new List<Sys_Log_Integration__c>();
        //To get the translated values
        
        Map<String,string> CMSTranslatedMap = Sys_Utilities_Integration.getIntegrationTranslationBySystemName('CMS','Outbound');
        
        for(CMS_Control_Officer_Linking__c cmsLinking:allCMSContrOffcRecs){
            if(!CMSTranslatedMap.isEmpty() && CMSTranslatedMap!=null || Test.isRunningTest()){
                //String ControlOfficerType;
                if(String.isNotEmpty(cmsLinking.Business_Segment_Indicator__c)){
                    BusinessSeg = CMSTranslatedMap.get(cmsLinking.Business_Segment_Indicator__c);
                }else{ BusinessSeg = '';}
                
                if(String.isNotEmpty(cmsLinking.Business_Sub_Segment_Indicator__c)){
                    //BusinessSubSeg = CMSTranslatedMap.get(opp.Business_Sub_Segment_Indicator__c);
                    BusinessSubSeg = CMSTranslatedMap.get(acc.Agricultural_Sub_Type__c);//W-006585
                }else{BusinessSubSeg = '';}
                
                if(String.isNotEmpty(cmsLinking.Franchise_Sector__c)){
                    FranchiseSec = CMSTranslatedMap.get(cmsLinking.Franchise_Sector__c);
                }else{FranchiseSec = '0';}
                
                if(String.isNotEmpty(cmsLinking.Banking_Sector__c)){
                    BankingSector = CMSTranslatedMap.get(cmsLinking.Banking_Sector__c);
                }else{BankingSector = '';}
                
                if(String.isNotEmpty(cmsLinking.Branch_Region_Site__c)){
                    BranchRegionSite = cmsLinking.Branch_Region_Site__c;
                } else {BranchRegionSite = '';}
                //START-updated code to map to domicile savings account mapping 'newSiteCode' always take first entry
                if(String.isEmpty(opp.Branch_Region_Site__c)){
                    opp.Branch_Region_Site__c = cmsLinking.Branch_Region_Site__c;
                    
                } else {opp.Branch_Region_Site__c = '';}//END

                
                if(String.isNotEmpty(cmsLinking.Group_or_Individual__c)){
                    GrpOrInv = cmsLinking.Group_or_Individual__c.substring(0,1) ;
                }else{GrpOrInv = '';}
                
                if(String.isNotEmpty(cmsLinking.Control_Officer_Type__c)){
                    ControlOfficerType = cmsLinking.Control_Officer_Type__c.substringBefore('–');
                    
                }else{ControlOfficerType = '';}
                if(String.isNotEmpty(cmsLinking.Control_Officer_Number__c)){
                    ControlOfficerNumber = cmsLinking.Control_Officer_Number__c;
                } else {ControlOfficerNumber = '';}
                
                if(String.isNotEmpty(cmsLinking.Captured_by_Employee__c)){
                    CapByEmp = cmsLinking.Captured_by_Employee__c;
                }else{CapByEmp = '';}
                
                if(String.isNotEmpty(cmsLinking.Overall_Site_Code__c)){
                    OverallSiteCode = cmsLinking.Overall_Site_Code__c;
                }  else{OverallSiteCode = '0';}
                try{
                    
                    Map<GBcreateCmsContOffLinkV1_Resp_IB_v1, List<Sys_Log_Integration__c>> responseMap = 
                        GBcreateCmsContOffLinkV1_IH_v1.GBcreateCmsContOffLinkV1
                        (CIF ,BranchRegionSite ,BankingSector,GrpOrInv ,ControlOfficerType,ControlOfficerNumber,CapByEmp,approvedByEmp,OverallSiteCode,BusinessSeg,BusinessSubSeg,FranchiseSec);
                    GBcreateCmsContOffLinkV1_Resp_IB_v1 responseBean = (new List<GBcreateCmsContOffLinkV1_Resp_IB_v1>(responseMap.keySet()))[0];
                    //Logging the request
                    List<Sys_Log_Integration__c> GBcreateCmsContOffLinkV1Logs = responseMap.values()[0];
                    if(GBcreateCmsContOffLinkV1Logs!=null && !GBcreateCmsContOffLinkV1Logs.isEmpty()){
                        GBcreateCmsContOffLinkV1LogsAll.addAll(GBcreateCmsContOffLinkV1Logs);} // Insert logs if its present
                    
                    // String messageText ; //to store Service Response message nbrUserErrs
                    if((responseBean != Null ) && (responseBean.statusCode == 200)){
                        if(responseBean.GBcreateCmsContOffLinkV1Response.Nbsmsgo3.msgEntry.msgTxt != null){
                            messageText = responseBean.GBcreateCmsContOffLinkV1Response.Nbsmsgo3.msgEntry.msgTxt ;
                            result = messageText.contains('Already Exists');
                        }
                        confirmationStatus = responseBean.GBcreateCmsContOffLinkV1Response.Gsp020o.confirmation; 
                        
                        //Tdb - Map response to Account - Captured response mean successful linking
                        if(confirmationStatus != null && confirmationStatus.toUpperCase() == 'CAPTURED' ) {
                            opp.CMS_Linking_Status__c = 'CAPTURED';
                        } else if (messageText != null && messageText.toUpperCase().contains('ALREADY EXISTS FOR CLIENT') && (opp.CMS_Linking_Status__c == 'CAPTURED' || opp.CMS_Linking_Status__c == '' || opp.CMS_Linking_Status__c == null )) {
                            opp.CMS_Linking_Status__c = 'CAPTURED';
                            errorList.add(messageText + ' ' + 'Control Officer Type' + ' ' +  ControlOfficerType + 'with Status' + ' ' + confirmationStatus);
                        } else if(result){
                            opp.CMS_Linking_Status__c = 'CAPTURED';
                            errorList.add(messageText + ' ' + 'Control Officer Type' + ' ' +  ControlOfficerType + 'with Status' + ' ' + confirmationStatus);
                        }else {
                            if(confirmationStatus != null) {
                                errorList.add(messageText + ' ' + 'Control Officer Type' + ' ' +  ControlOfficerType + 'with Status' + ' ' + confirmationStatus);
                            } else {
                                errorList.add(messageText + ' ' + 'Control Officer Type' + ' ' +  ControlOfficerType + 'with Status' + ' ' + confirmationStatus);
                            }
                            opp.CMS_Linking_Status__c = String.valueOf(errorList);
                            
                            //messageText = opp.CMS_Linking_Status__c;
                        }
                        
                        
                    }
                    else{
                        messageText  = messageText + 'CMS service failed for' + ' ' + 'Control Officer Type' + ' ' + ControlOfficerType;
                       
                        errorList.add(messageText);
                    }
                } catch(Exception e){
                    
                    throw new AuraHandledException('Something went wrong: '+ e.getMessage());
                }
                
            }
        }
        update opp;
        insert GBcreateCmsContOffLinkV1LogsAll;
        return errorList;
    }

    /**
     * @description A method to validated that documents do not get uploaded when Opportunity is closed : W-008562
     * @author Anka Ganta
     * @created 07062021
     * @param recordId
     * @return String
     **/
    @AuraEnabled
    public static String validateOpportunityStage(String recordId){
        Opportunity OpportunityToValidate = new OpportunitiesSelector().selectByOppId(recordId);
        return OpportunityToValidate.StageName;
    }
    
}