({ 
    afterRender: function (component) {
        this.superAfterRender();
        
        var value = [{
            type: 'user',
            id: component.get("v.userid"),
            label: component.get("v.currentUserName"),
        }];
        component.set("v.customvalue",value);
         console.log('user'+component.get("v.userid"));
        component.find("referralIdopp1").get("v.body")[0].set("v.values", value);
        component.find("referralIdopp2").get("v.body")[0].set("v.values", value);
        component.set("v.referralLead.DD_Agent_Who_Referred_Lead__c",component.get("v.userid"));
       
        
    }
})