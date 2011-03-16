function(head, req){
  var doc = getRow().value;

  send(
<document type="freeswitch/xml">
  <section name="configuration">
    <configuration name={doc.name} description={doc.description}>
      <descriptors>
        {each(doc.descriptors, function(descriptor_name, tones){
          return(
            <descriptor name={descriptor_name}>
              {each(tones, function(tone_name, elements){
                return(
                  <tone name={tone_name}>
                    {each(elements, function(idx, attributes){
                      var element = <element />;
                      for(key in attributes){ element.@[key] = attributes[key]; }
                      return element;
                    })}
                  </tone>
                )})}
            </descriptor>
          )})}
      </descriptors>
    </configuration>
  </section>
</document>
  );
}
