({
	IIPHandler : function(component, event, helper) {                
        component.set("v.IIPHoldAction", event.target.name);
        component.set("v.IIPHoldModal", true);
          
        //Get selected recording using Id
        var iipObj = component.get("v.data.iipsData"); 
         
        //load it 
        component.set("v.selectedIIP", iipObj[event.currentTarget.id]);
        component.set("v.IIPHoldModal", true);           		
	},    
})