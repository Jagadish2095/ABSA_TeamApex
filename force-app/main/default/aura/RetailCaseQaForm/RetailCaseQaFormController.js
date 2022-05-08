({
    /*
     * Purpose : used to get onload data to display. 
     */
    doInIt : function(component, event, helper) {
        helper.showSpinner(component);
        
        var caseId = component.get("v.caseId");
        var templateId = component.get("v.templateId");
        var submittedBy = component.get("v.submittedBy");
        
        var param = {
            'caseId' : caseId,
            'templateId' : templateId,
            'submittedBy' : submittedBy
        };
        
        helper.callServer(component, 'getCaseQaRecords', param, false, function(resp){
            //console.log('resp',resp);
            if(resp.isSuccess){	
                //debugger;
                var result = resp.objectList ;//caseQaRecord
                component.set('v.caseQalist', result);
                component.set('v.wtotal', result[0].weighting);
                helper.onloadCalculateAgentScore(component);
                if(result[0].caseQaRecord){
                    if(result[0].caseQaRecord.Agent_Name__c){
                        component.set('v.agentName', result[0].caseQaRecord.Agent_Name__r.Name);
                    }
                    //component.set('v.agentScore', Math.ceil(result[0].caseQaRecord.AgentScorePer__c));
                }
                helper.hideSpinner(component);
                console.log('caseQalist',component.get('v.caseQalist'));
            }
            else{
                helper.hideSpinner(component);
                console.log('message',resp.message);
                helper.showMsg(component, event, 'Error', 'error', resp.message);
            } 
        });
        
        var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.setTabLabel({
                tabId: focusedTabId,
                label: templateId
            });
        })
        .catch(function(error) {
            console.log(error);
        });   
        
    },
    
    /*
     * Purpose : used to get selected question answer. 
     */
    onRadioButtonClick : function(component, event, helper) {
        var id = event.target.id ;
        var dataset = event.currentTarget.dataset;
        //console.log(value.qid);
        
        var choice = dataset.choice;
        var qId = dataset.qid;
        var sectionIndex = qId.split('-')[0];
        var questionIndex = qId.split('-')[1];
        var checklist = component.get("v.caseQalist");
        var question  = checklist[sectionIndex].questions[questionIndex];
        console.log('sectionIndex** ', sectionIndex);
        question.selectedChoice = choice;
        
        var naChecks = component.find('na_check');
        naChecks[sectionIndex].set("v.value", false);
        
        helper.calculateScore(component, event);
    },
    
    /*
     * Purpose : To reset all the selected question. 
     */
    resetScore : function(component, event, helper){
        helper.resetScore(component);
    },
    
    /*
     * Purpose : To create or update caseQa record. 
     */
    save : function(component, event, helper){
        helper.showSpinner(component);
        var agentRecord = component.get("v.selectedLookUpRecord");
        //console.log('agentRecord',agentRecord);
        var agentName = component.get("v.agentName");
        console.log('agentName',agentName);
        var agentScore = component.get("v.agentScore");
        var caseQalist = component.get("v.caseQalist");
        var questionList = caseQalist[0].questions;
        var savedResults='';        
        var qaComment = component.find("qaComment");
       
        var failedAuditRequirement = false;
        for(var x=0;x<caseQalist.length;x++)
        {
            var questionSet = caseQalist[x].questions;
            for(var index=0; index < questionSet.length; index++){
                savedResults += questionSet[index].questionId + '|' + questionSet[index].selectedChoice + ';';
                if(questionSet[index].isAuditQuestion && questionSet[index].selectedChoice == 'No'){
                    failedAuditRequirement = true;
                }
            }
            }
        
        console.log('SavedResults',savedResults); 
        
        if((! $A.util.isEmpty(agentName) && agentName.trim() != '') || agentRecord){
            var caseQa = 
                {
                    Saved_Results__c : savedResults,
                    Submitted_By__c : $A.get("$SObjectType.CurrentUser.Id") ,
                    Related_Case__c : component.get("v.caseId"),
                    QA_Template__c : component.get("v.templateId"),
                    Agent_Score__c : component.get("v.currentScore"),
                    Weighting_Total__c : component.get("v.wtotal") - component.get("v.naCount"),
                    Failed_Audit_Requirement__c : failedAuditRequirement
                }
            if(agentRecord){
                caseQa.Agent_Name__c = agentRecord.Id ;
            }
            if(caseQalist[0].caseQaRecord){
                caseQa.Id = caseQalist[0].caseQaRecord.Id ;
            }
            
            if(qaComment != null){
                caseQa.Comment__c = qaComment.get("v.value");
            }
            
            var param = {
                caseQa : caseQa                    
                }
            helper.callServer(component, 'updateCaseChecklistRecord', param, false, function(resp){
                //console.log('resp',resp);
                if(resp.isSuccess){	
                    helper.hideSpinner(component);
                    helper.showMsg(component, event, 'Success', 'success', resp.message);
                    helper.closeFocusedTab(component);
                }
                else{
                    helper.hideSpinner(component);
                    console.log('message',resp.message);
                    helper.showMsg(component, event, 'Error', 'error', resp.message);
                } 
            });
        }
        else{
            helper.hideSpinner(component);
            helper.showMsg(component, event, 'Warning', 'warning', 'Please search and add an Agent that you would like to submit this QA form for');
        }
    },
    
    /*
     * Purpose : To reset selected section. 
     */
    notApplicableCheck : function(component, event, helper){
        
        var naChecks = component.find('na_check');
        var qalists = component.get("v.caseQalist");
        
        for(var x = 0; x < qalists.length; x++){
            var naIsChecked = naChecks[x].get("v.value");
            console.log('naIsChecked'+x+'**', naIsChecked);
            qalists[x].questions.forEach(function(questionObj){
                if(naIsChecked == true){
                    questionObj.selectedChoice = 'NA';
                }
            });
        }
        component.set("v.caseQalist", qalists);
        helper.onloadCalculateAgentScore(component);
          
    },
    
})