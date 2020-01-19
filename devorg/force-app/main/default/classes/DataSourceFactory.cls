public with sharing class DataSourceFactory {
   public IDataSource getDataSource() {
       DataSourceConfig__c config = DataSourceConfig__c.getInstance();  // Custom setting defined in the package
       String className = config.Class_Name__c;
       IDataSource dsc = (IDataSource) Type.forName(className).newInstance();
       return dsc;
   }
}