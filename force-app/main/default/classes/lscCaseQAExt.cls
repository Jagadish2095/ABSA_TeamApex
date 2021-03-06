/**
* Author: Koketso Mpshane
* Date:   2019-08-07
* Desc:   1)It is used to create and update CaseChecklist record Record with related case and TemplateId.
*         2)Controller for the lightning quick action Aura bundle lscCaseQA
*          Lists all the available checklist and QA options per the business area of the running user
*/
public class lscCaseQAExt {
    
    @AuraEnabled
    public static ResponseDTO getChecklistTemplateRecord(){
        try{
            list<User> runningUser = [Select Hub__c From User Where Id = :UserInfo.getUserId()];
            
            list<Case_Checklist_Template__c> checklistTemplates = [Select Id, Checklist_Name__c, Business_Area__c From Case_Checklist_Template__c Where Business_Area__c = :runningUser[0].Hub__c];
            
            if(!checklistTemplates.isEmpty()){
                return new ResponseDTO(true, 'success', checklistTemplates) ;
            }
            else{
                return new ResponseDTO(false, 'There is no checklist templates for the user: ' + UserInfo.getUserName(), null) ;
            }
        }
        catch(Exception ex){
            return new ResponseDTO(false, ex.getMessage(), null) ;
        }
    }
    
    @AuraEnabled
    public static ResponseDTO getQAtemplateRecord(){
        try{
            list<User> runningUser = [Select Hub__c From User Where Id = :UserInfo.getUserId()];
            list<Case_QA_Template__c> qaTemplates = [Select Id, QA_Name__c, Business_Area__c From Case_QA_Template__c Where Business_Area__c = :runningUser[0].Hub__c];
            
            if(!qaTemplates.isEmpty()){
                return new ResponseDTO(true, 'success', qaTemplates) ;
            }
            else{
                return new ResponseDTO(false, 'There is no QA templates for the user: ' + UserInfo.getUserName(), null) ;
            }
        }
        catch(Exception ex){
            return new ResponseDTO(false, ex.getMessage(), null) ;
        }
    }
    
    /*
	* Purpose : To get CaseQa Records onlaod of component using caseId and templateId.
	* Param : 1)caseId 
	*         2)templateId 
	*/
    @AuraEnabled
    public static ResponseDTO getCaseChecklistRecords(String caseId, String templateId,String submittedBy){
        list<Case_Checklist__c> currentChkList ;
        String chkListId ;
        map<String,String> selectionMap = new  map<String,String>() ;
        
        String submittedById = string.isNotBlank(submittedBy)? submittedBy:UserInfo.getUserId();
        try{
            //check if there is an existing checklist saved for this template for this case
            currentChkList = [Select Id, Name, Submitted_By__c, Validated_By__c, Date_Submitted__c, Date_Validated__c, Validate__c, Saved_Results__c, Related_Case__c, 
                              Case_Checklist_Template__c From Case_Checklist__c Where Case_Checklist_Template__c = :templateId And Related_Case__c = :caseId And Submitted_By__c = :submittedById];
            
            if(currentChkList.size() > 0){
                chkListId = currentChkList[0].Id;
                //get metadata
                if(String.isNotBlank(currentChkList[0].Saved_Results__c)){
                    selectionMap = getQuestionState(currentChkList[0].Saved_Results__c) ;
                }
            }
            
            //get the checklist blue print
            list<Case_Checklist_Template__c> bluePrint  = [Select Id, Business_Area__c, Checklist_Name__c, (Select Id, Heading__c, Question__c From Case_Checklist_Questions__r order by Heading__c asc) 
                                                           From Case_Checklist_Template__c Where Id = :templateId limit 1];
            
            if(bluePrint.size() > 0){
                ResponseDTO res =  getQuestionList(bluePrint, selectionMap, chkListId);
                return res ;
                
            }else{
                return new ResponseDTO(false, 'There is no checklist template configure with this Id '+ templateId, null) ;
                
            }
        }
        catch(Exception ex){
            return new ResponseDTO(false, ex.getMessage(), null) ;
        }
    }
    
    /*
	* Purpose : To get questions answer maintain map using saveResult field from caseQa record.
	* Param : 1)saveResult  
	*/
    private static map<String,String> getQuestionState(String saveResult) {
        map<String,String> selectionMap = new map<String,String>(); 
        list<String> allSaved = saveResult.split(';');
        
        for(String selection :allSaved){
            list<String> res = selection.split('\\|');
            selectionMap.put(res[0],res[1]);
        }
        return selectionMap ;
    }
    
