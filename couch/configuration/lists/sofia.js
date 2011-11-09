function(head, req){
  var sofia = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={sofia.name} description={sofia.description}>
      <global_settings>
        {each(sofia.global_settings, function(name, value){
          return <param name={name} value={value} />
        })}
      </global_settings>
      <profiles>
        {each(sofia.profiles, function(name, profile){
          return <profile name={name}>
            <aliases>
              {each(profile.aliases, function(idx){
                return <alias name={profile.aliases[idx]} />
              })}
            </aliases>
            <gateways>
              {each(profile.gateways, function(name, params){
                var xml = <gateway name={gateway.name} />;
                for(var name in params){
                  xml.gateway += <param name={name} value={params[name]} />;
                }
                return xml;
              })}
            </gateways>
            <domains>
              {each(profile.domains, function(name, obj){
                return <domain name={name} alias={obj.alias} parse={obj.parse} />
              })}
            </domains>
            <settings>
              {each(profile.settings, function(name, value){
                return <param name={name} value={value} />
              })}
            </settings>
          </profile>
        })}
      </profiles>
    </configuration>
  </section>
</document>);
}
