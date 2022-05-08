({
	//Initiation of component
	initComp: function(component, event, helper) {
		helper.getProductList(component);
        
    },
    
 
   
    changeView : function(component, event, helper){
        
        
        var showValue = component.get('v.showView');
        console.log('showValue---',showValue);
        
        if(showValue === true){
            showValue = false;
           
        }else {
             showValue = false;
           // component.set('v.showView',showValue);
            
        } 
      component.set('v.showView',showValue);
     
    }, 

})