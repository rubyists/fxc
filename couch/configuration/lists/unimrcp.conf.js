function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <settings>{
        each(doc.settings, function(name, value){
          return <param name={name} value={value} />
        })
      }</settings>
      <profiles>{
        each(doc.profiles, function(name, obj){
          return <profile name={name} version={obj.version}>{
            each(obj.params, function(name, value){
              return <param name={name} value={value} />
            })
          }<synthparams>{
            each(obj.synthparams, function(name, value){
              return <param name={name} value={value} />
            })
          }</synthparams>
          <recogparams>{
            each(obj.recogparams, function(name, value){
              return <param name={name} value={value} />
            })
          }</recogparams>
          </profile>
        })
      }</profiles>
    </configuration>
  </section>
</document>
  );
}
