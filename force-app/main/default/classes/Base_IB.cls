/**
* Base Bean Class extended by all other bean classes for validation and masking
* @author  Jason Quevauvilliers
* @created 2018-08-23
*
* PJAIN: 20200523: Added class and method name to System.debug lines for easy identification
*
*/
public abstract class Base_IB{

    public static Map<String, String> fieldNameSubstitutionMap;// Map of External values (Key) to Internal values (Value)
    public static Map<String, String> integrationTranslationsMap; // In case of hierarchical JSON structure, the field name should include the full path using dot notation e.g. Object1.Object2.Field1
    public static Set<String> requiredFieldsSet; // In case of hierarchical JSON structure, the field name should include the full path using dot notation e.g. Object1.Object2.Field1
    public static Set<String> maskedFieldsSet; // In case of hierarchical JSON structure, the field name should include the full path using dot notation e.g. Object1.Object2.Field1

    //validates the object by going through all the required fields and builds an error message if they are blank
    public String validate(){

        setRequiredFields();
        String errorMessage = '';

        for(String requiredField :  requiredFieldsSet){

            if(!isFieldPresent(this, requiredField.split('\\.'))){

                errorMessage += requiredField + ', ';
            }
        }

        if(String.isNotBlank(errorMessage)){

            errorMessage = 'The following required fields are missing: ' + errorMessage.removeEnd(', ');
        }

        return errorMessage;
    }

    public String getMaskedJSON(){

        setMaskedFields();
        Object obj = this;

        for(String maskedField :  maskedFieldsSet){

            obj = setFieldValue(obj, maskedField.split('\\.'), StringConstants.MASK_STRING);
        }

        return JSON.serialize(obj, true);
    }

    //Child classes will only override this method if needed to set required fields
    public virtual void setRequiredFields(){

        requiredFieldsSet = new Set<String>();
    }

    //Child classes will only override this method if needed to mask fields
    public virtual void setMaskedFields(){

        maskedFieldsSet = new Set<String>();
    }

    //Child classes will only override this method if needed to substitute field names
    public virtual void setFieldNameSubstitutions(){

        fieldNameSubstitutionMap = new Map<String,String>();
    }

    // PJAIN: 20201018: Child classes will only override this method if needed to translate field values
    public virtual void setIntegrationTranslations(){
        integrationTranslationsMap = new Map<String,String>();
    }

