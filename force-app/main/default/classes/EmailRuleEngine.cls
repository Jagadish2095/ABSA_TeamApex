/**
* @description Email rule engine class description
* @param Boolean (isBodySizeOk) : Boolean
* @param Boolean (isLargeBodyOk) : Boolean
* @param RuleData (ruleData) : RuleData
* @param String (absaSupportAddress) : String
* @param String (regexExternalRefType) : String
* @param String (regexExternalRefNumber) : String
* return Return Boolean : Return Boolean 
* @author  Tracy de Bruin - CloudSmiths
* @since   2018-06-14
* Update : 2019-04-10 RN - CloudSmith #W-002235
* Update : 2020-07-17 Rudolf Niehaus #W-005291
*/
public class EmailRuleEngine {
    
    public static Boolean isBodySizeOk;
    public static Boolean isLargeBodyOk;
    public static RuleData ruleData;
    public static String absaSupportAddress;
    public static String regexExternalRefType;
    public static String regexExternalRefNumber;
    /**
     * @description isSenderOrgWideEmailAddress description
     *
     * @param fromEmailAddress (String): fromEmailAddress
     * @return Return Boolean: Return description
     */
    public static Boolean isSenderOrgWideEmailAddress(String fromEmailAddress) {
        //Ignore email send from Org wide email addresses 
        Set<String> OWA = new Set<String>();
        
        for(OrgWideEmailAddress owd :[Select Id, Address From OrgWideEmailAddress]) {
            OWA.add(owd.Address);
        }
        
        //Log as an Exception
        if(OWA.contains(fromEmailAddress)){
            AuditTrailLog.logException(null, 'New', 'Error', 'EmailRuleEngine', 'InboundEmailService', 'The sender from email address was either an Org Wide Address, or one of the email service addresses'); 
            return true;
        }else{
            return false; 
        }
    }
    /**
     * @description emailBodyCheck description
     *
     * @param email (Messaging.InboundEmail): email
     * @return Return Boolean: Return description
     */
    public static Boolean emailBodyCheck(Messaging.InboundEmail email) {
        //Validate the size of the email body
        //Will use this flag later to determine if we are going to insert the email body into the std textArea of the EmailMessage object
        isBodySizeOk = false;
        isLargeBodyOk = false;
        
        if (String.isEmpty(email.htmlBody)){
            if(email.plainTextBody.length() < 32000 ){
                isBodySizeOk = true;
                isLargeBodyOk = true;
            }else if(email.plainTextBody.length() > 32000 && email.plainTextBody.length() < 131000){
                isLargeBodyOk = true;
            }
        }else{
            if(email.htmlBody.length() < 32000){
                isBodySizeOk = true;
                isLargeBodyOk = true;
            }else if(email.htmlBody.length() > 32000 && email.htmlBody.length() < 131000){
                isLargeBodyOk = true;
            }
        } 
        
        return isBodySizeOk;
    }
    
    /**
     * @description htmlToText description
     *
     * @param html (String): html
     * @return Return String: Return description
     */
    public static String htmlToText(String html) {
        return html.stripHtmlTags();
    }
    
