({
    collapsibleRowsHelper: function(component, clicked_row_id, icon_name) {
        let dataRows = component.get("v.transactionsList");

        let new_index = dataRows.findIndex(x => x.index === clicked_row_id);
        dataRows[new_index].icon_class = icon_name;

        if (icon_name == 'circle_icon_plus') {
            dataRows[new_index].row_class = ' '; //close
        }
        if (icon_name == 'circle_icon_minus') {
            dataRows[new_index].row_class = ' bground '; //open
        }
        let last_index = '';
        
        let clickedTransactions = component.get("v.clickedTransactions");
        
        //show/hide expandedRows
        for (let key in dataRows) {
            if (dataRows[key].parent_index == dataRows[new_index].index) {
                
                if(!clickedTransactions.includes(dataRows[key].parent_index)){
                    clickedTransactions.push(dataRows[key].parent_index);
                } 
                
         
                if (icon_name == 'circle_icon_plus') {
                    dataRows[key].row_class = 'hide ';
                    
                    //remove
                    if(clickedTransactions.includes(dataRows[key].index)){
                        clickedTransactions.splice( clickedTransactions.indexOf(dataRows[key].index), 1 );
                    }
                    
                    if(clickedTransactions.includes(dataRows[key].parent_index)){
                        clickedTransactions.splice( clickedTransactions.indexOf(dataRows[key].parent_index), 1 );
                    }                      
                }
                if (icon_name == 'circle_icon_minus') {
                    dataRows[key].row_class = ' bground ';
                    last_index = key;
                    
                    //add
                    if(!clickedTransactions.includes(dataRows[key].index)){
                        clickedTransactions.push(dataRows[key].index);
                    }                    
                }
            }
        }

        console.log(clickedTransactions);
        component.set("v.clickedTransactions", clickedTransactions);
        
        if (last_index)
            dataRows[last_index].row_class = ' last_expandable_row_class ';
        

        component.set("v.transactionsList", dataRows); 
    }
})