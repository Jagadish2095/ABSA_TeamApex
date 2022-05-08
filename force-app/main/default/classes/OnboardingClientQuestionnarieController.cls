/**
* @description       : 
* @author            : almas.aleem@absa.africa
* @last modified on  : 2021-11-17
* @last modified by  : almas.aleem@absa.africa
**/
public class OnboardingClientQuestionnarieController {
    /**
* @description 
* @author almas.aleem@absa.africa | 2021-10-22 
* @param recordId 
* @return String 
**/
    @AuraEnabled
    public static String getRecordType(Id recordId){
        String objectName =recordId.getSObjectType().getDescribe().getName();
        if(objectName == 'Opportunity'){
            List<Opportunity> oppData = new OpportunitiesSelector().selectByOpportunityId(recordId);
            if(oppData.size() > 0 && oppData != null)
                return oppData[0].RecordType.Name;
            else
                return null;
        }else if(objectName == 'Lead'){
            Lead leadData = new LeadsSelector().selectLeadById(recordId);
            if(leadData !=null){
                return leadData.RecordType.Name;
            }else
                return null; 
            
        }else if(objectName == 'Account' && recordId!=null){
            Account acc =[select id,name,RecordType.Name from Account where Id =:recordId];
            if(acc !=null){
                return acc.RecordType.Name;
            }else
                return null; 
        }else if(objectName == 'Case' && recordId!=null){  // Added For W-7276
            List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(recordId, 1);
            Case caseRec = caseList[0];// [select id,name,RecordType.Name from Case where Id =:recordId];
            if(caseRec !=null){
                return caseRec.RecordType.Name;
            }else
                return null; 
        }
        return null;
        
    }
    
    /**
* @description 
* @author almas.aleem@absa.africa | 2021-10-22 
* @param recordId 
* @return Opportunity 
**/
    @AuraEnabled
    public static Opportunity getOpportunityDetails(Id recordId){
        String objectName =recordId.getSObjectType().getDescribe().getName();
        Opportunity oppRecord=new Opportunity();
        if(objectName == 'Opportunity'){
            List<Opportunity> oppData = new OpportunitiesSelector().selectByOpportunityId(recordId);
            if(oppData.size() > 0 && oppData != null){
                oppRecord=oppData[0];
            }                
        }
        return oppRecord;
    }
    
