({
    //Initiation of component
    initComp: function(component, event, helper) {
        //Get Client Hold Record Types with Status 
        helper.searchHelper(component,event);
        helper.getColumns(component);
       
    },
   
    //Function for handling the onclick when View button is clicked
    handleRowAction:function(component, event, helper){
        var row = event.getParam("row");
        var accountNumber = row.accNor;
        var actionName = event.getParam("action").name;

        if (actionName == "View") {
            component.set("v.isProductOpen", true);
            component.set("v.oProduct", row);
        }
        helper.showSpinner(component);
        helper.getAccountDetails(component, accountNumber);
        component.set("v.isProductOpen",true);
        component.set("v.isOpen",false);
        
     },
    closeProductModel :function(component, event, helper) {
        component.set("v.isProductOpen",false);
        component.set("v.isOpen",true);
    }, 
   
    openModel: function(component, event, helper) {
      // for Display Model,set the "isOpen" attribute to "true"
      helper.searchHelper(component,event);
      component.set("v.isOpen", true);
    },
 
    closeModel: function(component, event, helper) {
      // for Hide/Close Model,set the "isOpen" attribute to "Fasle"  
      component.set("v.isOpen", false);
    },
    
    onfocus : function(component,event,helper){
        
        helper.showSpinner(component);
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        
        var getInputkeyWord = '';
        helper.searchHelper(component,event,getInputkeyWord);
        helper.hideSpinner(component);
    },
    
    onblur : function(component,event,helper){
        
        component.set("v.displayList", null );
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    keyPressController : function(component, event, helper) {        
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        var getOriginalList = component.get("v.listOfSearchRecords");
        component.set("v.displayList", null);
        var tempArray = [];
        var count = 0;
        var str = String(getInputkeyWord).toUpperCase();
        console.log("Search Keyword" + getInputkeyWord);
        console.log("Original list " + getOriginalList);
        console.log(str);
        
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.
          
        if(str != ""){
            var forOpen = component.find("searchRes");
            $A.util.addClass(forOpen, 'slds-is-open');
            $A.util.removeClass(forOpen, 'slds-is-close');
            
            for(var i = 0; i < getOriginalList.length;i++){
                if(getOriginalList[i].product.includes(str)){
                   tempArray[count] = getOriginalList[i];
                   count++;
                }
            }
            component.set("v.displayList", tempArray);
         
        }
        else{  
           // component.set("v.listOfSearchRecords", null ); 
            var forclose = component.find("searchRes");
            $A.util.addClass(forclose, 'slds-is-close');
            $A.util.removeClass(forclose, 'slds-is-open');
        }
        
    },
    
})