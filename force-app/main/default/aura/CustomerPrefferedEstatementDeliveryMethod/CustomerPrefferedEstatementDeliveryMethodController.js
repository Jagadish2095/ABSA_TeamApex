({
    // Update prefferedEstatementMethod on CIF or ccApplication data map, for api consumption
	onRadioChange: function (component, event) {
		var result = event.getParam("value");
        var dataMap = component.get("v.dataMap");

        if(dataMap == ""){
            dataMap = new Map();
        }else{
            dataMap = JSON.parse(dataMap);
        }

        dataMap["prefferedEstatementMethod"] = result;
        component.set("v.dataMap", JSON.stringify(dataMap));
    }
})