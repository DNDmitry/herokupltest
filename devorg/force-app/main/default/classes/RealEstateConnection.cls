global class RealEstateConnection extends DataSource.Connection {
      override global List<DataSource.TableResult> search(DataSource.SearchContext searchContext) { 
      	return DataSource.SearchUtils.searchByName(searchContext, this);
      }
      
      override global List<DataSource.Table> sync() {
  		List<DataSource.Column> columns = new List<DataSource.Column>();
  		columns.add(DataSource.Column.text('ExternalId', 255));
  		columns.add(DataSource.Column.url('DisplayUrl'));
  		columns.add(DataSource.Column.text('Name', 128));
  		columns.add(DataSource.Column.text('city', 128));
  		columns.add(DataSource.Column.text('price', 128));
  		List<DataSource.Table> tables = new List<DataSource.Table>();
  		tables.add(DataSource.Table.get('Properties', 'Name', columns));
  		return tables;
      }

      override global DataSource.TableResult query(DataSource.QueryContext queryContext) {
          List<Map<String, Object>> properties = DataSource.QueryUtils.process(queryContext, getProperties());
   		DataSource.TableResult tableResult = DataSource.TableResult.get(queryContext, properties);
   		return tableResult;
 		}
      public List<Map<String, Object>> getProperties() {
   		Http httpProtocol = new Http();
   		HttpRequest request = new HttpRequest();
   		String url = 'https://ionic2-realty-rest-demo.herokuapp.com/properties/';
   		request.setEndPoint(url);
   		request.setMethod('GET');
   		HttpResponse response = httpProtocol.send(request);
   		List<Map<String, Object>> properties = new List<Map<String, Object>>();
   		for (Object item : (List<Object>)JSON.deserializeUntyped(response.getBody())) {
   		  Map<String, Object> property = (Map<String, Object>)item;
          property.put('ExternalId', property.get('id'));
     	  property.put('DisplayUrl', 'https://ionic2-realty-rest-demo.herokuapp.com/');
          property.put('Name', property.get('title'));
     	  properties.add(property);
   		}
   		return properties;
      }
}