    /**
     * @description findMatchingRule description
     *
     * @param email (Messaging.InboundEmail): email
     * @param skipResponse (boolean): skipResponse
     * @param recordType (String): recordType
     * @return Return RuleData: Return description
     */
    public static RuleData findMatchingRule(Messaging.InboundEmail email,boolean skipResponse, String recordType) {
        
        ruleData rd = new RuleData();
        absaSupportAddress = '';
        
        //RN : Check if toAddress match a support email address, if yes create a case for that inbox, if not check if a
        //     valid support address exist for all the cc addresses, if yes create a case for the valid cc support address
        
        //Get all TO and CC email addresses
        Set<String> toAddresses = new Set<String>();
        Set<String> ccAddresses = new Set<String>();
        
        if(email.toAddresses != null){
            for(String s :email.toAddresses){
                toAddresses.add(s);
            }
        }
        if(email.ccAddresses != null){
            for(String s :email.ccAddresses){
                ccAddresses.add(s);
            }
        }
        
        List<Shared_Email__c> sharedEmail = new List<Shared_Email__c>();
        List<Shared_Email__c> sharedEmailtoAddresses = new SharedEmailsSelector().selectByToAddressesWithEmailRules( toAddresses );
        
        if( sharedEmailtoAddresses.isEmpty() && ccAddresses.size() > 0 ){
            
            List<Shared_Email__c> sharedEmailccAddresses = new SharedEmailsSelector().selectByToAddressesWithEmailRules( ccAddresses );
            sharedEmail.addAll(sharedEmailccAddresses);
            
        }else{
            sharedEmail.addAll(sharedEmailtoAddresses);
        }
        
        System.debug(LoggingLevel.FINE, 'sharedEmail : ' + sharedEmail);
        
        if(sharedEmail.size() > 0){
            
            //set the ABSA support email address that was configured in the shared email object. This
            //address is dropped by the exchange forwarding rule and not visable to the email handler 
            absaSupportAddress = sharedEmail[0].Inbox_Address__c;
            
            if(sharedEmail[0].Shared_Email_Rules__r.size() > 0) {
                
                
                //loop over rules for this inbox and gather the rule Ids
                Set<Id> ruleIds = new Set<Id>();
                
                for(Shared_Email_Rule__c sharedRule :sharedEmail[0].Shared_Email_Rules__r){
                    
                    System.debug(LoggingLevel.FINE, 'sharedRule.Email_Rule__c::'+sharedRule.Email_Rule__c);
                    
                    ruleIds.add(sharedRule.Email_Rule__c);
                }
                System.debug(LoggingLevel.FINE, 'ruleIds::'+ruleIds);
                //Get email rule with queue info
                List<Email_Rule__c> emailRules = new EmailRulesSelector().selectByIdWithRelatedInfo(ruleIds,10000);
                
                System.debug(LoggingLevel.FINE, 'emailRules::'+emailRules);
                
                //Find a matching Rule for this email
                Boolean ruleWasFound = false;
                String ruleType = '';
                String serviceGroupId = '';
                String serviceTypeId = '';
                String defaultRuleId = '';
                String ruleId = '';
                String communicationPlanId = '';
                String ruleEmailTemplate = '';
                Decimal retention = 0;
                String serviceLevelId = '';
                    
                for(Email_Rule__c rule :emailRules){
                    
                    System.debug(LoggingLevel.FINE, 'Rule Name : ' + rule.Name );
                    
                    //If we find a default rule we add the id for later use should we not find a matching rule	
                    if(rule.Default_Email_Rule__c){
                        defaultRuleId = rule.Id;
                    }
                    
                    regexExternalRefType = rule.Reference_Type__c;
                    
                    Map<Integer, Boolean> operatorLogicMap = new Map<Integer, Boolean>();
                    
                    //If there are rule criteria define check if it match. 
                    //If no criteria are define but there are a rule, then its a match
                    //and we rout the email to the related queue. 	
                    
                    //Logic 1
                    if(String.isNotBlank(rule.From_Criteria__c) && String.isNotBlank(rule.From_Operator__c)){
                        
                        operatorLogicMap.put(1, isMatch(rule.From_Operator__c, rule.From_Criteria__c, email.fromAddress, false) ); 
                        
                    }
                    
                    //Logic 2
                    if(String.isNotBlank(rule.Subject_Criteria__c) && String.isNotBlank(rule.Subject_Operator__c)){
                        /**Added if condition for STI fucntionality by pranav 21-04-2021**/
                        if(rule.Route_To_Queue__r.Name!=null && rule.Route_To_Queue__r.Name.equalsIgnoreCase('Direct Delivery STI')){
                           operatorLogicMap.put(2, True); 

                        }/**changes End**/
                        else{
                            operatorLogicMap.put(2, isMatch(rule.Subject_Operator__c, rule.Subject_Criteria__c, email.subject, false) ); 

                        }
                        
                    }
                    
                    //Logic 3
                    if(String.isNotBlank(rule.Description_Criteria__c) && String.isNotBlank(rule.Description_Operator__c)){
                        
                        if(String.isNotBlank(email.htmlBody)){
                            
                            operatorLogicMap.put(3, isMatch(rule.Description_Operator__c, rule.Description_Criteria__c, email.htmlBody, true) );
                            
                        }else{
                            
                            operatorLogicMap.put(3, isMatch(rule.Description_Operator__c, rule.Description_Criteria__c, email.plainTextBody, false) );
                            
                        } 
                        
                    }
                    
                    if(!operatorLogicMap.isEmpty()){
                        
                        List<Boolean> criteriaMatchList = new List<Boolean>();
                        
                        if( operatorLogicMap.containsKey(1) ){
                            
                            if(operatorLogicMap.get(1)){
                                criteriaMatchList.add(true);
                            }else{
                                criteriaMatchList.add(false);
                            }
                            
                        }
                        if( operatorLogicMap.containsKey(2) ){
                            
                            if(operatorLogicMap.get(2)){
                                criteriaMatchList.add(true);
                            }else{
                                criteriaMatchList.add(false);
                            }
                            
                        }
                        if( operatorLogicMap.containsKey(3) ){
                            
                            if(operatorLogicMap.get(3)){
                                criteriaMatchList.add(true);
                            }else{
                                criteriaMatchList.add(false);
                            }
                            
                        }
                        
                        //RN -> TODO: Impliment boolean logic
                        //(1 OR 2) AND 3
                        system.debug('criteriaMatchList '+criteriaMatchList);
                        if(!criteriaMatchList.contains(false)){
                            
                            ruleWasFound = true;
                            ruleType = rule.RecordType.DeveloperName;
                            serviceGroupId = rule.Route_To_Queue__c;
                            retention = rule.Retention_Period_Hrs__c;
                            ruleId = rule.Id;
                            communicationPlanId = rule.sd_Communication_Plan__c;
                            ruleEmailTemplate = rule.Email_Rule_Template__c;
                            
                            if(String.isNotBlank(rule.Service_Type__c)){
                                serviceTypeId = rule.Service_Type__c; 
                            }
                            
                            if(String.isNotBlank(rule.Service_Level__c)){
                                serviceLevelId = rule.Service_Level__c; 
                            }
                            
                            System.debug(LoggingLevel.FINE, 'Rule matched=TRUE');
                            System.debug(LoggingLevel.FINE, 'Rule Id : ' + ruleId);
                            System.debug(LoggingLevel.FINE, 'Rule type : ' + ruleType);
                            System.debug(LoggingLevel.FINE, 'Service Group id : ' + serviceGroupId);
                            System.debug(LoggingLevel.FINE, 'Retention : ' + retention);
                            System.debug(LoggingLevel.FINE, 'Service Type Id : ' + serviceTypeId);
                            
                            break;
                        }
                        
                    }
                    
                }//End Rule For Loop
                
                if(ruleWasFound){
                    system.debug('inside if rulewasfound');
                    rd.ruleType = ruleType;
                    rd.hasMathingRule = true;
                    rd.ruleId = ruleId;
                    
                    if( ruleType != 'Blocking_Rule' ){
                        
                        if(recordType == 'Lead'){
                            rd.leadId = actionRule( email, serviceGroupId, serviceTypeId, '', ruleType ,skipResponse, communicationPlanId, recordType, ruleEmailTemplate);

                        }else{

                            rd.caseId = actionRule( email, serviceGroupId, serviceTypeId, serviceLevelId, ruleType ,skipResponse, communicationPlanId, recordType, ruleEmailTemplate);

                        }

                    }else{
                        
                        rd.retentionPeriod = retention;
                    } 
                    
                    return rd; 
                    
                }else{
                    return getDefaultRule(email, defaultRuleId, false, skipResponse, recordType);
                }
            }else{//No Shared Email Rule found
                return getDefaultRule(email, '', true, skipResponse, recordType);
            }
        }else{//No Shared email found
            return getDefaultRule(email, '', true, skipResponse, recordType);
        }
    }
    
