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
      
      <profiles>
        {each(doc.profiles, function(name, params){
          var xml = <profile name={name}><email /></profile>;
          for(key in params.settings){
            xml.profile += <param name={key} value={params.settings[key]} />;
          }
          for(key in params.email){
            xml.email.email += <param name={key} value={params.email[key]} />;
          }
          return xml;
        })}
      </profiles>
    </configuration>
  </section>
</document>
  );
}
