({
	closeModalhelper : function(component, event) {
      component.set("v.isModalOpen", false);
      component.set("v.modalObj.isOpen", false); 		
	},
    displayError : function(component, event, boolDisplay) {       
        var hide = component.find('error');        
        if(boolDisplay){ 
            $A.util.removeClass(hide, 'slds-hide');          	
        }else{ 
            $A.util.addClass(hide, 'slds-hide');    
        }                           
    }
})