    /*
	* Purpose : To get questions list for displaying question in component.
	* Param : 1)qaBluePrint - used to get question and heading related with template record.
	*         2)selectionMap - used to display maintain state for questions answer.
	*         3)chkListId - used to upade exist checklist record.  
	*/
    private static ResponseDTO getQuestionList(List<Case_Checklist_Template__c> bluePrint, map<String,String> selectionMap, String chkListId) {
        list<FormStructure> wFormStructure = new list<FormStructure>();
        list<FormSelection> wFormSelection = new list<FormSelection>();
        String headingX = '';
        String headingY = '';
        //build the heading with related questions map
        FormSelection fs;
        
        for(Case_Checklist_Question__c q :bluePrint[0].Case_Checklist_Questions__r){
            headingX = q.Heading__c;
            if(selectionMap.containsKey(q.Id)){
                fs = new FormSelection(q.Question__c, q.Id, selectionMap.get(q.Id));
            }else{             
                fs = new FormSelection(q.Question__c, q.Id, '');
            }
            
            if(headingX == headingY || headingY == ''){
                wFormSelection.add(fs);
            }else{
                list<FormSelection> wNewFormSelection = new list<FormSelection>(wFormSelection);
                FormStructure fstr = new FormStructure(chkListId, headingY,wNewFormSelection);
                wFormStructure.add(fstr);
                wFormSelection.clear();
                wFormSelection.add(fs);
            }
            headingY = q.Heading__c;
        }
        
        //add last list of questions to the wrapper after we have exite the loop
        FormStructure fstr = new FormStructure(chkListId, headingY, wFormSelection);
        wFormStructure.add(fstr);
        return new ResponseDTO(true, 'success', wFormStructure) ;
    }
    
    /*
	* Purpose : To update record.
	* Param : 1)id - Case checklist record id
	*         2)templateId
	*         3)savedResults - used to update selecte questions answer.
	*         4)caseId 
	*/
    @AuraEnabled
    public static ResponseDTO updateCaseChecklistRecord(String id, String templateId, String savedResults, String caseId){
        Case_Checklist__c caseChecklist = new Case_Checklist__c();
        try{
            if(String.isBlank(id)){
                caseChecklist.Id = createCaseChecklistRecord(templateId, caseId);
            }else{
                caseChecklist.Id = id ;
            }
            caseChecklist.Case_Checklist_Template__c = templateId ;
            caseChecklist.Saved_Results__c = savedResults;
            caseChecklist.Submitted_By__c = UserInfo.getUserId() ;
            caseChecklist.Related_Case__c = caseId ;
            update caseChecklist ;
            
            System.debug('caseChecklist=='+caseChecklist);
            return new ResponseDTO(true, 'success', null) ;
        }
        catch(Exception ex){
            return new ResponseDTO(false, ex.getMessage(), null) ;
        }
    }
    
    /*
	* Purpose : To create caseChecklist record if record not exist.
	* Param : 1)templateId 
	*         2)caseId
	*/
    private static String createCaseChecklistRecord(String templateId, String caseId){
        Case_Checklist__c checklist = new Case_Checklist__c();
        checklist.Case_Checklist_Template__c = templateId ;
        checklist.Related_Case__c = caseId ;
        checklist.Submitted_By__c = UserInfo.getUserId() ;
        
        insert checklist;
        return checklist.Id ;
    }
    
    /*
	* Purpose : To return respose.
	*/
    public class ResponseDTO{
        @AuraEnabled public boolean isSuccess ;
        @AuraEnabled public String message ;
        @AuraEnabled public List<object> objectList;
        
        public ResponseDTO(boolean isSuccess, String message, List<object> objectList){
            this.isSuccess = isSuccess;
            this.message = message;
            this.objectList = objectList;
        }
    }
    
    //NESTED CLASSES
    //Case_Checklist_Template__c wrapper class to keep track of selected questions and to keep the form structure
    public class FormStructure{
        @AuraEnabled public String chkListId ;
        @AuraEnabled public String heading ;
        @AuraEnabled public list<FormSelection> questions ;
        
        public FormStructure(String chkListId, String heading, list<FormSelection> questions){
            this.chkListId = chkListId ;
            this.heading = heading;
            this.questions = questions;
        }
    }
    
    /*
	* Purpose : To keep track of selected question. 
	*/
    public class FormSelection{
        
        @AuraEnabled public String question ;
        @AuraEnabled public String questionId ;
        @AuraEnabled public String selectedChoice;
        
        public FormSelection(String question, String questionId, String IsChecked ){
            this.question = question;
            this.questionId = questionId;
            
            if(IsChecked == 'Yes'){
                selectedChoice = 'Yes';
            }else if(IsChecked == 'No'){
                selectedChoice = 'No';
            } else if(IsChecked == 'NA'){
                selectedChoice = 'NA';
            }
        }
    }   
    
}