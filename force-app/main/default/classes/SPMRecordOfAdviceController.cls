/**
* @description Extension Controller for Record Of Advice  Component for SPM Onboarding
* @author  Haritha P : Absa
* @version v1.0
* @since   2021-04-07
* @Testclass : SPMRecordOfAdviceControllerTest
* @param spmRoa
* @return roa
*/
public class SPMRecordOfAdviceController {
    /** 
    * @description get all the ROA records selected
    * @param OppId
    * @param QQ1
    * @param QQ2
    * @param QQ3
    * @param QQ4
    * @param QQ5
    * @param QQ6
    * @param QQ7
    * @param QQ8
    * @param QQ9
    * @param QQ10
    * @param QQ11
    * @param QQ12
    * @param QQ13
    * @param QQ14
    * @param QQ15
    * @param QQ16
    * @param QQ17
    * @param QQ18
    * @param QQ19
    * @param QQ20
    * @param QQ21
    * @param QQ22
    * @param QQ23
    * @param QQ24
    * @param QQ25
    * @param QQ26
    * @return List<Questionnaire_Answer__c>
    */
    @AuraEnabled
   public static List<Questionnaire_Answer__c>  createQuestionnaireRecordlist (Id OppId,string QQ1,string QQ2,string QQ3,string QQ4,string QQ5,string QQ6,string QQ7,string QQ8,string QQ9,string QQ10,string QQ11,string QQ12,
                                                                               string QQ13,string QQ14,string QQ15,string QQ16,string QQ17,string QQ18,string QQ19,string QQ20,string QQ21,string QQ22,string QQ23,string QQ24,string QQ25,string QQ26) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(OppId);
       List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
   LIST<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='SPM Record Of Advice'];
	List<Questionnaire_Answer__c> newQAnswerRecList =new List<Questionnaire_Answer__c> ();
     List<Questionnaire_Answer__c> oldQAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application__c=:app[0].Id AND Questionnaire_Template__r.Name='SPM Record Of Advice' ];
       if (!oldQAnswerRecList.isEmpty()){
           	delete oldQAnswerRecList;
        } 
       for (Questionnaire_Question__c qqname : questionnames){
           Questionnaire_Answer__c qqanswer=new Questionnaire_Answer__c();
          	qqanswer.Questionnaire_Question__c = qqname.Id;
           //	qqanswer.Questionnaire_Question__r.Question__c = qqname.Question__c;
            qqanswer.Questionnaire_Template__c=qqname.Questionnaire_Template__c;
           	qqanswer.Related_Opportunity__c=OppId;
           	qqanswer.Related_Application__c=app[0].Id;
            if (qqname.Question_Label__c == 'Client’s Investment objective has changed from that indicated in client mandate?'){
                            qqanswer.Answer__c = QQ1;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Desired risk exposure'){
                            qqanswer.Answer__c = QQ2;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Investment objective'){
                            qqanswer.Answer__c = QQ3;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Cash Accruals'){
                            qqanswer.Answer__c = QQ4;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Frequency of payment required'){
                            qqanswer.Answer__c = QQ5;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Shares (Considered)'){
                            qqanswer.Answer__c = QQ6;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Shares (Recommended)'){
                            qqanswer.Answer__c = QQ7;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Money market instruments (Considered)'){
                            qqanswer.Answer__c = QQ8;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Money market instruments (Recommended)'){
                            qqanswer.Answer__c = QQ9;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Debentures and securitised debt (Considered)'){
                            qqanswer.Answer__c = QQ10;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Debentures and securitised debt (Recommended)'){
                            qqanswer.Answer__c = QQ11;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Bonds (Considered)'){
                            qqanswer.Answer__c = QQ12;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Bonds (Recommended)'){
                            qqanswer.Answer__c = QQ13;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Derivatives instruments (Considered)'){
                            qqanswer.Answer__c = QQ14;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Derivatives instruments (Recommended)'){
                            qqanswer.Answer__c = QQ15;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Participatory interests in collective investment schemes (Considered)'){
                            qqanswer.Answer__c = QQ16;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Participatory interests in collective investment schemes (Recommended)'){
                            qqanswer.Answer__c = QQ17;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Warrants, certificates and other instruments acknowledging conferring or creating rights to subscribe, acquire, dispose of, or convert securities and instruments (Considered)'){
                            qqanswer.Answer__c = QQ18;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Securities and instruments: Warrants, certificates and other instruments acknowledging conferring or creating rights to subscribe, acquire, dispose of, or convert securities and instruments (Recommended)'){
                            qqanswer.Answer__c = QQ19;qqanswer.Answer_Data_Type__c='picklist';}
           if (qqname.Question_Label__c == 'Representative under supervision?'){
                            qqanswer.Answer__c = QQ20;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Amount to be invested'){
                            qqanswer.Answer__c = QQ21;qqanswer.Answer_Data_Type__c='Currency';}
           if (qqname.Question_Label__c == 'Supervisor attended the client meeting with the supervisee?'){
                            qqanswer.Answer__c = QQ22;qqanswer.Answer_Data_Type__c='Picklist';}
           if (qqname.Question_Label__c == 'Supervisor name'){
                            qqanswer.Answer__c = QQ23;qqanswer.Answer_Data_Type__c='Text';}
           if (qqname.Question_Label__c == 'Motivation for recommendation'){
                            qqanswer.Answer__c = QQ24;qqanswer.Answer_Data_Type__c='Text';}
           if (qqname.Question_Label__c == 'Phasing in instruction (if applicable)'){
                            qqanswer.Answer__c = QQ25;qqanswer.Answer_Data_Type__c='Text';}
           if (qqname.Question_Label__c == 'Client accepted/did not accept advice'){
                            qqanswer.Answer__c = QQ26;qqanswer.Answer_Data_Type__c='Picklist';}
           newQAnswerRecList.add(qqanswer);
       }
       insert newQAnswerRecList;
        return newQAnswerRecList;
   }
    /**
     * @description Method that get an Questionnaire_Answer__c details
     * @param OppId
     * @return LIST<Questionnaire_Answer__c>
    */
    @AuraEnabled
  public static LIST<Questionnaire_Answer__c> getQuestionnaireRecordlist(Id OppId) {
        Opportunity opp=new OpportunitiesSelector().selectByOppId(OppId);
       List< Application__c> app=new ApplicationsSelector().selectByOpportunityOnboardId(oppId);
   		LIST<Questionnaire_Question__c> questionnames=[SELECT Id, Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Questionnaire_Template__r.Name='SPM Record Of Advice'];
         List<Questionnaire_Answer__c> QAnswerRecList= [SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Question__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c FROM Questionnaire_Answer__c where Related_Opportunity__r.Id=:opp.Id AND Related_Application__c=:app[0].Id AND Questionnaire_Template__r.Name='SPM Record Of Advice'];
        return QAnswerRecList;
    }
    /**
     * @description Method that get an Application_Product__c details
     * @param oppId
     * @return Application_Product__c
    */
  @AuraEnabled
    public static Application_Product__c getAppPrdctRec(Id oppId) {
        List<Application_Product__c> appPrdctRec= new ApplicationProductSelector().selectByOpportunityId(oppId);
        return appPrdctRec[0];    
        
    } 
    /**
     * @description Method that get an Account details
     * @param oppId
     * @return Account
    */
    @AuraEnabled
    public static Account getAccount(Id oppId) {
        Account acc=new AccountsSelector().selectByOpportunityId(oppId);
        return acc;     
        
    }
}