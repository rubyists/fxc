function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <javavm path={doc.javavm} />
      <options>
        {each(doc.options, function(i, value){
          return <option value={value} />
        })}
      </options>

      <startup class={doc.startup.class} method={doc.startup.method} arg={doc.startup.arg} />
      <shutdown class={doc.shutdown.class} method={doc.shutdown.method} arg={doc.shutdown.arg}/>
    </configuration>
  </section>
</document>
  );
}