    //Returns the value associated with a field(key) for an object(obj)
    public static Object getValue(Object obj, String key){

        String jsonStr = JSON.serialize(obj, true);
        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
        return untypedMap.get(key);
    }
    //adds a value to a field(key) for an object(obj)
    public static Object putValue(Object obj, String key, Object value){

        String jsonStr = JSON.serialize(obj, true);
        Map<String, Object> untypedMap = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);
        untypedMap.put(key, value);
        return untypedMap;
    }

    //checks if a field has a value in it from the field path specified
    private boolean isFieldPresent(Object obj, List<String> fieldPath){

        String key = fieldPath.remove(0);
        obj = Base_IB.getValue(obj, key);

        if(obj == null || String.isBlank(String.valueOf(obj))){

            return false;
        }
        if(fieldPath.size() == 0){

            return true;
        }
        if(obj instanceOf List<Object>){

            List<Object> objList = (List<Object>) obj;
            for(Object objEntry : objList){

                if(!isFieldPresent(objEntry, fieldPath.clone())){

                    return false;
                }
            }

            return true;

        }else{

            return isFieldPresent(obj, fieldPath);
        }
    }

    // PJAIN: 20201018: returns a value from the field path specified if it exists. Else returns null
    /* the method is commented as it is not needed right now. But can be un-commented, if needed
    private Object getFieldValue(Object obj, List<String> fieldPath){

        String key = fieldPath.remove(0);
        obj = Base_IB.getValue(obj, key);

        if(obj == null || String.isBlank(String.valueOf(obj))){

            return null;
        }
        if(fieldPath.size() == 0){

            return obj;
        }
        if(obj instanceOf List<Object>){

            List<Object> objList = (List<Object>) obj;
            for(Object objEntry : objList){

                if(getFieldValue(objEntry, fieldPath.clone()) == null){

                    return null;
                }
            }

            return obj;

        }else{

            return getFieldValue(obj, fieldPath);
        }
    } */

    // PJAIN: 20201018: Sets a field at the field path specified for an object
    private Object setFieldValue(Object obj, List<String> fieldPath, String fieldValue){

        String key = fieldPath.remove(0);
        Object value = Base_IB.getValue(obj, key);

        if(value == null){

            return obj;
        }
        if(fieldPath.size() == 0){

            return Base_IB.putValue(obj, key, fieldValue);
        }

        if(value instanceOf List<Object>){

            List<Object> objList = (List<Object>) value;
            List<Object> modifiedObject = new List<Object>();
            for(Object objEntry : objList){
                modifiedObject.add(setFieldValue(objEntry, fieldPath.clone(), fieldValue));
            }

            return Base_IB.putValue(obj, key, (Object)modifiedObject);

        }else{

            value = setFieldValue(value, fieldPath, fieldValue);
            return Base_IB.putValue(obj, key, value);
        }
    }

    // PJAIN: 20201018: Translates the values in the object to Internal values
    public Object translateValues(Object obj, String direction){
        setIntegrationTranslations();

        if (integrationTranslationsMap != null && !integrationTranslationsMap.isEmpty()) {
            for(String fieldPath :  integrationTranslationsMap.keySet()){
                obj = translateFieldValue(obj, fieldPath.split('\\.'), direction, integrationTranslationsMap.get(fieldPath));
            }

            System.debug('Base_IB.translateValues.Object after translation: ' + obj);
        }

        return obj;
    }

    // PJAIN: 20201018: translates the field value at the specified position using integration translations
    private Object translateFieldValue(Object obj, List<String> fieldPath, String direction, String integrationTranslationDetails){

        String key = fieldPath.remove(0);
        Object value = Base_IB.getValue(obj, key);

        if(value == null || String.isBlank(String.valueOf(value))){

            return obj;
        }
        if(fieldPath.size() == 0){

            String currentFieldValue = String.valueOf(value);
            String translatedValue;
            List<String> integrationTranslationDetailsList = integrationTranslationDetails?.split(';');

            if (String.isNotBlank(currentFieldValue) && integrationTranslationDetailsList != null && integrationTranslationDetailsList.size() >= 2) {
                String systemName = integrationTranslationDetailsList[0];
                String valueType = integrationTranslationDetailsList[1];

                if (direction == StringConstants.INBOUND_RECORD_TYPE) {
                    translatedValue = Sys_Utilities_Integration.getIntegrationTranslationInternalValue(systemName, valueType, currentFieldValue, direction);
                } else if (direction == StringConstants.OUTBOUND_RECORD_TYPE) {
                    translatedValue = Sys_Utilities_Integration.getIntegrationTranslationExternalValue(systemName, valueType, currentFieldValue, direction);
                }
            }

            if (String.isNotBlank(translatedValue)) {

                return Base_IB.putValue(obj, key, translatedValue);
            } else if (integrationTranslationDetailsList != null && integrationTranslationDetailsList.size() >= 3) {

                String defaultValue = integrationTranslationDetailsList[2];
                return Base_IB.putValue(obj, key, defaultValue);
            } else {

                return obj;
            }
        }

        if(value instanceOf List<Object>){

            List<Object> objList = (List<Object>) value;
            List<Object> modifiedObject = new List<Object>();
            for(Object objEntry : objList){
                modifiedObject.add(translateFieldValue(objEntry, fieldPath.clone(), direction, integrationTranslationDetails));
            }

            return Base_IB.putValue(obj, key, (Object)modifiedObject);

        }else{

            value = translateFieldValue(value, fieldPath, direction, integrationTranslationDetails);
            return Base_IB.putValue(obj, key, value);
        }
    }

    public String substituteFieldNames(String jsonStringP, String direction){

        setFieldNameSubstitutions();

        if(fieldNameSubstitutionMap != null && !fieldNameSubstitutionMap.isEmpty()){

            // The JSON Sting can have newline, leading and trailing spaces.
            // The below line removes those unnecessary whitespace characters. This would help
            // with field name substitutions without discrepancies around such whitespace characters.
            jsonStringP = JSON.serialize( JSON.deserializeUntyped( jsonStringP ), true );

            for(String fieldName : fieldNameSubstitutionMap.keySet()){
                if (direction == StringConstants.INBOUND_RECORD_TYPE) {
                    jsonStringP = jsonStringP.replace(fieldName, fieldNameSubstitutionMap.get(fieldName));
                } else if (direction == StringConstants.OUTBOUND_RECORD_TYPE) {
                    jsonStringP = jsonStringP.replace(fieldNameSubstitutionMap.get(fieldName), fieldName);
                }
            }

            System.debug('Base_IB.substituteFieldNames.JSON after replace: ' + jsonStringP);
        }

        return jsonStringP;
    }

    public Object deserialize(String jsonStringP, System.Type apexTypeP){
        Object bean;

        if (String.isNotBlank(jsonStringP)) {
            // PJAIN: 20200910: Below code is to wrap the JSON response in "body" tag when an Array is returned rather than an object
            if (jsonStringP.startsWith('[') && jsonStringP.endsWith(']')) {
                jsonStringP = '{"body":' + jsonStringP + '}';
            }

            jsonStringP = substituteFieldNames(jsonStringP, StringConstants.INBOUND_RECORD_TYPE);

            bean = JSON.deserialize( jsonStringP, apexTypeP );

            // PJAIN: 20201018: Translate values in internal values using integration translations
            bean = translateValues(bean, StringConstants.INBOUND_RECORD_TYPE);

            if (bean instanceOf Map<String, Object>) {
                // The translateValues method returns a Map of <String, Object> if any translations were performed.
                // The below line converts to a response bean object.
                bean = JSON.deserialize(JSON.serialize(bean, true), apexTypeP);
            }
        } else {
            bean = apexTypeP.newInstance();
        }

        return bean;
    }

    public String serialize(Object beanP){
        // PJAIN: 20201018: Translate values in external values using integration translations
        beanP =  translateValues(beanP, StringConstants.OUTBOUND_RECORD_TYPE);

        String jsonString = JSON.serialize( beanP, true );

        // PJAIN: 20201029: Below code is to remove the placeholderTopLevelArray object so that an Array can be sent as a request
        if (String.isNotBlank(jsonString) && jsonString.startsWithIgnoreCase('{"placeholderTopLevelArray":[') && jsonString.endsWith(']}')) {
            jsonString = jsonString.removeStartIgnoreCase('{"placeholderTopLevelArray":').removeEnd('}');
        }

        jsonString = substituteFieldNames(jsonString, StringConstants.OUTBOUND_RECORD_TYPE);

        return jsonString;
    }

    // PJAIN: 20200523: Added 3 fields which are common for all beans
    public String status;
    public Integer statusCode;
    public String message;

    public cls_Fault Fault;

    public class cls_Fault{
        public String faultcode;
        public String faultstring;
        public cls_detail detail;
    }

    public class cls_detail{
        public cls_ExceptionDetail ExceptionDetail;
    }

    public class cls_ExceptionDetail extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }

    public class cls_HelpLink{}

    public class cls_InnerExceptionCls extends cls_ExceptionBase{
        public cls_InnerExceptionCls InnerException;
        public cls_HelpLink HelpLink;
    }

    public abstract class cls_ExceptionBase{
        public String innerExceptionType; //Type
        public String StackTrace;
        public String Message;
    }

}