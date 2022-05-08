@isTest
public class Base_IB_Test extends Base_IB{

    public cls_Assessment Assessment;
    public class cls_Assessment {
        public String AssessmentID;        //3ff4bafbb98e448a8289ee9081f6743e
        public Integer AssessmentKeyID;              //15
        public cls_Locales[] Locales;
    }
    public class cls_Locales {
        public cls_Locale Locale;
    }
    public class cls_Locale {
        public String LocaleName;            //en-US
        public String TestName; //Data Warehousing Concepts
        public Integer TypeNum;              //10
        public Boolean Flag;
    }

    public override void setIntegrationTranslations(){

        integrationTranslationsMap = new Map<String, String>();

        integrationTranslationsMap.put('Assessment.AssessmentID', 'TestSystem;TestType');
        integrationTranslationsMap.put('Assessment.Locales.Locale.TestName', 'TestSystem;TestType');

    }

    public override void setRequiredFields(){

        requiredFieldsSet = new Set<String>();

        requiredFieldsSet.add('Assessment.AssessmentID');
        requiredFieldsSet.add('Assessment.AssessmentKeyID');
        requiredFieldsSet.add('Assessment.Locales.Locale.TestName');
        requiredFieldsSet.add('Assessment.Locales.Locale.TypeNum');

    }

    public override void setMaskedFields(){

        maskedFieldsSet = new Set<String>();

        maskedFieldsSet.add('Assessment.AssessmentID');
        maskedFieldsSet.add('Assessment.Locales.Locale.Flag');

    }

    // PJAIN: 20200523
    // Not my method, but writing this method to bring code coverage up
    public override void setFieldNameSubstitutions(){

        fieldNameSubstitutionMap = new Map<String,String>();
        fieldNameSubstitutionMap.put('"AssessmentID":', '"AssessmentID_Z":');
    }

    public Base_IB_Test() {

        //Test the method in the Base Bean Class
        super.setFieldNameSubstitutions(); // PJAIN: 20200523
        super.setIntegrationTranslations(); // JQUEV: 20201023
        super.setRequiredFields();
        super.setMaskedFields();
        //Test the method in the Child of the Base Bean Class
        setFieldNameSubstitutions(); // PJAIN: 20200523
        setRequiredFields();
        setMaskedFields();

    }

    @isTest static void testBaseBean() {

        Base_IB_Test baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        baseBean.Assessment.Locales = new List<Base_IB_Test.cls_Locales>();
        Base_IB_Test.cls_Locale locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something1';
        locale.TestName = 'asdfasdf';
        locale.TypeNum = 11;
        locale.Flag = false;
        Base_IB_Test.cls_Locales locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something2';
        locale.TestName = 'hgjhgjghj';
        locale.TypeNum = 100;
        locale.Flag = true;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        baseBean.Assessment.AssessmentID = 'test';
        baseBean.Assessment.AssessmentKeyID = 10;
        System.debug(baseBean.validate());
        System.debug(baseBean.getMaskedJSON());
        System.debug(JSON.serialize(baseBean));

        baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        baseBean.Assessment.Locales = new List<Base_IB_Test.cls_Locales>();
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something1';
        locale.TestName = '';
        locale.TypeNum = 11;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something2';
        locale.TestName = 'hgjhgjghj';
        locale.TypeNum = 100;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        baseBean.Assessment.AssessmentID = 'test';
        baseBean.Assessment.AssessmentKeyID = 10;
        System.debug(baseBean.validate());

        baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        baseBean.Assessment.AssessmentID = 'test';
        baseBean.Assessment.AssessmentKeyID = 10;
        System.debug(baseBean.validate());

        baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        baseBean.Assessment.Locales = new List<Base_IB_Test.cls_Locales>();
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something1';
        locale.TestName = 'asdfasdf';
        locale.TypeNum = 11;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something2';
        locale.TestName = 'hgjhgjghj';
        locale.TypeNum = 100;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        System.debug(baseBean.validate());

        baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        System.debug(baseBean.validate());
        System.debug(baseBean.getMaskedJSON());
        System.debug(JSON.serialize(baseBean));

    }

    // PJAIN: 20200523
    // Not my method, but writing this method to bring code coverage up
    @isTest
    public static void testSerializeDeserializeFieldNameSubstitution() {

        Base_IB_Test baseBean = new Base_IB_Test();
        baseBean.Assessment = new Base_IB_Test.cls_Assessment();
        baseBean.Assessment.Locales = new List<Base_IB_Test.cls_Locales>();
        Base_IB_Test.cls_Locale locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something1';
        locale.TestName = 'asdfasdf';
        locale.TypeNum = 11;
        locale.Flag = false;
        Base_IB_Test.cls_Locales locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        locale = new Base_IB_Test.cls_Locale();
        locale.LocaleName = 'something2';
        locale.TestName = 'hgjhgjghj';
        locale.TypeNum = 100;
        locale.Flag = true;
        locales = new Base_IB_Test.cls_Locales();
        locales.Locale = locale;
        baseBean.Assessment.Locales.add(locales);
        baseBean.Assessment.AssessmentID = 'test';
        baseBean.Assessment.AssessmentKeyID = 10;

        String jsonString = baseBean.serialize(baseBean);
        System.assert(String.isNotBlank(jsonString));

        baseBean = (Base_IB_Test) baseBean.deserialize(jsonString, Base_IB_Test.class);
        System.assertNotEquals(null, baseBean);

        String replacedJsonString = baseBean.substituteFieldNames(jsonString, StringConstants.INBOUND_RECORD_TYPE);
        System.assertNotEquals(jsonString, replacedJsonString);
    }
}