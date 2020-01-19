public class FieldService {
    
    public static List<String> getNonRequiredFields(String objectName) {
        system.debug('getNonRequiredFields');
        List<String> nonRequiredFields = new List<String>();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Schema.DescribeSObjectResult describeObject = globalDescribe.get(objectName).getDescribe();
        Map<String, Schema.SObjectField> objectFields = describeObject.fields.getMap();
        
        for (String fieldName : objectFields.keySet()) {
            Schema.DescribeFieldResult describeField = objectFields.get(fieldName).getDescribe();
            if (describeField.isNillable() && !describeField.isDefaultedOnCreate()) {                
                nonRequiredFields.add(fieldName);
            }
        }
        return nonRequiredFields;
    }

}