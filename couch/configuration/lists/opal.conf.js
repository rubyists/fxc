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
      <listeners>{
        each(doc.listeners, function(name, params){
          return <listener name={name}>{
            each(params, function(name, value){
              return <param name={name} value={value} />
            })
          }</listener>
        })
      }</listeners>
    </configuration>
  </section>
</document>
  );
}
