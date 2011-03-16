function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <timezones>
        {each(doc.timezones, function(name, value){
          return(
            <zone name={name} value={value} />
          )})}
      </timezones>
    </configuration>
  </section>
</document>
  );
}
