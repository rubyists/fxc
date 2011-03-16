function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <bindings>
        {each(doc.bindings, function(name, binding){
          var xml = <binding name={name} />;
          for(key in binding){
            var value = binding[key];
            if(key === "gateway-url"){
              xml.binding += <param name={key} value={value.value}  bindings={value.bindings} />;
            } else {
              xml.binding += <param name={key} value={value} />;
            }
          }
          return xml;
        })}
      </bindings>
    </configuration>
  </section>
</document>
  );
}
