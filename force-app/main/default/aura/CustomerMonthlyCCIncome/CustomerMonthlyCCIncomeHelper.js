({
	helperMethod : function() {
		
	},
	
	save : function(component) {

        let incomeInformation = new Map();
        incomeInformation["Total_Gross_Monthly_Income"] = component.find("grossIncome").get("v.value");
        incomeInformation["Total_Net_Monthly_Income"] = component.find("netIncome").get("v.value");
        incomeInformation["Rental_Income"] = component.find("rentalIncome").get("v.value");
        incomeInformation["Other_Additional_Income"] = component.find("additionalIncome").get("v.value");
        

        var ccApplicationDataMap = component.get("v.ccApplicationDataMap");
        if(ccApplicationDataMap == ""){

            ccApplicationDataMap = new Map();
            console.error(`ccApplicationDataMap expected!`);
        }
        else{
            ccApplicationDataMap = JSON.parse(ccApplicationDataMap);
        }

        ccApplicationDataMap["incomeInformation"] = incomeInformation;
        component.set("v.ccApplicationDataMap", JSON.stringify(ccApplicationDataMap));
    }
})