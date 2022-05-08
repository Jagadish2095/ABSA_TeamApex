({
	GenerateBrokerNoteInECM : function(component, event, helper) {
       
        var CaseId= component.get("v.recordId"); //'5000E00000DUm0aQAD';
        console.log('CaseId-->'+CaseId);
        let TemplateName='BrokerNote';
        var action = component.get("c.generateNewDocument");
        action.setParams({
            "caseId": CaseId,
            "templateName" : TemplateName
        });
        action.setCallback(this, function(a) {
            var state = a.getState();
            console.log('state-->'+state);
            if (state === "SUCCESS") {
                var data = a.getReturnValue();
                console.log('response----'+JSON.stringify(data));              
                if(data.success== 'true'){
                  helper.generateBrokerNotePDFLink(component, event, helper);
                 var toastEvent = $A.get('e.force:showToast');
                              toastEvent.setParams({
                                  title: 'Success!',
                                  message: 'Document Successfully Generated',
                                  type: 'success'
                              });
                              toastEvent.fire();  
                     component.set("v.isLoading",	false);
                }
                else if(data.success== 'false'){
                    if(JSON.stringify(data).includes('REQUIRED_FIELD_MISSING'))
                    {
                         var toastEventServDown = $A.get('e.force:showToast');
                              toastEventServDown.setParams({
                                  title: 'Error!',
                                  message: 'Service is down please try in some time.',
                                  type: 'error'
                              });
                              toastEventServDown.fire(); 
                        
                    }
                    if(JSON.stringify(data).includes('selectByAdviserCode'))
                    {
                         var toastEventAdvCodeMissing = $A.get('e.force:showToast');
                              toastEventAdvCodeMissing.setParams({
                                  title: 'Error!',
                                  message: 'Advisor Code on case and user is not matching.',
                                  type: 'error'
                              });
                              toastEventAdvCodeMissing.fire(); 
                        
                    }
                    else
                    {
                        var toastEvent = $A.get('e.force:showToast');
                              toastEvent.setParams({
                                  title: 'Error!',
                                  message: 'Document Generation Failed',
                                  type: 'error'
                              });
                              toastEvent.fire();  
                    }
                     component.set("v.isLoading",	false);
                }   
                 //helper.getDocumentId(component, event, helper);
                 
            }
            
             else if (state === "ERROR") {
                 var toastEvent = $A.get('e.force:showToast');
                              toastEvent.setParams({
                                  title: 'Error!',
                                  message: 'Document Generation Failed as service is down.',
                                  type: 'error'
                              });
                              toastEvent.fire();
                 component.set("v.isLoading",	false);
                var errors = a.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getDocumentId : function(component, event, helper) {
         var CaseId=component.get("v.recordId"); 
        console.log('getDocumentId CaseId--->'+CaseId);
        var action = component.get("c.FetchDocumentId");
        action.setParams({
            "CaseId": CaseId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            console.log('state '+state);
            if (state === "SUCCESS") {
                console.log('Reference Key-->'+response.getReturnValue());
                  component.set("v.FileReferenceKey",response.getReturnValue());
                 component.set("v.isLoading",	false);
            }
            else if (state === "ERROR") {
                component.set("v.isLoading",	false);
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },
    
         download: function (component, event, helper,DocId) {
    	//component.set('v.showSpinner', true);
    	  var CaseId = component.get("v.recordId"); //'5000E00000DUm0aQAD';
           var FileName =   component.get("v.fileName")
          var action = component.get('c.getDocumentContent');
            console.log('DocId---->'+DocId);
        action.setParams({
            "documentId": DocId //'a0z0E000005hUhdQAE'//component.get("v.FileReferenceKey") 
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var element = document.createElement('a');
               // element.setAttribute('href', 'data:application/octet-stream;content-disposition:attachment;base64,' + data);
                element.setAttribute('href', 'data:application/pdf;content-disposition:attachment;base64,' + data);
               // element.setAttribute('download', CaseId);                
                element.setAttribute('download', FileName);
                element.style.display = 'none';
                document.body.appendChild(element);		
                element.click();		
                document.body.removeChild(element);
            } else {
                console.log("Download failed ...");
            }
            //component.set('v.showSpinner', false);
        }));
        $A.enqueueAction(action);
    },
    
     previewFile :function(component, event, helper){
        var selectedPillId =component.get("v.FileReferenceKey"); //event.getSource().get("v.name");
        console.log('--',selectedPillId);
        $A.get('e.lightning:openFiles').fire({
            recordIds: [selectedPillId]
        });
     },
       generateBrokerNotePDFLink : function(component, event, helper){
         
          component.set("v.isAIMSPDF",false);
          component.set("v.AIMSPDFName",'');  
          component.set("v.isMomentumPDF",false);
          component.set("v.MomentumPDFName",'');
          component.set("v.isLibertyPDF",false);
          component.set("v.LibertyPDFName",'');
           
          component.set("v.isSanlamPDF",false);
          component.set("v.SanlamPDFName",'');
           
          component.set("v.isWills",false);
          component.set("v.WillsPDFName",'');
           
          component.set("v.isAbsaLife",false);
          component.set("v.AbsaLifePDFName",'');
         
         var CaseId = component.get("v.recordId"); //'5000E00000DUm0aQAD';
        var action = component.get("c.getActiveNoteBrokerPDF");
        action.setParams({
             "caseID" : CaseId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                  let AIMSSeq = 'AIMS';
                  let LIBERTYSeq = 'LIBERTY';
                  let SANLAMSeq = 'SANLAM';
                  let MOMENTUMSeq = 'MOMENTUM';
                  let WillsSeq = 'WILLS';
                  let AbsaLifeSeq = 'ABSA LIFE';
                  component.set("v.FileReferenceKey",'');
                var data = response.getReturnValue();               
                for (var i=0; i < data.length; i++) {
                    let FileName = data[i].Name;
                   console.log('Himan1--->'+data[i].Name);

                    
                   if( FileName.includes(AIMSSeq))
                    {
                       component.set("v.isAIMSPDF",true);
                       component.set("v.AIMSPDFName",data[i].Name);     
                       component.set("v.AIMSPDFID",data[i].Id);  
                       component.set("v.FileReferenceKey",data[i].Id+'$');
                       console.log('Himan isAIMSPDF--->'+data[i].Name);
                    }
                     if( FileName.includes(LIBERTYSeq))
                    {
                       component.set("v.isMomentumPDF",true);
                       component.set("v.MomentumPDFName",data[i].Name);
                       component.set("v.MomentumPDFID",data[i].Id);  
                       component.set("v.FileReferenceKey",data[i].Id+'$');
                       console.log('Himan isMomentumPDF--->'+data[i].Name);
                    }
                     if( FileName.includes(SANLAMSeq))
                    {
                       component.set("v.isLibertyPDF",true);
                       component.set("v.LibertyPDFName",data[i].Name);
                       component.set("v.LibertyPDFID",data[i].Id); 
                       component.set("v.FileReferenceKey",data[i].Id+'$');
                       console.log('Himan isLibertyPDF--->'+data[i].Name);
                    }
                   if( FileName.includes(MOMENTUMSeq))
                    {
                       component.set("v.isSanlamPDF",true);
                       component.set("v.SanlamPDFName",data[i].Name);
                       component.set("v.SanlamPDFID",data[i].Id);  
                       component.set("v.FileReferenceKey",data[i].Id+'$') ;
                       console.log('Himan isSanlamPDF--->'+data[i].Name);
                    }
                    
                     if( FileName.includes(WillsSeq))
                    {
                       console.log('Wills-->'+data[i].Id);
                       component.set("v.isWills",true);
                       component.set("v.WillsPDFName",data[i].Name);
                       component.set("v.WillsPDFID",data[i].Id);  
                       component.set("v.FileReferenceKey",data[i].Id+'$') ;
                       console.log('Himan isWillsPDF--->'+data[i].Name);
                    }
                    
                     if( FileName.includes(AbsaLifeSeq))
                    {
                       console.log('Absa Life-->'+data[i].Id);
                       component.set("v.isAbsaLife",true);
                       component.set("v.AbsaLifePDFName",data[i].Name);
                       component.set("v.AbsaLifePDFID",data[i].Id);  
                       component.set("v.FileReferenceKey",data[i].Id+'$') ;
                       console.log('Himan isAbsaLifePDF--->'+data[i].Name);
                    }
                }
              
            }
            else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
            }
        }));
        $A.enqueueAction(action);
     },
    fileNameDisplay : function(component, event, helper){
        var action= component.get("c.userData");
        var userData;
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                var action1= component.get("c.getCustomer");
                
                console.log('******'+JSON.stringify(component.get("v.recordId")));
                action1.setParams({
            	"caseId": component.get("v.recordId") 
                 
        });
            action1.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data1 = response.getReturnValue(); 
                let today = new Date().toISOString().slice(0, 10);
                var name= 'Broker Note_'+'_'+data.AB_Number__c+'_'+today+'.pdf';//data1.Customer_ID__c+
                component.set("v.fileName",name);
                console.log('response---'+name);
                }
            }));
          $A.enqueueAction(action1);
          }
            
            
        }));
       $A.enqueueAction(action);
    },
        sendEmailsToProviders : function(component, event, helper){
        var CaseId = component.get("v.recordId"); //'5000E00000DUm0aQAD';
        var action = component.get("c.SendBrokerNotes");
            
        var toastEventSuccess = $A.get("e.force:showToast");
        toastEventSuccess.setParams({
            "title": "Success!",
            "message": "'Email Sent Successfully.'",
            type: 'success'
        });
        
        var toastEventError = $A.get("e.force:showToast");
        toastEventError.setParams({
            "title": "Error!",
            "message": "Please generate broker note first.",
            type: 'error'
        });
            
          let DocIDES=
        action.setParams({
            "documentId" : component.get("v.FileReferenceKey"), //'a0z0E000005RNUbQAO'
             "caseID" : CaseId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            component.set("v.isLoading", false);
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();    
                console.log('Data:::'+data);
                 if(response.getReturnValue() == 'Broker note not generated')
                {
                    console.log('Inside Error');
                    toastEventError.fire();
                }
                else
                {
                   console.log('Inside Success');
                    $A.get('e.force:refreshView').fire();
                    toastEventSuccess.fire();
                }
            }
            else
            {
                var errors = response.getError();
                if (errors) {
                    for(let error of errors){
                        let errorMessage = error.message;
                        let errorKey = errorMessage.match(/(\b[A-Z][A-Z]+([_]*[A-Z]+)*)/g).pop();
                        errorMessage = errorMessage.split(errorKey+", ").pop().split(": [").shift();
                        
                        var toastEvent = $A.get('e.force:showToast');
                        toastEvent.setParams({
                            title: 'Error!',
                            message: errorMessage,
                            type: 'error'
                        });
                        toastEvent.fire();  
                    }
                }
            }
        }));
        $A.enqueueAction(action);
            component.set("v.isLoading", true);
    },
    
    getContactNumbersforSMS : function(component, event, helper){
        var CaseId = component.get("v.recordId"); //'5000E00000DUm0aQAD';
        var action = component.get("c.getContacts");
        action.setParams({
            "caseID" : CaseId
        });
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                            
        		component.set('v.options',response.getReturnValue());
                console.log('response'+response.getReturnValue());
                console.log('opt'+component.get("v.options"));
            }
            else
            {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                }
                

            }
        }));
        $A.enqueueAction(action);
    }
    
})