    /**
     * @description getDefaultRule description
     *
     * @param email (Messaging.InboundEmail): email
     * @param ruleId (String): ruleId
     * @param isOrgWideRule (Boolean): isOrgWideRule
     * @param skipResponse (Boolean): skipResponse
     * @param recordType (String): recordType
     * @return Return RuleData: Return description
     */
    private static RuleData getDefaultRule(Messaging.InboundEmail email, String ruleId, Boolean isOrgWideRule, Boolean skipResponse, String recordType ) {
        
        List<Email_Rule__c> defaultRule = new List<Email_Rule__c>();
        
        if(isOrgWideRule || String.isBlank(ruleId)){
            defaultRule = new EmailRulesSelector().selectOrgWideDefaultWithRelatedInfo(); 
        }else{
            defaultRule = new EmailRulesSelector().selectSharedEmailDefaultWithRelatedInfo(ruleId);
        }
        system.debug('defaultRule***'+defaultRule);
        
        RuleData rd = new RuleData();
        
        if( defaultRule.isEmpty() ){
            return rd;
            
        }else{
            rd.ruleId = defaultRule[0].Id;
            rd.hasMathingRule = true;
            rd.ruleType = defaultRule[0].RecordType.DeveloperName;
            rd.retentionPeriod = defaultRule[0].Retention_Period_Hrs__c;

            if(recordType == 'Lead'){

                rd.leadId = actionRule( email, defaultRule[0].Route_To_Queue__c, '', defaultRule[0].Service_Level__c , defaultRule[0].RecordType.DeveloperName , skipResponse, defaultRule[0].sd_Communication_Plan__c, recordType,'' );  
            
            }else{

                rd.caseId = actionRule( email, defaultRule[0].Route_To_Queue__c, '', defaultRule[0].Service_Level__c , defaultRule[0].RecordType.DeveloperName , skipResponse, defaultRule[0].sd_Communication_Plan__c, recordType,'' ); 

            }
            regexExternalRefType = defaultRule[0].Reference_Type__c;
            
            System.debug(LoggingLevel.FINE, 'Default Rule Used=TRUE');
            System.debug(LoggingLevel.FINE, 'Rule Id : ' + defaultRule[0].Id);
            System.debug(LoggingLevel.FINE, 'Rule type : ' + defaultRule[0].RecordType.DeveloperName);
            
            return rd;
        }
    }
    /**
     * @description isMatch description
     *
     * @param criteriaCondition (String): criteriaCondition
     * @param criteriaVal (String): criteriaVal
     * @param matchVal (String): matchVal
     * @param stripHTML (Boolean): stripHTML
     * @return Return Boolean: Return description
     */
    public static Boolean isMatch(String criteriaCondition, String criteriaVal, String matchVal, Boolean stripHTML) {
        
        System.debug(LoggingLevel.FINE, 'Try to match rule');
        System.debug(LoggingLevel.FINE, 'criteriaCondition = ' + criteriaCondition);
        if(stripHTML){
            System.debug(LoggingLevel.FINE, 'criteriaVal = ' + criteriaVal.stripHtmlTags());
        }else{
            System.debug(LoggingLevel.FINE, 'criteriaVal = ' + criteriaVal);
        }
        System.debug(LoggingLevel.FINE, 'matchVal = ' + matchVal);
        
        
        if(criteriaCondition == 'contains exact match')	{
            
            if(stripHTML){
                criteriaVal = criteriaVal.stripHtmlTags();  
            }
            
            //RN - use word boundaries to get the exact word or phrase and ignore case
            String strRegEx = '(?i)\\b' + criteriaVal + '\\b';
            
            Pattern MyPattern = Pattern.compile(strRegEx);
            Matcher MyMatcher = MyPattern.matcher(matchVal);
            
            return MyMatcher.find();
            
        }else if(criteriaCondition == 'equals'){
            
            return matchVal.equalsIgnoreCase( criteriaVal ) ? true : false;
            
        }else if(criteriaCondition == 'starts with'){
            
            return  matchVal.startsWithIgnoreCase( criteriaVal )  ? true : false;
            
        }else if(criteriaCondition == 'contains wildcard'){
            
            return matchVal.containsIgnoreCase( criteriaVal ) ? true : false;
            
        }else if(criteriaCondition == 'does not contain'){
            
            return matchVal.containsNone( criteriaVal ) ? true : false;
            
            
        }else if(criteriaCondition == 'regex'){
            
            Pattern MyPattern = Pattern.compile(criteriaVal);
            Matcher MyMatcher = MyPattern.matcher(matchVal);
            
            if(MyMatcher != null && MyMatcher.find()) {
                regexExternalRefNumber = MyMatcher.group();
            }
            
            return MyMatcher.find();
            
        }else{
            return false;
        }
    }
    
