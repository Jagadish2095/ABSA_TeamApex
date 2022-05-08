public class ECM_AddRequest_IB_V1 {
	
    public AddRequest AddRequest { get; set; }
    
    public class AddRequest {
        public String Token { get; set; }
        public String ItemType { get; set; }
        public String FileName { get; set; }
        public FieldValues FieldValues { get; set; }
        public String Data { get; set; }      
        
        public void addFieldValue(String name, String value) {
            if (FieldValues == null) {
                FieldValues = new FieldValues();
            }
            if (FieldValues.FieldValue == null) {
                FieldValues.FieldValue = new List<FieldValue>();
            }
            FieldValue fv = new FieldValue();
            fv.Name = name;
            fv.value = value;
            FieldValues.FieldValue.add(fv);
    	}
    }
    
    public class FieldValues {
        
        public List<FieldValue> FieldValue;
        
    }
    
    public class FieldValue {
        public String Name { get; set; }
        public String Value { get; set; }
    }
    
    public ECM_AddRequest_IB_V1 fromGetResult(ECM_GetResult_IB_V1 source) {
    	ECM_AddRequest_IB_V1 dest = new ECM_AddRequest_IB_V1();
    	AddRequest req = new AddRequest();
    	ECM_GetResult_IB_V1.MetaData meta = source.MetaData;
    	req.ItemType = meta.ItemType;
    	for (ECM_GetResult_IB_V1.ECM_Field f : meta.Fields.Field) {
    		if (!String.isBlank(f.value)) {
    			req.addFieldValue(f.name, f.value);
    		}
    	}
    	dest.AddRequest = req;
    	return dest; 
    	
    }
}