function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <settings>
        {each(doc.settings, function(name, value){
          return <param name={name} value={value} />
        })}
      </settings>
      
      <schema>
        {each(doc.schema, function(name, args){
          var field = <field var={name} />;
          each(args, function(key, value){ field.@[key] = value });
          return field;
        })}
      </schema>
    </configuration>
  </section>
</document>
  );
}