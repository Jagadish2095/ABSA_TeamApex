({
    closeModel: function(component, event, helper) { 
      component.set("v.isOpen", false);
   },

  /* doInit: function (component, event, helper) {
       helper.resetCheckBox (component, event, helper);
   }, */
 
   createDupApplication: function(component, event, helper) {
      helper.createDuplicateApp(component, event, helper); 
      component.set("v.isOpen", false);
   },

   assetarticleDet: function(component, event, helper){
        var asartVal = component.find("assetArticle").get("v.checked");
        component.set("v.assetArticle", asartVal);          
           if (asartVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }   
    },    
    shorttermIns: function(component, event, helper){
        var stiVal = component.find("shortTerm").get("v.checked");
        component.set("v.shortTermInsurance", stiVal);           
            if (stiVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }     
    },
    contrDet: function(component, event, helper){
        var contrDetVal = component.find("contractDet").get("v.checked");
        component.set("v.contractDetails", contrDetVal);           
            if (contrDetVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }
    },
    contrEx: function(component, event, helper){
        var contrExVal = component.find("contractExtra").get("v.checked");
        component.set("v.contractExtras", contrExVal);
        	if (contrExVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }         
    },
    valueAddProd: function(component, event, helper){
       var valAddProdVal = component.find("valueAddedProd").get("v.checked");
       component.set("v.valueAddedProducts", valAddProdVal); 
        	if (valAddProdVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            } 
    },
    landwaivDet: function(component, event, helper){
       var landwDetVal = component.find("landLordWaiverDet").get("v.checked"); 
       component.set("v.landlordWaiverDetails", landwDetVal); 
        	if (landwDetVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }
    },
    dealDet: function(component, event, helper){
       var dealerDetVal = component.find("dealerDet").get("v.checked");  
       component.set("v.dealerDetails", dealerDetVal); 
         	if (dealerDetVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }        
    },
    struct: function(component, event, helper){
       var structVal = component.find("structure").get("v.checked"); 
       component.set("v.structure", structVal);  
        	if (structVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }
    },
    credAppDet: function(component, event, helper){
        var credAppDetVal = component.find("creditAppDet").get("v.checked");
        component.set("v.creditApplicationDetails", credAppDetVal);
        	if (credAppDetVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }
    },
    pInfo: function(component, event, helper){
        var prodInfoVal = component.find("prodInfo").get("v.checked");
        component.set("v.productionInformation", prodInfoVal);
        	if (prodInfoVal){
               component.set ("v.disableDuplicateButton", false );  
            }
            else{
                component.set ("v.disableDuplicateButton", true ); 
            }
    }, 
    dupNoInfo : function(component, event, helper){
        var dupNoInfoVal = component.find("dupNo").get("v.value");
        component.set("v.duplicateNo", dupNoInfoVal);
    },
})