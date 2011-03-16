function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <cli-keybindings>
        {each(doc.keybindings, function(name, value){
          return <key name={name} value={value} />
        })}
      </cli-keybindings>
      <settings>
        {each(doc.settings, function(name, value){
          return <param name={name} value={value} />
        })}
      </settings>
    </configuration>
  </section>
</document>
  );
}
