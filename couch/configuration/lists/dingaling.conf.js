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
      {each(doc.profiles, function(type, params){
        return(
          <profile type={type}>
            {each(params, function(name, value){
              return <param name={name} value={value} />
            })}
          </profile>
        )
      })}
    </configuration>
  </section>
</document>
  );
}
