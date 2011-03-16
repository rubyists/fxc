function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <feeds>{
        each(doc.feeds, function(name, value){
          return <feed name={name}>{value}</feed>
        })
      }</feeds>
    </configuration>
  </section>
</document>
  );
}
