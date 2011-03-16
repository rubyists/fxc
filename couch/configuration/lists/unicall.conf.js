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
      <spans>{
        each(doc.spans, function(id, params){
          return <span id={id}>{
            each(params, function(name, value){
              return <param name={name} value={value} />
            })
          }</span>
        })
      }</spans>
    </configuration>
  </section>
</document>
  );
}