    /**
     * @description actionRule description
     *
     * @param email (Messaging.InboundEmail): email
     * @param serviceGroupId (String): serviceGroupId
     * @param serviceTypeId (String): serviceTypeId
     * @param serviceLevelId (String): serviceLevelId
     * @param ruleType (String): ruleType
     * @param skipResponse (boolean): skipResponse
     * @param commPlanId (String): commPlanId
     * @param recordType (String): recordType
     * @param ruleEmailTemplate (String): ruleEmailTemplate
     * @return Return String: Return description
     */
    private static String actionRule(Messaging.InboundEmail email, 
                                    String serviceGroupId, 
                                    String serviceTypeId, 
                                    String serviceLevelId, 
                                    String ruleType,
                                    boolean skipResponse, 
                                    String commPlanId, 
                                    String recordType,
                                    String ruleEmailTemplate){
        
        List<Service_Group__c> serviceGroups = new List<Service_Group__c>();
        List<Service_Group_Type__c> serviceGroupTypes = new List<Service_Group_Type__c>();
        
        if(String.isNotBlank(serviceGroupId)){
            
            Set<Id> idSet = new Set<Id>();
            
            idSet.add(serviceGroupId);
            
            serviceGroups = new ServiceGroupsSelector().selectById(idSet);
        }
        
        if(String.isNotBlank(serviceTypeId)){
            
            Set<Id> idSet = new Set<Id>();
            idSet.add(serviceTypeId);
            serviceGroupTypes = new ServiceGroupTypesSelector().selectByServiceTypeWithGroupAndServiceInfo(idSet);
            
            if(String.isBlank(serviceLevelId) && !serviceGroupTypes.isempty()){
                
                serviceLevelId = serviceGroupTypes[0].Service_Level__c;                
            }
            
        }
              
        if(recordType == 'Lead' && serviceGroups[0].Name != 'Direct Delivery STI'){
            return EmailCreateLead.createRuleMatchingLead(email, serviceGroups, serviceGroupTypes, serviceLevelId, ruleType, absaSupportAddress,skipResponse, regexExternalRefType, regexExternalRefNumber, commPlanId);
        }
          /***added newly by pranav for sti email fucntionality for lead and case creation depends on subject**/ 
           else if(recordType == 'Lead' && serviceGroups[0].Name == 'Direct Delivery STI' ){
            if(String.isNotBlank(email.subject) && email.subject.contains(System.Label.DD_New_Life_Advisor_Referral_Lead)){//DD_New_Life_Advisor_Referral_Lead
              return EmailCreateLead.createRuleMatchingLead(email, serviceGroups, serviceGroupTypes, serviceLevelId, ruleType, absaSupportAddress,skipResponse, regexExternalRefType, regexExternalRefNumber, commPlanId);
            } else if(String.isNotBlank(email.subject) && email.subject.contains(System.Label.Virtual_STI_Adviser_Lead_Referral)){//Virtual_STI_Adviser_Lead_Referral	
              return EmailCreateLead.createRuleMatchingLead(email, serviceGroups, serviceGroupTypes, serviceLevelId, ruleType, absaSupportAddress,skipResponse, regexExternalRefType, regexExternalRefNumber, commPlanId);
            } else{
                set<string> casegropSet = new set<string>{'DD STI Case'};
                serviceGroups = new ServiceGroupsSelector().selectByName(casegropSet);
                return EmailCreateCase.createRuleMatchingCase(email, 
                                                         serviceGroups, 
                                                         serviceGroupTypes, 
                                                         serviceLevelId, 
                                                         ruleType, 
                                                         absaSupportAddress,
                                                         skipResponse, 
                                                         regexExternalRefType, 
                                                         regexExternalRefNumber, 
                                                         commPlanId,
                                                         ruleEmailTemplate);
            }
              
        }
        //------- pranav chnages end  ----------------------                        
        else{
            return EmailCreateCase.createRuleMatchingCase(email, 
                                                         serviceGroups, 
                                                         serviceGroupTypes, 
                                                         serviceLevelId, 
                                                         ruleType, 
                                                         absaSupportAddress,
                                                         skipResponse, 
                                                         regexExternalRefType, 
                                                         regexExternalRefNumber, 
                                                         commPlanId,
                                                         ruleEmailTemplate);
        }
    }
    
