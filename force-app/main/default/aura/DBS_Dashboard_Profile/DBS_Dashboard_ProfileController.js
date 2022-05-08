({       
    removeToolTip : function(component, event, helper) {     
        var className = helper.profileTabToolTipClassMap(event.target.id);   
        if(className){
        	var focusId = className.substr(className.indexOf('-')+1);
        
        	var divClass = document.getElementsByClassName(className);
        	divClass[0].setAttribute('display-tooltip', 'false'); 
        	document.getElementById(focusId).focus();     
        }
    }, 
    copyToClipboardHandler : function(component, event, helper) { 
        var divClass = document.getElementsByClassName(helper.profileTabToolTipClassMap(event.target.id));
        divClass[0].setAttribute('display-tooltip', 'true');
         
        var copyTextToClipboard = document.getElementById(event.target.id);
        copyTextToClipboard.select();
        document.queryCommandSupported('copy');
        document.execCommand('copy');     
    },
    viewDebitInfoHandler: function(component, event, helper) {
        var info = component.get("v.profileObj");
        
        var textColourclass = '';
        
        if(info.cost_account_balance == 'No'){
            textColourclass = 'slds-text-color_error';
        }else{
            textColourclass = 'slds-text-color_success';                
        }
         
        var debitInfo = '<div class="box-top"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Cost account:</div>'+
            '<div class="slds-col light-bold">'+info.cost_account+'</div></div>'+
            '</div>'+'<div class="box-middle"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Cost account type:</div>'+
            '<div class="slds-col light-bold"">'+info.cost_account_type+'</div></div>'+
            '</div>'+'<div class="box-bottom"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Available balance:</div>'+
            '<div class="slds-col light-bold"">'+info.cost_account_balance+'</div></div>'+
            '</div>'+'<div class="box-top slds-m-top_x-small"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Debit account:</div>'+
            '<div class="slds-col light-bold"">'+info.debited_account+'</div></div>'+
            '</div>'+'<div class="box-middle"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Debit account type:</div>'+
            '<div class="slds-col light-bold"">'+info.debited_account_type+'</div></div>'+
            '</div>'+'<div class="box-bottom"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Available balance:</div>'+
            '<div class="slds-col light-bold">'+info.debited_account_balance+'</div></div>'+
            '</div>'+'<div class="box slds-m-top_medium"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col ">Amount owing:</div>'+
            '<div class="slds-col strong-bold">'+info.total_debit_amount+'</div></div>'+
            '</div>'+'<div class="box"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col ">Debited successfully:</div>'+
            '<div class="slds-col strong-bold">'+info.debited_successfully+'</div></div>'+
            '</div>'+'<div class="box"><div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col ">Available to debit:</div>'+
            '<div class="slds-col strong-bold '+textColourclass+'">'+info.available_to_debit+'</div>'+
            '</div></div>';     
         
        var modalObj = {
            header: 'Debit information',
            isOpen: true,
            body: debitInfo,
            modalStyle:'width:30%'
        };
        component.set("v.modalObj", modalObj); 
    },   
    viewLoginInfoHandler: function(component, event, helper) {
        var info = component.get("v.profileObj");
        
        var textColourclass = '';
        var last_logged_in_date = (info.internet_user_loged_in_date) ? utilities.formattedDate(info.internet_user_loged_in_date) : '';
        var last_logged_in_time = (info.internet_user_loged_in_time) ? utilities.formattedTime(info.internet_user_loged_in_time) : '';
        var loginInfo = '<div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Date:</div>'+
            '<div class="slds-col slds-text-title_bold">'+last_logged_in_date+'</div>'+
            '</div>'+'<div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">Time:</div>'+
            '<div class="slds-col slds-text-title_bold">'+last_logged_in_time+'</div>'+
            '</div>'+'<div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">User name:</div>'+
            '<div class="slds-col slds-text-title_bold '+textColourclass+'">'+info.internet_user_name+'</div>'+
            '</div>'+'<div class="slds-grid slds-grid_align-spread slds-p-bottom_medium">'+
            '<div class="slds-col">User number:</div>'+
            '<div class="slds-col slds-text-title_bold">'+info.internet_user_number+'</div>';   
        
        var modalObj = {
            header: 'Last successful login',
            isOpen: true,
            body: loginInfo,
            modalStyle:'width:25%' 
        };
        component.set("v.modalObj", modalObj); 
    },     
})