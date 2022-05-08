/**
* @description       : Add Document Request class for CIS
* @author            : Mohammed Junaid U
* @group             :
* @last modified on  : 05-25-2021
* @last modified by  : Sandeep Golla
* Modifications Log
* Ver   Date         Author              Modification
* 1.0   2021-05-24   Mohammed Junaid U   Initial Version
**/

public class CIS_AddDocRequest_IB_v1 extends Base_IB {
    
    public String FileName;
    public list<FieldValue> FieldValues;
    public String ItemType;
    public String Data;
    public String Token;
    /**
* @description
*/
    public class FieldValue{
        public String Name;
        public String Value;
    }
    
    /**
* @description to map the values to payload
* @param name
* @param value
*/
    public void addFieldValue(String name, String value) {
        if (FieldValues == null) {
            FieldValues =new List<FieldValue>();
        }
        FieldValue fv = new FieldValue();
        fv.Name = name;
        fv.value = value;
        FieldValues.add(fv);
    }
    /**
* @description constructor
*/
    public CIS_AddDocRequest_IB_v1(){}
}