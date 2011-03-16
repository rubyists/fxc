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
        {each(doc.profiles, function(name, profile){
          return <profile name={name}>{
            each(profile, function(name, value){
              return <param name={name} value={value} />
            })
          }</profile>
        })}
      </profiles>
    </configuration>
  </section>
</document>
  );
}
