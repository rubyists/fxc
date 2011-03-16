function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <modules>
        {each(doc.modules, function(i, module){
          return <load module={module} />
        })}
      </modules>
    </configuration>
  </section>
</document>
  );
}
