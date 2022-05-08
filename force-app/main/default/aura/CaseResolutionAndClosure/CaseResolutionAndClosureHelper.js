({
    //Function to show spinner when loading
    showSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.removeClass(spinner, "slds-hide");
    },
    
    //Function to hide spinner after loading
    hideSpinner: function (component) {
        var spinner = component.find("TheSpinner");
        $A.util.addClass(spinner, "slds-hide");
    },
    
    //Function to show toast for Errors/Warning/Success
    getToast : function(title, msg, type) {
        
        var toastEvent = $A.get("e.force:showToast");
        
        toastEvent.setParams({
            "title":title,
            "message":msg,
            "type":type
        });
        
        return toastEvent;
    },
    
    //Close case closure tab and open new tab
    closeFocusedTabAndOpenNewTab : function( component, caseId ) {
 
    	var workspaceAPI = component.find("workspace");
        
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            
            var focusedTabId = response.tabId;
            
            console.log(focusedTabId);
		
            //Opening New Tab
            workspaceAPI.openTab({
                url: '#/sObject/' + caseId + '/view'
            }).then(function(response) {
                workspaceAPI.focusTab({tabId : response});
            })
            .catch(function(error) {
                console.log(error);
            });

            //Closing old tab
            workspaceAPI.closeTab({tabId: focusedTabId});
        })
        .catch(function(error) {
            console.log(error);
        });
    },

    //Smanga - Function to replace a comma as decimal point with full stop.
    checkIfNotNumber: function(component,event){

    var amountRefunded = component.get("v.amountRefunded");
    amountRefunded = amountRefunded.includes('.') ? amountRefunded.replace('.' , ',') : amountRefunded;
    console.log('AmountRefunded checkIfNotNumber==> ' + amountRefunded);
    component.set("v.amountRefunded",amountRefunded);
    
    /*if(isNaN(amountRefunded)){
        component.set("v.amountRefunded","");
    }*/   
},
    
//Smanga - Function to show/hide the upload statement file field.
    showUploadField: function(component,event, showField){

    component.set("v.showUploadStatementField", showField);
    
},

//Smanga - handle POP upload
handlePOPFilesChange: function(component, event) {
        
    var uploadedFileIds = [];
    var uploadedFiles = event.getParam("files");
    console.log('proofOfPayment uploadedFiles ==> ',uploadedFiles);
    
    if(uploadedFiles.length > 0){
        var filenames = '';
        for(var f = 0; f < uploadedFiles.length; f++){
            uploadedFileIds.push(uploadedFiles[f]['documentId']);
            filenames += uploadedFiles[f]['name']+"; ";
        }
        if(filenames != ''){
            var fpocfileText2 = component.find('fpocfileText2');
            $A.util.removeClass(fpocfileText2, 'slds-text-color_error');
            $A.util.addClass(fpocfileText2, 'slds-text-color_success');
        }else{
               var fpocfileText2 = component.find('fpocfileText2');
            $A.util.removeClass(fpocfileText2, 'slds-text-color_success');
            $A.util.addClass(fpocfileText2, 'slds-text-color_error'); 
        }
        console.log('uploadedFileIds: ==> ',uploadedFileIds);
        component.set("v.proofOfPaymentfileStr", filenames);
        component.set("v.proofOfPaymentfileIds", uploadedFileIds);
    }
    
},

//function for showing the reminder to pload POP - Simangaliso Mathenjwa 22 Sep 2020
showReminderAction : function(component, event, open){
    component.find('notifLib').showNotice({
            "variant": "Warning",
            "header": "Friendly Reminder!",
            "message": "Have you attached the proof of payment for your refund, if not do so before case can be closed",
            closeCallback: function() {
                component.set("v.showTheReminder", false);
                /*var scrollOptions = {
                    left: 0,
                    top: 220,
                    behavior: 'smooth'
                };
                window.scrollTo(scrollOptions);*/
           }
           
       });
},

})