    /**
* @description 
* @author almas.aleem@absa.africa | 2021-10-22 
* @param recordId 
* @param TemplateName 
* @return Map<string, List<getQuestionfieldInfo>> 
**/
    @AuraEnabled
    public static Map<string,List<getQuestionfieldInfo>> getQuestionList(Id recordId, String TemplateName){
        String accID;
        String objectName =recordId.getSObjectType().getDescribe().getName();
        //String TemplateName;
        String QuestionClientType;
        Opportunity opp;
        if(objectName == 'Opportunity'){
            
            opp =[select id,Entity_Type__c,Account.Risk_Rating__c,Account.Risk_Rating__pc,AccountID,Account.The_Client_is_involved_in_High_Risk_Indu__c,Account.PEP_Status__c,Account.PEP_Status__pc from Opportunity where Id =:recordId];
            accID = opp.AccountID;
            // TemplateName ='Wealth Offshore Onboarding';
            if(opp.Entity_Type__c =='Private Individual'|| opp.Entity_Type__c=='Individual'){
                QuestionClientType = 'Individual';  
            }else if(opp.Entity_Type__c =='Private Company'|| opp.Entity_Type__c=='Public Listed Company'){
                QuestionClientType = 'Private Company';  
            }else if(opp.Entity_Type__c =='Trusts'){
                QuestionClientType = 'Trusts';  
            }else if(opp.Entity_Type__c =='Joint and Several'){
                QuestionClientType = 'Joint and Several'; 
            }
        }
        if(objectName == 'Account'){
            
            Account acc =[select id,Client_Type__c from Account where Id =:recordId];
            accID = acc.Id;
            TemplateName ='Wealth Offshore Onboarding';
            if(acc.Client_Type__c =='Private Individual'|| acc.Client_Type__c=='Individual'){
                QuestionClientType = 'Individual';  
            }else if(acc.Client_Type__c =='Private Company'|| acc.Client_Type__c=='Public Listed Company'){
                QuestionClientType = 'Private Company';  
            }else if(acc.Client_Type__c =='Trusts'){
                QuestionClientType = 'Trusts';  
            }else if(acc.Client_Type__c =='Joint and Several'){
                QuestionClientType = 'Joint and Several'; 
            }
        }
        if(objectName == 'Lead'){
            Lead acc =[select Id,FinServ__RelatedAccount__r.Client_Type__c from Lead where Id =:recordId];
            accID = acc.FinServ__RelatedAccount__c;
            if(acc.FinServ__RelatedAccount__r.Client_Type__c =='Private Individual'|| acc.FinServ__RelatedAccount__r.Client_Type__c=='Individual'){
                QuestionClientType = 'Individual'; 
            }
        }
        
        List<getQuestionfieldInfo> getinfo = new List<getQuestionfieldInfo>();
        Map<string,List<getQuestionfieldInfo>> sectionwithMap = new Map<string,List<getQuestionfieldInfo>>();
        List<SelectOption> options = new List<SelectOption>();
        
        LIST<Questionnaire_Question__c> questionnames=[SELECT Id,Is_Required__c,(SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c,Related_Account__c FROM Questionnaire_Answers__r Where Related_Account__c =: accID ), Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE Client_Type__c=:QuestionClientType and Questionnaire_Template__r.Name=:templateName ORDER BY Sequence__c ASC];
        
        if(objectName == 'Case'){  // Added For W-7276 to meet checklist requirement
            List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(recordId, 1);
            Case caseRec = caseList[0];
            accID = caseRec.AccountId;
            
            questionnames=[SELECT Id,Is_Required__c,(SELECT Id, Name,Answer__c,Answer_Data_Type__c,Related_Opportunity__c,Related_Application__c, Questionnaire_Question__c, Questionnaire_Template__c,Related_Account__c FROM Questionnaire_Answers__r Where Related_Account__c =: accID ), Name, Questionnaire_Template__c, Answer_Control_Type__c, Answer_Options__c, Answer_Type__c, Default_Answer__c, Question_Label__c, Question__c, Section__c FROM Questionnaire_Question__c WHERE  Questionnaire_Template__r.Name=:templateName ORDER BY Sequence__c ASC];
            
           
        }
        
        for(Questionnaire_Question__c question : questionnames){
            if(!sectionwithMap.containsKey(question.Section__c)){
                sectionwithMap.put(question.Section__c,new List<getQuestionfieldInfo>()); 
            }
            List<Questionnaire_Answer__c> questAns = question.Questionnaire_Answers__r;
            getQuestionfieldInfo getdat =new getQuestionfieldInfo();
            getdat.questionId= question.id;
            getdat.TemplateId = question.Questionnaire_Template__c;
            getdat.isRequired =question.Is_Required__c;
            
            //commented below as not required currently
            /*if(opp!=null && (opp.Account.Risk_Rating__c =='High'||opp.Account.Risk_Rating__pc =='High') &&
(question.Question_Label__c =='Source of Wealth Background'||question.Question_Label__c =='Source of Funds Background'||question.Question_Label__c =='Source of Income Background')){
getdat.isRequired =true;  
}
if(opp!=null && (opp.Account.Risk_Rating__c =='Very High'||opp.Account.Risk_Rating__pc =='Very High') &&
(question.Question_Label__c =='Source of Wealth Background'||question.Question_Label__c =='Source of Funds Background'||question.Question_Label__c =='Source of Income Background')){
getdat.isRequired =true;  
}
if(opp!=null && (opp.Account.PeP_status__c =='PeP'||opp.Account.PeP_status__pc =='PeP') &&
(question.Question_Label__c =='Source of Wealth Background'||question.Question_Label__c =='Source of Funds Background'||question.Question_Label__c =='Source of Income Background')){
getdat.isRequired =true;  
}
if(opp!=null &&opp.Account.The_Client_is_involved_in_High_Risk_Indu__c !='NOT INVOLVED' &&
(question.Question_Label__c =='Source of Wealth Background'||question.Question_Label__c =='Source of Funds Background'||question.Question_Label__c =='Source of Income Background')){
getdat.isRequired =true;  
}*/
            if(String.isNotBlank(question.Question_Label__c)){
                getdat.questionLabel = question.Question_Label__c;
            }
            if(String.isNotBlank(question.Answer_Control_Type__c)){
                getdat.answerControltype = question.Answer_Control_Type__c;
            }
            if(String.isNotBlank(question.Answer_Type__c)){
                getdat.AnswerType = question.Answer_Type__c;
            }
            if(String.isNotBlank(question.Default_Answer__c)){
                getdat.defaultAnswer = question.Default_Answer__c;
            }
            if(String.isNotBlank(question.Answer_Options__c) ){
                List <string> answelist = question.Answer_Options__c.split(';');
                getdat.listofAnswerOptions = answelist;
            }
           
            if(!questAns.isEmpty()){
                getdat.userAnswer =questAns[0].Answer__c;
                if(questAns[0].Answer__c == 'true'){
                    getdat.isChecked = true ;
                }else{
                    getdat.isChecked = false; 
                }	
                getdat.AnswerType = questAns[0].Answer_Data_Type__c;
            }
            getinfo.add(getdat); 
            sectionwithMap.get(question.Section__c).add(getdat);
            
        }
        
        return sectionwithMap;
    }
    /**
* @description 
* @author almas.aleem@absa.africa | 2021-10-22 
* @param questionAns 
* @param recordId 
**/
    @AuraEnabled
    public static void saveQuestionAnswer(String questionAns, Id recordId){
        String accId;
        String objectName =recordId.getSObjectType().getDescribe().getName();
        List<Opportunity> opplist;
        List<Account> acclist;
        List<Lead> ldlst;
        List<Case> caseList;
        if(objectName == 'Opportunity'){
            opplist = [select id,AccountId from opportunity where Id =:recordId];
            
            
        } if(objectName == 'Account'){
            acclist = [select id,Name from Account where Id =:recordId];
            
        }
        if(objectName == 'Lead'){
            ldlst =[select Id,FinServ__RelatedAccount__r.Client_Type__c from Lead where Id =:recordId];
            
        }
        if(objectName == 'Case'){ // Added For W-7276 to meet checklist requirement
            caseList = new CasesSelector().selectByIdWithSLAInfo(recordId, 1);
            
        }
        
        List<getQuestionfieldInfo> questAnsList = (List<getQuestionfieldInfo>) JSON.deserialize(questionAns, List<getQuestionfieldInfo>.class);
        Set<string> questIds = new Set<string>();
        List<Questionnaire_Answer__c> NewanswerList = new List<Questionnaire_Answer__c>();
        for(getQuestionfieldInfo info : questAnsList){
            Questionnaire_Answer__c ans = new Questionnaire_Answer__c();
            if(String.isNotBlank(info.questionId)){
                ans.Questionnaire_Question__c = info.questionId;
                ans.Answer__c = info.userAnswer;
                ans.Answer_Data_Type__c =info.AnswerType;
                //ans.Answer_Data_Type__c ='string';
                ans.Questionnaire_Template__c = info.TemplateId;
                if(objectName == 'Opportunity'){
                    // List<Opportunity> opplist = [select id,AccountId from opportunity where Id =:recordId];
                    
                    ans.Related_Account__c =opplist[0].AccountId;
                    accId =opplist[0].AccountId;
                    ans.Related_Opportunity__c =opplist[0].id;
                }
                if(objectName == 'Account'){
                    //List<Account> acclist = [select id,Name from Account where Id =:recordId];
                    ans.Related_Account__c =acclist[0].Id;
                    accId =acclist[0].Id;
                    //ans.Related_Opportunity__c =opplist[0].id;
                }
                if(objectName == 'Lead'){
                    // List<Lead> ldlst =[select Id,FinServ__RelatedAccount__r.Client_Type__c from Lead where Id =:recordId];
                    //ans.Related_Lead__c = ldlst[0].Id;
                    ans.Related_Account__c =ldlst[0].FinServ__RelatedAccount__c;
                    accId = ldlst[0].FinServ__RelatedAccount__c;
                }
                if(objectName == 'Case'){ // Added For W-7276 to meet checklist requirement
                    //List<Case> caseList = new CasesSelector().selectByIdWithSLAInfo(recordId, 1);
                    Case caseRec = caseList[0];
                    ans.Related_Case__c = caseRec.Id;  
                    ans.Related_Account__c =caseRec.AccountId;
                    accId = caseRec.AccountId;
                }
                
                questIds.add(info.questionId); 
                NewanswerList.add(ans);
            }
        }
        List<Questionnaire_Answer__c> oldAnswers = [select id,Answer_Data_Type__c,Related_Account__c from Questionnaire_Answer__c where Questionnaire_Question__c IN: questIds AND Related_Account__c =:accId];
        if(!oldAnswers.isEmpty()){
            delete oldAnswers;  
        }
        
        if(!NewanswerList.isEmpty()){
            insert NewanswerList; 
        }
        
        
    }
    /**
* @description       : 
* @author            : almas.aleem@absa.africa
* @last modified on  : 2021-11-17
* @last modified by  : almas.aleem@absa.africa
**/
    public class getQuestionfieldInfo{
        @AuraEnabled public String answerControltype =''; // Added For W-7276 to meet checklist requirement
        @AuraEnabled public  boolean isChecked =false;  
        @AuraEnabled  public  string questionId ='';
        @AuraEnabled  public  string TemplateId ='';
        @AuraEnabled  public  string questionLabel ='';
        @AuraEnabled public  string AnswerType='';
        @AuraEnabled public  string defaultAnswer='';
        @AuraEnabled public  string userAnswer='';
        @AuraEnabled public  boolean isRequired =false;
        @AuraEnabled public  boolean isPepAndHigh =false;
        @AuraEnabled public   List<string> listofAnswerOptions = new List<string>();
        
    }
    
}