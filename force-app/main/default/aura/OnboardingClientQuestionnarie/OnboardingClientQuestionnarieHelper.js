({
    getRecordTypeNamehelper: function (component,event, helper) {
        var action = component.get("c.getRecordType");
        var recordId;
        if(component.get("v.recordId")){
           recordId =component.get("v.recordId"); 
        }else if(component.get("v.accId")){
          recordId =component.get("v.accId");   
        }
        action.setParams({
            recordId: recordId //component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();                
                console.log('data'+data);
                component.set("v.RecordTypeName", data);
               // console.log('data.RecordType.Name',data);
                /*if(data =='Wealth Offshore Onboarding'){
                   this.getOpportunityDetails(component); 
                } */
               
                if(data == 'Face2Face Lead' || data =='Wealth Offshore Onboarding'||data=='Business Prospect'||data =='Individual Prospect' || data == 'LDP Fulfilment'){
                   this.getQuestionWrapperhelper(component, event, helper);
                }
                   // this.getQuestionWrapperhelper(component);
            }
            else {
                console.log("Failed with state: " + state);
            }
        });
        $A.enqueueAction(action);
    },
	/*    
    getOpportunityDetails: function(component, event, helper) {
        var action = component.get("c.getOpportunityDetails");        
        action.setParams({
            recordId: component.get("v.recordId")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.opportunityRec", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
	*/    
    getQuestionWrapperhelper: function(component, event, helper) {
        
      var recid;
      if(component.get("v.recordId")){
         recid =  component.get("v.recordId");
      }else if(component.get("v.accId")){
        recid =  component.get("v.accId");
      }
      var tempName =  component.get("v.RecordTypeName");
     
      var builddata=[];
      //call apex class method
      var action = component.get('c.getQuestionList');
        action.setParams({
            recordId:recid,
            TemplateName : tempName
        });
      action.setCallback(this, function(response) {
        //store state of response
        var state = response.getState();
        if (state === "SUCCESS") {
            var questMap =response.getReturnValue();
           // alert(JSON.stringify(response.getReturnValue()));
             for ( var sectkey in questMap ) {
                    builddata.push({value:questMap[sectkey], key:sectkey});
                }
           // alert('==builddata'+JSON.stringify(builddata));
          component.set("v.questionwithsectionlist",builddata);
          //component.set('v.QuestionWrapper', response.getReturnValue());
        }
      });
      $A.enqueueAction(action);
    },
    validateandSave:function(component, event, helper) {
        var jsonData={};    //new Map();
        var jsonObj = [];
       component.set("v.showSpinner",true);
       var recid= component.get("v.recordId");
        console.log('recid---'+recid);
       var wrapdata = component.get("v.QuestionWrapper");
       // alert('wrapdata'+wrapdata);
       console.log(component.get("v.questionwithsectionlist"));
        
       var questionwithAns = component.get("v.questionwithsectionlist");
       // alert('==questionwithAns'+questionwithAns);
       var datawithAns=[];
        var Willhave =false;
        var WillKept =true;
        questionwithAns.forEach(function(data){
            var finaldata = data.value;
            finaldata.forEach(function(finaldat){
                datawithAns.push(finaldat);
               
                jsonData[finaldat.questionLabel]= finaldat.userAnswer;    
                
                
				
            })
      
        }) 
        for(var dat of datawithAns){
            if(dat.isRequired && (dat.userAnswer ==='' || dat.userAnswer==='--None--') ){
                helper.toastMessage('Error','Error', 'Please fill required information.');
                 component.set("v.showSpinner",false);
                return;
            }
            
        }    
		//(jsonData['Where the Will is Kept?'] ); Where the Will is Kept?
        if (jsonData['Do you have Will?'] === 'Yes' && (jsonData['Where the Will is Kept?'] ===undefined || jsonData['Where the Will is Kept?'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Where the Will is Kept? Should not be blank');
            component.set("v.butonDisable",false);
            return null; 
        }
         if (jsonData['Does the client have connections with government agencies or government owned entities in the following countries:Belarus,Cuba,Iran,Iraq,Ivory Coast,Lebanon,Liberia,Myanmar,North Korea,Somalia,Sudan(incl.North Sudan and South Sudan),Syria,The Democratic Republic of Congo,Yemen,Zimbabwe,Russia,Crimea,Central African Republic,Libya,Venezuela'] === 'Yes' &&
             (jsonData['Provide additional details if client has connections with government agencies or government owned entities'] ===undefined || jsonData['Provide additional details if client has connections with government agencies or government owned entities'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Provide additional details If connections with government agencies is Required if you have government owned entities from above list');
            component.set("v.butonDisable",false);
            return null; 
        }
        
         if (jsonData['Does the client conduct business in restricted countries?'] === 'Yes' &&
             (jsonData['Provide additional details if client conducts business in restricted countries'] ===undefined || jsonData['Provide additional details if client conducts business in restricted countries'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Provide additional details if client conducts business in restricted countries is Required if Client have business with restricted countries');
            component.set("v.butonDisable",false);
            return null; 
        }
        //alert(jsonData['Provide additional details if client deals in conflict diamonds']);
         if (jsonData['Does the client deal in conflict diamonds?'] === 'Yes' &&
             (jsonData['Provide additional details if client deals in conflict diamonds'] ===undefined || jsonData['Provide additional details if client deals in conflict diamonds'] ==='') ){
                component.set("v.showSpinner",false);
                helper.toastMessage('Error','Error', 'Provide additional details If client deal in conflict diamonds is Required if Client deal with conflict diamonds');
                component.set("v.butonDisable",false);
            return null; 
        }
        /* if (jsonData['Is the client or any party connected to a PEP'] === 'Yes' &&
             (jsonData['what is the PEP Relationship with the Client'] ===undefined || jsonData['what is the PEP Relationship with the Client'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'what is the PEP Relationship with the Client is Required ');
            component.set("v.butonDisable",false);
            return null; 
        }*/
         if (jsonData['Does the client deal in export of goods including but not limited to military goods or technology, dual use goods or technology or US origin goods or technology in breach of applicable export controls?'] === 'Yes' &&
             (jsonData['Provide additional details if client deals in export of goods including but not limited to military goods or technology, dual use goods or technology or US origin goods or technology in breach of applicable export controls'] ===undefined ||
              jsonData['Provide additional details if client deals in export of goods including but not limited to military goods or technology, dual use goods or technology or US origin goods or technology in breach of applicable export controls'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Provide additional details If client deal in export of goods including but not limited to military goods is Required');
            component.set("v.butonDisable",false);
            return null; 
        }
         if (jsonData['FATCA Impact'] === 'Yes' &&
             (jsonData['FATCA Documents'] === undefined || jsonData['FATCA Documents'] === '') ){
             //alert(jsonData['FATCA Documents']);
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'FATCA Documents is Required if Client had FATCA Impact');
            component.set("v.butonDisable",false);
            return null; 
        }
        
        if (jsonData['Is the client or any party connected to a PEP'] === 'Yes' &&
             (jsonData['Nature of prominent public function that the PEP is or has been entrusted with'] ===undefined || jsonData['Nature of prominent public function that the PEP is or has been entrusted with'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Nature of Prominent public function that the PEP is or has been entrusted with is Required If connected to PEP');
            component.set("v.butonDisable",false);
            return null; 
        }
         if (jsonData['Is the client or any party connected to a PEP'] === 'Yes' &&
             (jsonData['What is the PEP relationship with the client'] ===undefined || jsonData['What is the PEP relationship with the client'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'what is the PEP Relationship with the Client is Required if connected to PEP ');
            component.set("v.butonDisable",false);
            return null; 
        }
        if (jsonData['Any money coming from PEP?'] === 'Yes' &&
             (jsonData['Details of amounts invested and date'] ===undefined || jsonData['Details of amounts invested and date'] ==='') ){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Details of amounts invested and date is Required if money coming from PEP ');
            component.set("v.butonDisable",false);
            return null; 
        }
        /*to validate the Source of Income/funds/Wealth Background... fields 
        var opptRec = component.get("{!v.opportunityRec}");       
        if ((opptRec['Account.The_Client_is_involved_in_High_Risk_Indu__c']!=='NOT INVOLVED' ||
             opptRec['PEP_Status__c']=='Heightened' || opptRec['PEP_Status__c']=='High' ||
             opptRec['Risk_Rating__c']=='High' || opptRec['Risk_Rating__c']=='Very High'
            ) && (
            jsonData['Source of Income Background'] ==='' ||
            jsonData['Source of Funds Background'] ==='' ||
            jsonData['Source of Wealth Background'] ===''
             )){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Source of Income/Funds/Wealth values are Required');
            component.set("v.butonDisable",false);
            return null; 
        } */
         if (jsonData['US Tax Form Obtained ?'] === 'Yes' &&
             (jsonData['US Tax Form'] ===undefined || jsonData['US Tax Form'] ==='' || jsonData['US Tax Form'] ==='--None--') ){
             
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'US Tax Form is Required if Client is obtained US Tax Form');
            component.set("v.butonDisable",false);
            return null; 
        }
          if (jsonData['US Tax Form Obtained ?'] === 'No' || jsonData['US Tax Form Obtained ?'] ==='--None--'){
            component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Waring! If you have selected No you will not be able to complete the on-boarding Process');
            component.set("v.butonDisable",false);
            return null; 
        }
        let timeallocations=0;
        let Manual=0;
        let Administration=0;
        let Supervision=0;
        let Travel=0;
        if(jsonData['Manual'] !== undefined && jsonData['Manual'] !==''){
            
            Manual=parseInt(jsonData['Manual']);
        }  if (jsonData['Administration'] !== undefined && jsonData['Administration'] !==''){
            Administration =parseInt(jsonData['Administration']);
        } if (jsonData['Supervision'] !== undefined && jsonData['Supervision'] !==''){
            Supervision =parseInt(jsonData['Supervision']);
        } if (jsonData['Travel'] !== undefined && jsonData['Travel'] !==''){
            Travel =parseInt(jsonData['Travel']);
        }
        timeallocations =Manual+Administration+Supervision+Travel;
        if(timeallocations !==0 && (timeallocations > 100 || timeallocations < 100)){
             component.set("v.showSpinner",false);
            helper.toastMessage('Error','Error', 'Total time allocation should be equal to 100%');
            component.set("v.butonDisable",false);
            return null; 
        }
       /* for(var dat of datawithAns){
            if(dat.isRequired && (dat.userAnswer ==='' || dat.userAnswer==='--None--') ){
                helper.toastMessage('Error','Error', 'Please fill required information.');
                 component.set("v.showSpinner",false);
                return;
            }
            
        }*/    
        //alert('datawithAns'+datawithAns);
       var jsonstring = JSON.stringify(datawithAns);
        
       // alert(jsonstring);
      var action = component.get('c.saveQuestionAnswer');
        action.setParams({
            questionAns : jsonstring,
            recordId : recid
        });
      action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS") {
            component.set("v.showSpinner",false);
            helper.toastMessage('Success','Success', 'Answers created Successfully.');
             $A.get('e.force:refreshView').fire();
        }else{
           component.set("v.showSpinner",false);
          helper.toastMessage('Error','Error', 'Something went wrong,please contact Adminstration.');

        }
      });
      $A.enqueueAction(action);  
        
    },
     toastMessage : function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": type,
            "title": title,
            "message": message
        });
        toastEvent.fire();
    },
})