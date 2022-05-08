/*
* Apex controller class for the lightning page CommunicationPlanRule
*
* @author  Rudolf Niehaus : CloudSmiths
* @since   2019-06-25
*
*/
public class CommunicationPlanRuleController {

    /*
    * Upsert the communication plan rule
    * 
    * @param sd_Communiction_Rule__c rule
    */
    @AuraEnabled
    public static void upsertRule(sd_Communication_Rule__c rule){

        //Get SMS and Email template names from the selected typeahead Ids
        Set<Id> ids = new Set<Id>();
        if(rule.sd_Email_Template_Id__c instanceof Id){
            ids.add(rule.sd_Email_Template_Id__c);
        }
        if(rule.sd_Email_Template_Id_AFR__c instanceof Id){
             ids.add(rule.sd_Email_Template_Id_AFR__c);
        }
       
        Map<Id, EmailTemplate> emailTempMap = new Map<Id, EmailTemplate>([Select Id, Name From EmailTemplate Where Id IN :ids]);

        ids.clear();

        if(rule.sd_SMS_Template_Id__c instanceof Id){
             ids.add(rule.sd_SMS_Template_Id__c);
        }
        if(rule.sd_SMS_Template_Id_AFR__c instanceof Id){
             ids.add(rule.sd_SMS_Template_Id_AFR__c);
        }

        Map<Id, QuickText> quickTextMap = new Map<Id, QuickText>([Select Id, Name From QuickText Where Id IN :ids]);

        //Set the template fields to the name of the template
        if( emailTempMap.containsKey(rule.sd_Email_Template_Id__c) ){
            rule.sd_Email_Template__c = emailTempMap.get( rule.sd_Email_Template_Id__c ).Name;
        }
        if( emailTempMap.containsKey(rule.sd_Email_Template_Id_AFR__c) ){
            rule.sd_Email_Template_AFR__c = emailTempMap.get( rule.sd_Email_Template_Id_AFR__c ).Name;
        }
        if( quickTextMap.containsKey(rule.sd_SMS_Template_Id__c) ){
            rule.sd_SMS_Template__c = quickTextMap.get( rule.sd_SMS_Template_Id__c ).Name;
        }
        if( quickTextMap.containsKey(rule.sd_SMS_Template_Id_AFR__c) ){
            rule.sd_SMS_Template_AFR__c = quickTextMap.get( rule.sd_SMS_Template_Id_AFR__c ).Name;
        }

        try{

            upsert rule;

        }catch(DMLException ex){

            System.debug(ex.getMessage());

            //Any DML Exception. e.g. Trigger validation or validation rules on the object
            String msg = '';
            for (Integer i = 0; i < ex.getNumDml(); i++) {
                
                msg =+ ex.getDmlMessage(i) +  '\n' ;
            }
            
            throw new AuraHandledException(msg);

        }catch(Exception ex){

            //throw all other exceptions
            System.debug('There was an error saving this communication rule record : ' + ex.getMessage());
            throw new AuraHandledException(ex.getMessage());
        }
    }
     /*
    * Return the trigger type in order to render specific fields
    * on the lightning component
    * 
    * @param String ruleId
    * @return sd_Communication_Rule__c
    */
    @AuraEnabled
    public static sd_Communication_Rule__c getRule(String ruleId){
        
        Set<Id> ids = new Set<Id>();
        ids.add(ruleId);
        
        List<sd_Communication_Rule__c> commRule = new CommunicationRulesSelector().selectByRuleIdWithPlanName(ids);

        if(commRule.size() > 0){
            return commRule[0]; 
        }else{

            sd_Communication_Rule__c newRule = new sd_Communication_Rule__c();
            newRule.sd_Rule_Description__c = '';
            return newRule;
        }
    }
}