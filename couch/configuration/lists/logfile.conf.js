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
          var settings = <settings />;
          for(key in profile.settings){
            settings.settings += <param name={key} value={profile.settings[key]} />;
          }

          var mappings = <mappings />;
          for(key in profile.mappings){
            mappings.mappings += <map name={key} value={profile.mappings[key]} />;
          }

          return <profile name={name}>{settings}{mappings}</profile>;
        })}
      </profiles>
    </configuration>
  </section>
</document>
  );
}