    /**
     * @description updateTriggerCount description
     *
     * @param ruleId (Id): ruleId
     */
    public static void updateTriggerCount( Id ruleId ){
        
        Set<Id> idSet = new Set<Id>();
        idSet.add(ruleId);
        List<Email_Rule__c> er = new EmailRulesSelector().selectById(idSet);
        
        if(!er.isEmpty()){
            
            if(er[0].Trigger_Count__c != null){
                er[0].Trigger_Count__c += 1; 
            }else{
                er[0].Trigger_Count__c = 1;
            }
            
            try{
                update er[0];
            }catch(DMLException e){
                AuditTrailLog.logException(e,  'New', 'Error', 'EmailRuleEngine', 'updateTriggerCount', 'Unable to update the matching rule trigger count');  
                system.debug(e.getMessage());
            }
        }
    }
    
    /**
     * @description autoBlockSpamJunkEmails description
     *
     * @param fromEmailList (Set<String>): fromEmailList
     * @param inboxAliasList (Set<String>): inboxAliasList
     * @param inboxAddressesMap (Map<StringString>): inboxAddressesMap
     * @param inboxAndServiceGroupsMap (Map<StringString>): inboxAndServiceGroupsMap
     * @param serviceGroupManagersMap (Map<StringString>): serviceGroupManagersMap
     */
    public static void autoBlockSpamJunkEmails(Set<String> fromEmailList, Set<String> inboxAliasList, Map<String, String> inboxAddressesMap, Map<String, String> inboxAndServiceGroupsMap, Map<String, String> serviceGroupManagersMap){
        
        Set<String> emailRuleIds = new Set<String>();
        Map<String, String> inboxAliasMap = new Map<String, String>();
        Map<String, Boolean> autoBlockEmailMap = new Map<String, Boolean>();
        
        List<Email_Rule__c> emailRulesToCreate = new List<Email_Rule__c>();
                
        List<Shared_Email__c> sharedEmailList = [Select Id, Active__c, Inbox_Address__c, Auto_Block_Spam_Junk_Emails__c	From Shared_Email__c Where Active__c = true And Inbox_Address__c in:inboxAliasList];
        
        if(sharedEmailList.size() > 0){
            for(Shared_Email__c sharedEmail : sharedEmailList) {
                inboxAliasMap.put(sharedEmail.Inbox_Address__c, sharedEmail.Id);
                autoBlockEmailMap.put(sharedEmail.Inbox_Address__c, sharedEmail.Auto_Block_Spam_Junk_Emails__c);
            }
        }
        
        RecordType blockingRuleType = [Select Id, DeveloperName From RecordType Where DeveloperName =:'Blocking_Rule' And sObjectType =:'Email_Rule__c'];
        
        List<Email_Rule__c> existingEmailRules = [Select Id, Name From Email_Rule__c Where From_Criteria__c in:fromEmailList And From_Operator__c =: 'equals' And Active__c =:true And RecordTypeId =:blockingRuleType.Id];
        system.debug(LoggingLevel.FINE, '***existingEmailRules:***'+existingEmailRules);
        
        if(existingEmailRules.size() > 0){
            for(Email_Rule__c existingEmailRule: existingEmailRules) { 
                emailRuleIds.add(existingEmailRule.Id);
            }
        }else{
            for(String fromEmail : fromEmailList) { 
                Email_Rule__c blockingRule = new Email_Rule__c();
                blockingRule.RecordTypeId = blockingRuleType.Id;
                blockingRule.Name = fromEmail;
                blockingRule.From_Criteria__c = fromEmail;
                if(autoBlockEmailMap.get(inboxAddressesMap.get(fromEmail)) == true){
                    blockingRule.Active__c = true; 
                }else{
                    blockingRule.Active__c = false;
                }
                
                if(serviceGroupManagersMap.containsKey(inboxAndServiceGroupsMap.get(fromEmail))){
                    blockingRule.Email_Rule_Approver__c = serviceGroupManagersMap.get(inboxAndServiceGroupsMap.get(fromEmail));
                }
                
                emailRulesToCreate.add(blockingRule);
            }
            
            try{
                if(emailRulesToCreate.size() > 0){
                    Database.SaveResult[] emailRulesList = Database.insert(emailRulesToCreate, false);
                    for (Database.SaveResult emailRule : emailRulesList){
                        if (emailRule.isSuccess()) {
                            emailRuleIds.add(emailRule.getId());
                        }else{
                            for(Database.Error err : emailRule.getErrors()) {
                                AuditTrailLog.logException(new DMLException(), 'New', 'Error', 'EmailRuleEngine', 'autoBlockSpamJunkEmails', 
                                                           'There was an error creating email rule record\n ' + err.getMessage());
                            }
                        }
                    }
                }
            }catch(Exception ex){
                system.debug(LoggingLevel.FINE, '***blockSpamJunkEmails:***'+ex.getMessage());
            }
        }
        
        system.debug(LoggingLevel.FINE, '***emailRuleIds:***'+emailRuleIds);
        
        if(emailRuleIds.size() > 0){
            addSharedEmailsToEmailRules(emailRuleIds, inboxAddressesMap, inboxAliasMap);
        }        
    }
    /**
     * @description addSharedEmailsToEmailRules description
     *
     * @param ruleIds (Set<String>): ruleIds
     * @param inboxAddressesMap (Map<StringString>): inboxAddressesMap
     * @param inboxAliasMap (Map<StringString>): inboxAliasMap
     */
    public static void addSharedEmailsToEmailRules(Set<String> ruleIds, Map<String, String> inboxAddressesMap, Map<String, String> inboxAliasMap){
        
        List<Shared_Email_Rule__c> newSharedEmailRules = new List<Shared_Email_Rule__c>();
        List<Email_Rule__c> emailRules = [Select Id, Name, Active__c, Email_Rule_Approver__c From Email_Rule__c Where Id in:ruleIds];
        
        if(emailRules.size() > 0){
            List<Approval.ProcessSubmitRequest> approvalRequestList = new List<Approval.ProcessSubmitRequest>();
            for(Email_Rule__c rule: emailRules) {
                if(inboxAliasMap.containsKey(inboxAddressesMap.get(rule.Name))){
                    Shared_Email_Rule__c sharedEmailRule = new Shared_Email_Rule__c();
                    sharedEmailRule.Shared_Email__c = inboxAliasMap.get(inboxAddressesMap.get(rule.Name));
                    sharedEmailRule.Email_Rule__c = rule.Id;
                    newSharedEmailRules.add(sharedEmailRule);
                }
                if(rule.Active__c == false && rule.Email_Rule_Approver__c != null){
                    Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
                    approvalRequest.setComments('Spam/Junk Email Submitted for approval');
                    approvalRequest.setObjectId(rule.Id);
                    approvalRequestList.add(approvalRequest);
                }
            }
            List<Approval.ProcessResult> approvalResultList = Approval.process(approvalRequestList);
            try{
                if(newSharedEmailRules.size() > 0){
                    insert newSharedEmailRules;
                }
            }catch(Exception ex){
                system.debug(LoggingLevel.FINE, '***newSharedEmailRules Error:***'+ex.getMessage());
            }
            
        }
    }
    
    /**
    *@description : RuleData description
    *@param String (ruleId) : String
    *@param Boolean (hasMathingRule) : Boolean
    *@param String (ruleType) : String
    *@param String (caseId) : String
    *@param String (leadId) : String
    *@param Decimal (retentionPeriod) : Decimal
*/
    public class RuleData {
        /**
         * @description ruleId
         */
        public String ruleId {get;set;}
        /**
         * @description hasMathingRule
         */
        public Boolean hasMathingRule {get;set;}
        /**
         * @description ruleType
         */
        public String ruleType {get;set;}
        /**
         * @description caseId
         */
        public String caseId {get;set;}
        /**
         * @description leadId
         */
        public String leadId {get;set;}
        /**
         * @description retentionPeriod
         */
        public Decimal retentionPeriod{get;set;}
        /**
         * @description RuleData description
         *
         */
        public RuleData(){
            this.hasMathingRule = false;
            this.ruleType = '';
            this.caseId = '';
            this.leadId = '';
            this.retentionPeriod = 0;
            this.ruleId = '';
        }
    }
    
}