function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <menus>
        {each(doc.menus, function(name, obj){
          var menu_tag = <menu>
            {each(obj.entries, function(i, entry){
              var entry_tag = <entry />;
              each(entry, function(name, value){ entry_tag.@[name] = value })
              return entry_tag
            })}
          </menu>;

          each(obj.attributes, function(name, value){
            menu_tag.@[name] = value
          })
          return menu_tag
        })}
      </menus>
    </configuration>
  </section>
</document>
  );
}
