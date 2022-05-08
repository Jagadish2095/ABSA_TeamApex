({
    profileTabToolTipClassMap: function(idVal) {
        var classMap = {'access_account_number': 'tooltip-accNum', 'id_number': 'tooltip-idNum','cust_client_code': 'tooltip-cccode','combi_card_number': 'tooltip-comcard','cell_number': 'tooltip-cellnum'}; 
        return classMap[idVal];        
    },
})