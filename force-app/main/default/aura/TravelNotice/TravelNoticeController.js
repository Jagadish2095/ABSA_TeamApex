({
    doInit : function(component, event, helper) {
        
        helper.doInit(component, event); 
        component.set("v.selectCombiCard", true);
        
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
     
        var today = new Date();
        component.set('v.pauseDate', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
     
    },
    
    
    showTransactionDetails: function(component, event, helper) {         
        var respObj = component.get("v.responseAccList");
        var combiAccountList = component.get('v.combiCardsAccounts');
        var indexvar = event.getSource().get("v.value");
        component.set("v.combiNumber",indexvar);
        console.log('Combi Card' + indexvar);
        
        component.set("v.selectCombiCard", false); 
        component.set("v.showSelectedCardDetails", true);
        
        var prodList = [];
        for(var key in respObj){
            	console.log('==='+respObj[0].productType);
             		if (!prodList.includes(respObj[key].productType)) {
                 		if (respObj[key].productType == 'CQ' || respObj[key].productType == 'SA' || respObj[key].productType == 'CA') {
                     		prodList.push(respObj[key].productType);
                  		}   
              		} 
          }
        component.set('v.prodTypesList',prodList);
 
    },
    getAccountNumbers : function(component, event, helper) {
         var selectedProdType = component.get('v.selectedProductValue');
         console.log('Selected Product ' + selectedProdType);
         var respObj = component.get('v.responseAccList');
         var acc = [];
         
         for(var key in respObj){
            
             if(respObj[key].productType == selectedProdType){
                 
                 acc.push(respObj[key].oaccntnbr);
                 
             }
         }
         
         component.set('v.accNumList',acc);
    }, 
     getSelectedAccount : function(component, event, helper) {
        component.set("v.isEnquiry", false);
        var selectedAccountValue = component.get('v.selectedAccountNumber');   
        console.log('Selected Account ' + selectedAccountValue);
          
        helper.enquiryTravelNotice(component,event);
     },
    
    submit: function(component , events , helper){
        component.set("v.isModalShow" , true);
    },
    
    closeModal:function(component,events){
        component.set("v.isModalShow" , false);
    },
    updateTravelNoticeModal:function(component, events, helper){
        component.set("v.isModalShow" , false);
        helper.updatePauseCard(component,events);
    }
    
 
    
})